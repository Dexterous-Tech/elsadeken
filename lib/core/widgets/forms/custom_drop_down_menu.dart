import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownMenu extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;
  final String? initialValue;

  const CustomDropDownMenu({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    // Set selectedValue if initialValue is not null and not empty
    // and if it exists in the items list
    selectedValue = (widget.initialValue != null &&
            widget.initialValue!.isNotEmpty &&
            widget.items.contains(widget.initialValue))
        ? widget.initialValue
        : null;
  }

  @override
  void didUpdateWidget(CustomDropDownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue ||
        oldWidget.items != widget.items) {
      setState(() {
        // Set selectedValue if initialValue is not null and not empty
        // and if it exists in the items list
        selectedValue = (widget.initialValue != null &&
                widget.initialValue!.isNotEmpty &&
                widget.items.contains(widget.initialValue))
            ? widget.initialValue
            : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.font18JetMediumLamaSans,
          textAlign: TextAlign.right,
        ),
        verticalSpace(8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.brown),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              hint: Text(
                widget.hint,
                style: AppTextStyles.font16ChineseBlackMediumLamaSans,
                textAlign: TextAlign.right,
              ),
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      value,
                      style: AppTextStyles.font14BlackRegularLamaSans,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
                widget.onChanged(newValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}
