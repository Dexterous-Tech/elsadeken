import 'package:cached_network_image/cached_network_image.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';

class SwipeableCard extends StatefulWidget {
  final UserModel user;
  final Function(bool)? onSwipe;
  final bool isTop;
  final double scale;
  final double verticalOffset;

  const SwipeableCard({
    required this.user,
    this.onSwipe,
    this.isTop = false,
    this.scale = 1.0,
    this.verticalOffset = 1.0,
    super.key,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  bool _isProcessingAction = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_animationController);
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.isTop || _isProcessingAction) return;
    _isDragging = true;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isTop || !_isDragging || _isProcessingAction) return;
    setState(() {
      _dragOffset += Offset(details.delta.dx, 0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isTop || !_isDragging || _isProcessingAction) return;
    _isDragging = false;

    final threshold = MediaQuery.of(context).size.width * 0.3;

    if (_dragOffset.dx.abs() > threshold) {
      final isLike = _dragOffset.dx > 0;
      _animateSwipe(isLike);
    } else {
      _animateReturn();
    }
  }

  void _animateSwipe(bool isLike) {
    if (_isProcessingAction) return;

    setState(() {
      _isProcessingAction = true;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(isLike ? screenWidth : -screenWidth, 0),
    ).animate(_animationController);

    _rotationAnimation = Tween<double>(
      begin: _dragOffset.dx * 0.001,
      end: isLike ? 0.3 : -0.3,
    ).animate(_animationController);

    _animationController.forward().then((_) {
      widget.onSwipe?.call(isLike);
      _animationController.reset();
      setState(() {
        _dragOffset = Offset.zero;
        _isProcessingAction = false;
      });
    });
  }

  void _animateReturn() {
    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(_animationController);

    _rotationAnimation = Tween<double>(
      begin: _dragOffset.dx * 0.001,
      end: 0,
    ).animate(_animationController);

    _animationController.forward().then((_) {
      _animationController.reset();
      setState(() {
        _dragOffset = Offset.zero;
      });
    });
  }

  void _handleButtonPress(bool isLike) {
    if (!widget.isTop || _isProcessingAction) return;
    _animateSwipe(isLike);
  }

  @override
  Widget build(BuildContext context) {
    final cardOffset = widget.isTop
        ? (_isDragging ? _dragOffset : _slideAnimation.value)
        : Offset.zero;
    final rotation = widget.isTop
        ? (_isDragging ? _dragOffset.dx * 0.001 : _rotationAnimation.value)
        : 0.0;

    return Positioned(
      top: 10.h,
      left: 0.w,
      right: 0.w,
      child: Center(
        child: AnimatedSlide(
          duration: Duration(milliseconds: 300),
          offset: Offset(0, widget.verticalOffset / 350),
          child: AnimatedScale(
            duration: Duration(milliseconds: 300),
            scale: widget.scale,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onTap: () {
                if (!_isProcessingAction) {
                  print("Card tapped for user:");
                  print("  User ID: ${widget.user.id}");
                  print("  User Name: ${widget.user.name}");
                  print("  User Image URL: ${widget.user.imageUrl}");

                  Navigator.pushNamed(
                    context,
                    AppRoutes.personDetailsScreen,
                    arguments: {
                      'personId': widget.user.id,
                      'imageUrl': widget.user.imageUrl,
                    },
                  );
                }
              },
              child: Transform.translate(
                offset: cardOffset,
                child: Transform.rotate(
                  angle: rotation,
                  child: Container(
                    width: MediaQuery.of(context).size.width -
                        32.w, // 16w margin on each side
                    constraints: BoxConstraints(
                      maxWidth: 388.w,
                    ),
                    padding:
                        EdgeInsets.only(top: 14.h, left: 14.w, right: 14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16).r,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 420.h,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8).r,
                                  child: widget.user.imageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: widget.user.imageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xffFFB74D),
                                                ),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    size: 60,
                                                    color: Colors.grey[400],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'لا يمكن تحميل الصورة',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 14.h,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffDBAE48),
                                      borderRadius: BorderRadius.circular(8).r,
                                    ),
                                    child: Text(
                                      'تطابق بنسبة ${widget.user.matchPercentage}%',
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeightHelper.semiBold,
                                        fontFamily:
                                            FontFamilyHelper.lamaSansArabic,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 14.h,
                                left: 14.w,
                                right: 14.w,
                                child: Column(
                                  children: [
                                    SizedBox(height: 250.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 26.5.w,
                                              vertical: 11.h,
                                            ),
                                            constraints: BoxConstraints(
                                              maxWidth: 250.w,
                                              minWidth: 80.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xffDBAE48),
                                              borderRadius:
                                                  BorderRadius.circular(15).r,
                                            ),
                                            child: Center(
                                              child: Text(
                                                maxLines: 1,
                                                widget.user.location,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeightHelper.medium,
                                                  fontFamily: FontFamilyHelper
                                                      .lamaSansArabic,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Text(
                                              '${widget.user.name}، ${widget.user.age} سنة',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      FontWeightHelper.bold,
                                                  fontFamily: FontFamilyHelper
                                                      .lamaSansArabic),
                                            ),
                                            Text(
                                              widget.user.profession,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight:
                                                      FontWeightHelper.regular,
                                                  fontFamily: FontFamilyHelper
                                                      .lamaSansArabic),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => _handleButtonPress(false),
                              child: Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xffE81925),
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _handleButtonPress(true),
                              child: Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Color(0xffEC4D58),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                try {
                                  // Check if there's an existing chat room first
                                  final chatListCubit = context.read<ChatListCubit>();
                                  print('🔍 Looking for existing chat room for user ID: ${widget.user.id}');
                                  
                                  final existingChatRoom = chatListCubit.findExistingChatRoom(widget.user.id);
                                  
                                  if (existingChatRoom != null) {
                                    print('✅ Found existing chat room: ${existingChatRoom.id}');
                                    // Navigate to existing chat room
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.chatConversationScreen,
                                      arguments: {
                                        "chatRoom": existingChatRoom,
                                      },
                                    );
                                  } else {
                                    print('🆕 No existing chat room found, creating new temporary chat');
                                    // Create new temporary chat room
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.chatConversationScreen,
                                      arguments: {
                                        "chatRoom": ChatRoomModel.fromUser(
                                          userId: widget.user.id,
                                          userName: widget.user.name,
                                          userImage: widget.user.imageUrl,
                                        ),
                                      },
                                    );
                                  }
                                } catch (e) {
                                  print('⚠️ Error in message button onTap: $e');
                                  // Fallback to creating new temporary chat room
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.chatConversationScreen,
                                    arguments: {
                                      "chatRoom": ChatRoomModel.fromUser(
                                        userId: widget.user.id,
                                        userName: widget.user.name,
                                        userImage: widget.user.imageUrl,
                                      ),
                                    },
                                  );
                                }
                              },
                              child: Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                    child: Image.asset(
                                  'assets/images/home/home_outline_message.png',
                                  width: 18.w,
                                  height: 18.h,
                                )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
