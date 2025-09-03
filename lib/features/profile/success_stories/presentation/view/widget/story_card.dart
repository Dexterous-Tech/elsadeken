import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryCard extends StatefulWidget {
  const StoryCard({
    super.key,
    required this.title,
    required this.content,
    required this.image,
  });

  final String title;
  final String content;
  final String image;

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  void _showFullContentModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12).r),
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'قصة النجاح',
                      style: TextStyle(
                        fontFamily: FontFamilyHelper.plexSansArabic,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: FontFamilyHelper.plexSansArabic,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFBC85),
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      widget.content,
                      style: TextStyle(
                        fontFamily: FontFamilyHelper.plexSansArabic,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 51.w, vertical: 12.h),
      child: Container(
        alignment: Alignment.center,
        height: 200.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.successCard),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.userBlog,
                width: 50.w, // size
                height: 50.h,
              ),
              SizedBox(width: 8.w),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamilyHelper.plexSansArabic,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              RichText(
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: widget.content.length > 100
                            ? _showFullContentModal
                            : null,
                        child: Text(
                          widget.content.length > 100
                              ? '${widget.content.substring(0, 100)}... '
                              : widget.content,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.orange,
                            fontFamily: FontFamilyHelper.plexSansArabic,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
