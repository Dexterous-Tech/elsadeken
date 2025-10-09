import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = '',
    this.cancelText = '',
    this.confirmColor = Colors.red,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final effectiveConfirmText =
        confirmText.isEmpty ? localizations.confirmDefault : confirmText;
    final effectiveCancelText =
        cancelText.isEmpty ? localizations.cancelDefault : cancelText;
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
            effectiveCancelText,
            style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            effectiveConfirmText,
            style: AppTextStyles.font14BlackSemiBoldLamaSans.copyWith(
              fontSize: 14.sp,
              color: confirmColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
