// File: lib/presentation/widgets/dropdown_field.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color.dart';

class DropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;

  const DropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.keyboard_arrow_down, color: AppColors.primaryOrange),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryOrange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedValue,
                hint: Text(
                  widget.hint,
                  style: TextStyle(color: AppColors.primaryOrange),
                  textAlign: TextAlign.right,
                ),
                items: widget.items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        value,
                        style: TextStyle(color: AppColors.black),
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
        SizedBox(width: 8),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
