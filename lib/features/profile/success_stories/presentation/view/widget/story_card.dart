import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryCard extends StatelessWidget {
  StoryCard(
      {super.key,
      required this.name,
      required this.age,
      required this.message});

  String name;
  int age;
  String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
      child: Container(
        alignment: Alignment.center,
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.success1Blog),
              fit: BoxFit.cover,
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
                "$name , $age  سنة ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamilyHelper.plexSansArabic,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.orange,
                  fontFamily: FontFamilyHelper.plexSansArabic,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
