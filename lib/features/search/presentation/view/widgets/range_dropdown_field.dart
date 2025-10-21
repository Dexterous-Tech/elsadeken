// File: lib/presentation/widgets/range_dropdown_field.dart
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../../../../core/theme/app_color.dart';

class RangeDropdownField extends StatefulWidget {
  final String label;
  final String fromHint;
  final String toHint;
  final int minValue;
  final int maxValue;
  final Function(int?, int?) onRangeChanged;

  const RangeDropdownField({
    super.key,
    required this.label,
    required this.fromHint,
    required this.toHint,
    required this.minValue,
    required this.maxValue,
    required this.onRangeChanged,
  });

  @override
  State<RangeDropdownField> createState() => _RangeDropdownFieldState();
}

class _RangeDropdownFieldState extends State<RangeDropdownField> {
  int? fromValue;
  int? toValue;
  late List<String> dropdownItems;

  @override
  void initState() {
    super.initState();
    // Generate list of numbers from min to max
    dropdownItems = List.generate(
      widget.maxValue - widget.minValue + 1,
      (index) => (widget.minValue + index).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: LocalizationService.instance.textDirection,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            textDirection: LocalizationService.instance.textDirection,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                ),
              ),
              Spacer(),
              Expanded(
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.primaryOrange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(8),
                      value: toValue?.toString(),
                      hint: Text(
                        widget.toHint,
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      items: dropdownItems.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          toValue = int.tryParse(newValue ?? '');
                        });
                        widget.onRangeChanged(fromValue, toValue);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.to,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.primaryOrange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(8),
                      value: fromValue?.toString(),
                      hint: Text(
                        widget.fromHint,
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      items: dropdownItems.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          fromValue = int.tryParse(newValue ?? '');
                        });
                        widget.onRangeChanged(fromValue, toValue);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
