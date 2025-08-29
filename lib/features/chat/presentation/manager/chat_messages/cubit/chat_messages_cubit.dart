import 'dart:async';
import 'package:elsadeken/features/chat/data/repositories/chat_repo.dart';
import 'package:elsadeken/features/chat/data/models/chat_conversation_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final ChatRepoInterface repo;
  Timer? _refreshTimer;
  
  // Cache for storing loaded messages by chat ID
  final Map<String, ChatMessagesState> _messageCache = {};
  
  // Cache timestamp to know when data was last loaded
  final Map<String, DateTime> _cacheTimestamps = {};
  
  // Cache validity duration (5 minutes)
  static const Duration _cacheValidity = Duration(minutes: 5);

  ChatMessagesCubit(this.repo) : super(ChatMessagesInitial());

  /// Get chat messages with caching - loads from cache if available and fresh
  Future<void> getChatMessages(String chatId) async {
    // Check if we have cached data that's still valid
    if (_isCacheValid(chatId)) {
      print('[ChatMessagesCubit] Loading messages from cache for chat $chatId');
      emit(_messageCache[chatId]!);
      return;
    }

    // No valid cache, load from API
    print('[ChatMessagesCubit] Loading messages from API for chat $chatId');
    emit(ChatMessagesLoading());

    final result = await repo.getChatMessages(chatId);

    result.fold(
      (error) {
        emit(ChatMessagesError(error.message ?? "حدث خطأ ما"));
        // Don't cache error states
      },
      (chatMessages) {
        final loadedState = ChatMessagesLoaded(chatMessages);
        emit(loadedState);
        
        // Cache the successful result
        _cacheMessages(chatId, loadedState);
      },
    );
  }

  /// Refresh chat messages and update cache
  Future<void> refreshChatMessages(String chatId) async {
    print('[ChatMessagesCubit] Refreshing messages for chat $chatId');
    
    final result = await repo.getChatMessages(chatId);

    result.fold(
      (error) {
        print('[ChatMessagesCubit] Error refreshing messages: ${error.message}');
        emit(ChatMessagesError(error.message ?? "حدث خطأ ما"));
        // Don't cache error states
      },
      (chatMessages) {
        print('[ChatMessagesCubit] Successfully refreshed ${chatMessages.messages.length} messages');
        final loadedState = ChatMessagesLoaded(chatMessages);
        emit(loadedState);
        
        // Update cache with fresh data
        _cacheMessages(chatId, loadedState);
      },
    );
  }

  /// Load only new messages since last cache (for faster loading)
  Future<void> loadNewMessagesOnly(String chatId) async {
    if (!_isCacheValid(chatId)) {
      // No valid cache, load all messages
      await getChatMessages(chatId);
      return;
    }

    final cachedState = _messageCache[chatId];
    if (cachedState is! ChatMessagesLoaded) {
      await getChatMessages(chatId);
      return;
    }

    // Show cached data immediately for fast UI response
    emit(cachedState);
    
    // Load only new messages in background
    print('[ChatMessagesCubit] Loading only new messages for chat $chatId');
    
    try {
      final result = await repo.getChatMessages(chatId);
      
      result.fold(
        (error) {
          print('[ChatMessagesCubit] Error loading new messages: ${error.message}');
          // Keep showing cached data on error
        },
        (chatMessages) {
          // Check if we have new messages
          final cachedMessageCount = cachedState.chatMessages.messages.length;
          final newMessageCount = chatMessages.messages.length;
          
          if (newMessageCount > cachedMessageCount) {
            print('[ChatMessagesCubit] Found ${newMessageCount - cachedMessageCount} new messages');
            final loadedState = ChatMessagesLoaded(chatMessages);
            emit(loadedState);
            _cacheMessages(chatId, loadedState);
          } else {
            print('[ChatMessagesCubit] No new messages found');
          }
        },
      );
    } catch (e) {
      print('[ChatMessagesCubit] Exception loading new messages: $e');
      // Keep showing cached data on exception
    }
  }

  /// Check if cached data is still valid
  bool _isCacheValid(String chatId) {
    if (!_messageCache.containsKey(chatId) || !_cacheTimestamps.containsKey(chatId)) {
      return false;
    }
    
    final cacheAge = DateTime.now().difference(_cacheTimestamps[chatId]!);
    return cacheAge < _cacheValidity;
  }

  /// Cache messages for a specific chat
  void _cacheMessages(String chatId, ChatMessagesState state) {
    _messageCache[chatId] = state;
    _cacheTimestamps[chatId] = DateTime.now();
    print('[ChatMessagesCubit] Cached messages for chat $chatId');
  }

  /// Clear cache for a specific chat
  void clearCache(String chatId) {
    _messageCache.remove(chatId);
    _cacheTimestamps.remove(chatId);
    print('[ChatMessagesCubit] Cleared cache for chat $chatId');
  }

  /// Clear all cache
  void clearAllCache() {
    _messageCache.clear();
    _cacheTimestamps.clear();
    print('[ChatMessagesCubit] Cleared all message cache');
  }

  /// Get cached messages for a chat (without loading from API)
  ChatMessagesState? getCachedMessages(String chatId) {
    if (_isCacheValid(chatId)) {
      return _messageCache[chatId];
    }
    return null;
  }

  /// Handle new message and update cache accordingly
  void handleNewMessage(String chatId, Message newMessage) {
    // Update cache if we have cached data for this chat
    if (_messageCache.containsKey(chatId)) {
      final cachedState = _messageCache[chatId];
      if (cachedState is ChatMessagesLoaded) {
        // Add new message to cached data
        final updatedMessages = List<Message>.from(cachedState.chatMessages.messages);
        
        // Check if message already exists to avoid duplicates
        if (!updatedMessages.any((msg) => msg.id == newMessage.id)) {
          updatedMessages.add(newMessage);
          
          // Create updated state with new message
          final updatedState = ChatMessagesLoaded(
            ChatMessagesConversation(
              chatId: cachedState.chatMessages.chatId,
              messages: updatedMessages,
            )
          );
          
          // Update cache with new data
          _cacheMessages(chatId, updatedState);
          
          print('[ChatMessagesCubit] Updated cache for chat $chatId with new message: ${newMessage.id}');
        }
      }
    }
  }

  /// Update cache with new messages from real-time sources (Pusher, etc.)
  void updateCacheWithNewMessages(String chatId, List<Message> newMessages) {
    if (_messageCache.containsKey(chatId)) {
      final cachedState = _messageCache[chatId];
      if (cachedState is ChatMessagesLoaded) {
        // Merge new messages with cached messages
        final updatedMessages = List<Message>.from(cachedState.chatMessages.messages);
        
        for (final newMessage in newMessages) {
          // Check if message already exists to avoid duplicates
          if (!updatedMessages.any((msg) => msg.id == newMessage.id)) {
            updatedMessages.add(newMessage);
          }
        }
        
        // Create updated state with merged messages
        final updatedState = ChatMessagesLoaded(
          ChatMessagesConversation(
            chatId: cachedState.chatMessages.chatId,
            messages: updatedMessages,
          )
        );
        
        // Update cache with merged data
        _cacheMessages(chatId, updatedState);
        
        print('[ChatMessagesCubit] Updated cache for chat $chatId with ${newMessages.length} new messages');
      }
    }
  }

  /// Start auto-refresh timer
  void startAutoRefresh(String chatId, {Duration interval = const Duration(seconds: 5)}) {
    stopAutoRefresh(); // Stop any existing timer
    
    print('[ChatMessagesCubit] Starting auto-refresh for chat $chatId every ${interval.inSeconds} seconds');
    
    _refreshTimer = Timer.periodic(interval, (timer) {
      if (state is! ChatMessagesLoading) {
        print('[ChatMessagesCubit] Auto-refresh triggered for chat $chatId');
        refreshChatMessages(chatId);
      } else {
        print('[ChatMessagesCubit] Skipping auto-refresh - already loading');
      }
    });
  }

  /// Stop auto-refresh timer
  void stopAutoRefresh() {
    if (_refreshTimer != null) {
      print('[ChatMessagesCubit] Stopping auto-refresh timer');
      _refreshTimer?.cancel();
      _refreshTimer = null;
    }
  }

  @override
  Future<void> close() {
    stopAutoRefresh();
    return super.close();
  }
}
