import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'تأكيد',
    this.cancelText = 'إلغاء',
    this.confirmColor = Colors.red,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        title,
        style: AppTextStyles.font18ChineseBlackBoldLamaSans.copyWith(
          fontSize: 18.sp,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
          fontSize: 14.sp,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel?.call();
          },
          child: Text(
            cancelText,
            style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            confirmText,
            style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
              fontSize: 14.sp,
              color: confirmColor,
            ),
          ),
        ),
      ],
    );
  }
}
