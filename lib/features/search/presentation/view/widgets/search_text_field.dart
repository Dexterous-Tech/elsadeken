// File: lib/presentation/widgets/search_text_field.dart
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_constants.dart';
import '../../../../../core/theme/app_color.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;

  const SearchTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.searchFieldHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: AppColors.primaryOrange, width: 1),
      ),
      child: TextField(
        onChanged: onChanged,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.jet),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: Icon(Icons.search, color: AppColors.jet),
        ),
      ),
    );
  }
}
