import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

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
    this.height,
  });

  final String title;
  final String? selected;
  final List<String> options;
  final ValueChanged<String>? onChanged;
  final double? height;

  @override
  State<SignupMultiChoice> createState() => _SignupMultiChoiceState();
}

class _SignupMultiChoiceState extends State<SignupMultiChoice> {
  String? _selected;
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
    // Check if scrolling is needed after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfScrollNeeded();
    });
  }

  @override
  void didUpdateWidget(covariant SignupMultiChoice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      _selected = widget.selected;
    }
    // Recheck scrolling when options change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfScrollNeeded();
    });
  }

  void _checkIfScrollNeeded() {
    if (_scrollController.hasClients) {
      setState(() {
        _needsScroll = _scrollController.position.maxScrollExtent > 0;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
        ),
        verticalSpace(16),

        // Options with scrollbar
        Directionality(
          textDirection: TextDirection.ltr,
          child: VsScrollbar(
            controller: _scrollController,
            showTrackOnHover: true,
            isAlwaysShown: true,
            scrollbarFadeDuration: const Duration(milliseconds: 500),
            scrollbarTimeToFade: const Duration(milliseconds: 800),
            style: VsScrollbarStyle(
              hoverThickness: 5.0,
              radius: const Radius.circular(10),
              thickness: 8.0,
              color: AppColors.desire.withValues(alpha: 0.474),
            ),
            child: Padding(
              padding: EdgeInsets.only(right: _needsScroll ? 16.w : 0),
              child: SizedBox(
                height: widget.height ?? 220.h,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
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
                              Text(option,
                                  style: AppTextStyles
                                      .font18ChineseBlackBoldLamaSans),
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
