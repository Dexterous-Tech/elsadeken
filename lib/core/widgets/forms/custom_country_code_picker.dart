import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_color.dart';

class CustomCountryCodePicker extends StatefulWidget {
  final ValueNotifier<String> code; // Controller-like notifier

  const CustomCountryCodePicker({super.key, required this.code});

  @override
  State<CustomCountryCodePicker> createState() =>
      _CustomCountryCodePickerState();
}

class _CustomCountryCodePickerState extends State<CustomCountryCodePicker> {
  @override
  void initState() {
    super.initState();
    // Set initial value to Egypt on first build
    widget.code.value = '+966';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: ShapeDecoration(
        color: AppColors.snow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16).r,
          side: BorderSide(color: AppColors.brown),
        ),
      ),
      child: CountryCodePicker(
        padding: EdgeInsets.zero,
        onChanged: (code) {
          widget.code.value = code.dialCode ?? '';
        },
        initialSelection: 'SA',
        favorite: ['+966', 'SA'],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
      ),
    );
  }
}
