import 'package:cached_network_image/cached_network_image.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/features/home/person_details/view/person_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_model.dart';

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

  Future<void> debugImage(String url) async {
  final response = await http.get(Uri.parse(url));
  print("Status: ${response.statusCode}");
  print("Content-Type: ${response.headers['content-type']}");
  print("Length: ${response.bodyBytes.length}");
}

  @override
  void initState() {
    super.initState();
      debugImage(widget.user.imageUrl);
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
    if (!widget.isTop) return;
    _isDragging = true;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isTop || !_isDragging) return;
    setState(() {
      _dragOffset += Offset(details.delta.dx, 0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isTop || !_isDragging) return;
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
    if (!widget.isTop) return;
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
      top: 10,
      left: 0,
      right: 0,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetailsView(
                      personId: widget.user.name,
                      imageUrl: widget.user.imageUrl,
                    ),
                  ),
                );
              },
              child: Transform.translate(
                offset: cardOffset,
                child: Transform.rotate(
                  angle: rotation,
                  child: Container(
                    width: 388.w,
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
                            child: Image.network(
  widget.user.imageUrl,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    print("Image.network error: $error");
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.error, color: Colors.red),
    );
  },
)



                        ),
                              Positioned(
                                top: 20,
                                left: 5,
                                right: 5,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 137.w,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.5.w,
                                          vertical: 11.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xffDBAE48),
                                          borderRadius:
                                              BorderRadius.circular(8).r,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'تطابق بنسبة${widget.user.matchPercentage}%',
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight:
                                                    FontWeightHelper.semiBold,
                                                fontFamily: FontFamilyHelper
                                                    .lamaSansArabic),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 250.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                        width: 250,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 26.5.w,
                                          vertical: 11.h,
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth: 250, 
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xffDBAE48),
                                          borderRadius: BorderRadius.circular(15).r,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.user.location,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeightHelper.medium,
                                              fontFamily: FontFamilyHelper.lamaSansArabic,
                                            ),
                                            softWrap: true, 
                                            overflow: TextOverflow.visible, 
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
                              onTap: () {},
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