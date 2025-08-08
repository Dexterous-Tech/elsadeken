import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MembersProfileTabBar extends StatefulWidget {
  const MembersProfileTabBar({super.key});

  @override
  State<MembersProfileTabBar> createState() => _MembersProfileTabBarState();
}

class _MembersProfileTabBarState extends State<MembersProfileTabBar> {
  final List tabs = ['صور عامة', 'صور حصرية'];
  int selectedIndex = 0; // initially first tab is selected

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.lighterOrange,
        borderRadius: BorderRadius.circular(10).r,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: List.generate(tabs.length, (index) {
          final bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected
                    ? AppColors.desire.withValues(alpha: 0.474)
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
                    fontWeight: FontWeightHelper.medium,
                    color: Color(0xff2D2D2D),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
