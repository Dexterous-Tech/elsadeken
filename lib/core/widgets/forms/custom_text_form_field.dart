import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_color.dart';
import '../../theme/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.hintStyle,
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding,
    this.fillBackgroundColor,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.obscureText,
    this.controller,
    required this.validator,
    this.keyboardType,
    this.labelStyle,
    this.labelText,
    this.onTap,
    this.radius,
    this.maxLines,
    this.onChanged,
    this.borderColor,
    this.inputFormatters,
  });

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillBackgroundColor;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final bool? obscureText;
  final TextEditingController? controller;
  final Function(String?) validator;
  final TextInputType? keyboardType;
  final TextStyle? labelStyle;
  final String? labelText;
  final void Function()? onTap;
  final double? radius;
  final int? maxLines;
  final void Function(String)? onChanged;
  final Color? borderColor;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        obscureText: obscureText ?? false,
        controller: controller,
        validator: (value) {
          return validator(value);
        },
        onTap: onTap,
        onChanged: onChanged,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl,
          hintText: hintText,
          hintStyle: hintStyle ??
              AppTextStyles.font16ChineseBlackMediumLamaSans(context),
          labelText: labelText,
          labelStyle: labelStyle ??
              AppTextStyles.font16ChineseBlackMediumLamaSans(context),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          isDense: true,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          filled: true,
          fillColor: fillBackgroundColor ?? AppColors.snow,
          errorMaxLines: 3,
          // RTL error text styling
          errorStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.red,
          ),
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(16).r,
                borderSide: BorderSide(color: borderColor ?? AppColors.brown),
              ),
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 16).r,
                borderSide: BorderSide(color: borderColor ?? AppColors.brown),
              ),
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 16).r,
                borderSide: BorderSide(color: borderColor ?? AppColors.brown),
              ),
          errorBorder: errorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 16).r,
                borderSide: const BorderSide(color: Colors.red),
              ),
          focusedErrorBorder: focusedErrorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 16).r,
                borderSide: BorderSide(color: borderColor ?? AppColors.brown),
              ),
        ),
      ),
    );
  }
}
