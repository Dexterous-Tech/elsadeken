import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/app_constants.dart';
import '../../../../../core/theme/app_color.dart';

class ExpandableSection extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        textDirection: LocalizationService.instance.textDirection,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: EdgeInsetsDirectional.all(AppConstants.defaultPadding),
              child: Row(
                textDirection: LocalizationService.instance.textDirection,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: AppColors.black,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: AppColors.primaryOrange,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppConstants.defaultPadding,
                0,
                AppConstants.defaultPadding,
                AppConstants.defaultPadding,
              ),
              child: Column(children: widget.children),
            ),
        ],
      ),
    );
  }
}
