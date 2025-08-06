import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/helper/app_svg.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';

class SignupMultiChoice extends StatefulWidget {
  const SignupMultiChoice({
    super.key,
    required this.title,
    this.selected,
    required this.options,
    this.onChanged,
  });

  final String title;
  final String? selected;
  final List<String> options;
  final ValueChanged<String>? onChanged;

  @override
  State<SignupMultiChoice> createState() => _SignupMultiChoiceState();
}

class _SignupMultiChoiceState extends State<SignupMultiChoice> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant SignupMultiChoice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      _selected = widget.selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Title
        Text(
          widget.title,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.font23ChineseBlackBoldLamaSans(context),
        ),
        verticalSpace(16),

        // Options
        Column(
          children: widget.options.map((option) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selected = option;
                });
                widget.onChanged?.call(option);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: _selected == option
                      ? AppColors.sunsetOrange.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option,
                      style: AppTextStyles.font18ChineseBlackBoldLamaSans(
                        context,
                      ),
                    ),
                    _selected == option
                        ? SvgPicture.asset(
                            AppSvg.checkCircle,
                            width: 16.w,
                            height: 16.h,
                          )
                        : SizedBox(width: 16.w, height: 16.h),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
