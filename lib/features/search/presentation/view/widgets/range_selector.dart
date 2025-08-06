// File: lib/presentation/widgets/range_selector.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color.dart';

class RangeSelector extends StatelessWidget {
  final String label;
  final String fromHint;
  final String toHint;
  final String unit;
  final Function(int, int) onRangeChanged;

  const RangeSelector({
    super.key,
    required this.label,
    required this.fromHint,
    required this.toHint,
    required this.unit,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.keyboard_arrow_down, color: AppColors.primaryOrange),
        SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
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
                      hint: Text(
                        '$toHint $unit',
                        style: TextStyle(
                            color: AppColors.primaryOrange, fontSize: 12),
                      ),
                      items: [],
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text('إلى', style: TextStyle(fontSize: 12)),
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
                      hint: Text(
                        '$fromHint $unit',
                        style: TextStyle(
                            color: AppColors.primaryOrange, fontSize: 12),
                      ),
                      items: [],
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
