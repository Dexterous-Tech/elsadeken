import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_color.dart';

class RangeTextField extends StatefulWidget {
  final String label;
  final String fromHint;
  final String toHint;
  final int maxLength;
  final Function(int?, int?) onRangeChanged;

  const RangeTextField({
    super.key,
    required this.label,
    required this.fromHint,
    required this.toHint,
    required this.onRangeChanged,
    this.maxLength = 3, // Default to 3 digits for height/weight
  });

  @override
  State<RangeTextField> createState() => _RangeTextFieldState();
}

class _RangeTextFieldState extends State<RangeTextField> {
  int? fromValue;
  int? toValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 32), // Space for alignment with other fields
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryOrange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(widget.maxLength),
                    ],
                    decoration: InputDecoration(
                      hintText: widget.toHint,
                      hintStyle: TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 12,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        toValue = int.tryParse(value);
                      });
                      widget.onRangeChanged(fromValue, toValue);
                    },
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text('إلى', style: TextStyle(fontSize: 12)),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryOrange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(widget.maxLength),
                    ],
                    decoration: InputDecoration(
                      hintText: widget.fromHint,
                      hintStyle: TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 12,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        fromValue = int.tryParse(value);
                      });
                      widget.onRangeChanged(fromValue, toValue);
                    },
                  ),
                ),
              ),
            ],
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
