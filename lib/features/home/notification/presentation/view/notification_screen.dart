import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/home/notification/data/datasources/notification_api_service.dart';
import 'package:elsadeken/features/home/notification/presentation/view/widgets/empty_notification.dart';
import 'package:elsadeken/features/home/notification/presentation/view/widgets/notification_list.dart';
import 'package:flutter/material.dart';
import 'package:elsadeken/features/home/notification/data/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationApiService _notificationService;
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      final apiService = await ApiServices.init();
      _notificationService = NotificationApiServiceImpl(apiService);
      await _loadNotifications();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize notifications';
        _isLoading = false;
      });
      debugPrint('Notification initialization error: $e');
    }
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final notifications = await _notificationService.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load notifications';
        _isLoading = false;
      });
      debugPrint('Load notifications error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F0),
      appBar: _buildAppBar(),
      body: _buildNotificationBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF5F3F0),
      elevation: 0,
      title: const Text(
        'الإشعارات',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
        onPressed: _showOptionsMenu,
      ),
    );
  }

  Widget _buildNotificationBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: _notifications.isEmpty
          ? const EmptyNotificationsWidget()
          : NotificationListWidget(
              notifications: _notifications,
              onNotificationTap: _onNotificationTap,
            ),
    );

  }

  Future<void> _onNotificationTap(NotificationModel notification) async {
    if (!notification.isRead) {
      try {
        await _notificationService.markNotificationAsRead(int.parse(notification.id));
        
        // Update local state
        setState(() {
          final index = _notifications.indexWhere((n) => n.id == notification.id);
          if (index != -1) {
            _notifications[index] = notification.copyWith(isRead: true);
          }
        });
      } catch (e) {
        debugPrint('Failed to mark notification as read: $e');
      }
    }
    
    // Handle navigation based on notification type
    _handleNotificationNavigation(notification);
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.mark_email_read, color: Colors.black),
              title: const Text(
                'تحديد الكل كمقروء',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                _markAllAsRead();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.black),
              title: const Text(
                'حذف جميع الإشعارات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                _clearAllNotifications();
              },
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllNotificationsAsRead();
      
      // Update local state
      setState(() {
        _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديد جميع الإشعارات كمقروءة')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل تحديث حالة الإشعارات')),
      );
      debugPrint('Mark all as read error: $e');
    }
  }

  Future<void> _clearAllNotifications() async {
    try {
      await _notificationService.clearAllNotifications();
      
      // Update local state
      setState(() {
        _notifications.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف جميع الإشعارات')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل حذف الإشعارات')),
      );
      debugPrint('Clear all notifications error: $e');
    }
  }

  void _handleNotificationNavigation(NotificationModel notification) {
    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.message:
        // Navigate to messages screen
        print('Navigate to messages from: ${notification.senderId}');
        break;
      case NotificationType.like:
        // Navigate to profile or likes screen
        print('Navigate to likes from: ${notification.senderId}');
        break;
      case NotificationType.follow:
        // Navigate to profile screen
        print('Navigate to profile: ${notification.senderId}');
        break;
      case NotificationType.comment:
        // Navigate to post/comment screen
        print('Navigate to comment: ${notification.relatedPostId}');
        break;
    }
  }
}