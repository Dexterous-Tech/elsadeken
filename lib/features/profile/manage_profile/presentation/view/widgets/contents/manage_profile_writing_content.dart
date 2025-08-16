import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_edit_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProfileWritingContent extends StatelessWidget {
  const ManageProfileWritingContent({super.key, required this.label});

  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        verticalSpace(9),
        Container(
          width: 301.w,
          // height: 155,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: AppColors.white,
          ),
          child: _itemContent('طموحه'),
        ),
        verticalSpace(20),
        ManageProfileEditButton(
          onPressed: () => _showWritingContentEditDialog(context, label),
        )
      ],
    );
  }

  Widget _itemContent(String title) {
    return Text(
      title,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: AppTextStyles.font18PhilippineBronzeRegularPlexSans,
    );
  }

  void _showWritingContentEditDialog(BuildContext context, String label) {
    final dialogData = ManageProfileDialogData(
      title: 'تعديل المحتوى المكتوب',
      fields: [
        ManageProfileField(
          label: label,
          hint: 'اكتب عن طموحك',
          currentValue: 'طموحه',
          type: ManageProfileFieldType.text,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
        ),
      ],
      onSave: () {
        // Handle save logic here
        print('Saving writing content...');
      },
    );

    manageProfileDialog(context, dialogData);
  }
}
