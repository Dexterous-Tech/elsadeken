import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';

class ChatTabBar extends StatefulWidget {
  final Function(int) onTabChanged;
  final int selectedIndex;

  const ChatTabBar({
    super.key,
    required this.onTabChanged,
    required this.selectedIndex,
  });

  @override
  State<ChatTabBar> createState() => _ChatTabBarState();
}

class _ChatTabBarState extends State<ChatTabBar> {
  final List tabs = ['الكل', 'القائمة المفضلة'];

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.lighterOrange,
        borderRadius: BorderRadius.circular(10).r,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: List.generate(tabs.length, (index) {
          final bool isSelected = index == widget.selectedIndex;
          return GestureDetector(
            onTap: () {
              widget.onTabChanged(index);
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
                    color: const Color(0xff2D2D2D),
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
