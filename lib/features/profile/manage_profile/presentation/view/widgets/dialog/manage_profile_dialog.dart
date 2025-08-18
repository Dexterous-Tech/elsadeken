import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_drop_down_menu.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ManageProfileDialogType {
  loginData,
  nationalCountry,
  personalInfo,
  socialStatus,
  bodyInfo,
  religion,
  education,
  job,
  descriptions,
}

class ManageProfileDialogData {
  final String title;
  final List<ManageProfileField> fields;
  final VoidCallback? onSave;

  ManageProfileDialogData({
    required this.title,
    required this.fields,
    this.onSave,
  });
}

class ManageProfileField {
  final String label;
  final String hint;
  final String currentValue;
  final ManageProfileFieldType type;
  final List<String>? options;
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;

  ManageProfileField({
    required this.label,
    required this.hint,
    required this.currentValue,
    required this.type,
    this.options,
    this.isRequired = true,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines,
  });
}

enum ManageProfileFieldType {
  text,
  dropdown,
  password,
}

Future<void> manageProfileDialog(
  BuildContext context,
  ManageProfileDialogData data,
) async {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, String?> selectedValues = {};

  // Initialize controllers and selected values
  for (var field in data.fields) {
    controllers[field.label] = TextEditingController(text: field.currentValue);
    selectedValues[field.label] = field.currentValue;
  }

  return customDialog(
    context: context,
    backgroundColor: AppColors.white,
    dialogContent: Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            data.title,
            style: AppTextStyles.font20LightOrangeMediumLamaSans,
            textAlign: TextAlign.center,
          ),
          verticalSpace(20),

          // Fields
          ...data.fields.map((field) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildField(
                field: field,
                controller: controllers[field.label]!,
                selectedValue: selectedValues[field.label],
                onChanged: (value) {
                  selectedValues[field.label] = value;
                },
              ),
            );
          }),

          verticalSpace(20),

          // Buttons
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  height: 41.h,
                  onPressed: () => Navigator.pop(context),
                  textButton: 'إغلاق',
                  styleTextButton: AppTextStyles.font14DesiredMediumLamaSans,
                  backgroundColor: Colors.transparent,
                ),
              ),
              horizontalSpace(1),
              Expanded(
                child: CustomElevatedButton(
                  height: 41.h,
                  onPressed: () {
                    // Handle save logic here
                    if (data.onSave != null) {
                      data.onSave!();
                    }
                    Navigator.pop(context);
                  },
                  textButton: 'تعديل',
                  backgroundColor: AppColors.darkSunray,
                  styleTextButton: AppTextStyles.font14DesiredMediumLamaSans
                      .copyWith(color: AppColors.jet),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildField({
  required ManageProfileField field,
  required TextEditingController controller,
  String? selectedValue,
  required Function(String?) onChanged,
}) {
  switch (field.type) {
    case ManageProfileFieldType.text:
      return Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: AppTextStyles.font18JetMediumLamaSans,
            textAlign: TextAlign.right,
          ),
          verticalSpace(8),
          CustomTextFormField(
            hintText: field.hint,
            controller: controller,
            keyboardType: field.keyboardType,
            maxLines: field.maxLines,
            validator: (value) {
              if (field.isRequired && (value == null || value.isEmpty)) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            },
          ),
        ],
      );

    case ManageProfileFieldType.password:
      return Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: AppTextStyles.font18JetMediumLamaSans,
            textAlign: TextAlign.right,
          ),
          verticalSpace(8),
          CustomTextFormField(
            hintText: field.hint,
            controller: controller,
            obscureText: true,
            validator: (value) {
              if (field.isRequired && (value == null || value.isEmpty)) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            },
          ),
        ],
      );

    case ManageProfileFieldType.dropdown:
      return CustomDropDownMenu(
        label: field.label,
        hint: field.hint,
        items: field.options ?? [],
        onChanged: onChanged,
      );
  }
}
