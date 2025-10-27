// File: lib/presentation/widgets/dropdown_field.dart
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_color.dart';

class DropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;
  final String? initialValue;

  const DropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: LocalizationService.instance.textDirection,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.primaryOrange),
              borderRadius: BorderRadius.circular(8).r,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                isExpanded: true,
                borderRadius: BorderRadius.circular(8).r,
                value: selectedValue,
                hint: Text(
                  widget.hint,
                  style: TextStyle(color: AppColors.primaryOrange),
                  textAlign: LocalizationService.instance.textAlignment,
                  textDirection: LocalizationService.instance.textDirection,
                ),
                items: widget.items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Align(
                      alignment: LocalizationService.instance.topAlignment,
                      child: Text(
                        value,
                        style: TextStyle(color: AppColors.black),
                        textAlign: LocalizationService.instance.textAlignment,
                        textDirection:
                            LocalizationService.instance.textDirection,
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
        ),
      ],
    );
  }
}
