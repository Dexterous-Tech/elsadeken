import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_drop_down_menu.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final UpdateProfileCubit? cubit;

  ManageProfileDialogData({
    required this.title,
    required this.fields,
    this.onSave,
    this.cubit,
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Initialize controllers and selected values
  for (var field in data.fields) {
    controllers[field.label] = TextEditingController(text: field.currentValue);
    selectedValues[field.label] = field.currentValue;
  }

  return customDialog(
    context: context,
    backgroundColor: AppColors.white,
    dialogContent: data.cubit != null
        ? BlocProvider.value(
            value: data.cubit!,
            child: BlocListener<UpdateProfileCubit, UpdateProfileState>(
              listener: (context, state) {
                if (state is UpdateProfileLoginDataLoading) {
                  Navigator.pop(context); // Close the dialog
                  loadingDialog(context);
                } else if (state is UpdateProfileLoginDataFailure) {
                  Navigator.pop(context); // Close loading dialog
                  errorDialog(
                    context: context,
                    error: state.error,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                } else if (state is UpdateProfileLoginDataSuccess) {
                  Navigator.pop(context); // Close loading dialog
                  successDialog(
                    context: context,
                    message: 'تم تحديث البيانات بنجاح',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context); // Return to manage profile screen
                    },
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: formKey,
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
                              styleTextButton:
                                  AppTextStyles.font14DesiredMediumLamaSans,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          horizontalSpace(1),
                          Expanded(
                            child: CustomElevatedButton(
                              height: 41.h,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  // Get password and confirm password values
                                  final password =
                                      controllers['كلمة المرور']?.text ?? '';
                                  final passwordConfirmation =
                                      controllers['تأكيد كلمة المرور']?.text ??
                                          '';

                                  // If password is entered, confirm password is required
                                  if (password.isNotEmpty &&
                                      passwordConfirmation.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('يرجى تأكيد كلمة المرور'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // If both password fields are filled, validate they match
                                  if (password.isNotEmpty &&
                                      passwordConfirmation.isNotEmpty) {
                                    if (password != passwordConfirmation) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'كلمة المرور وتأكيد كلمة المرور غير متطابقين'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                  }

                                  // Handle save logic here
                                  if (data.cubit != null) {
                                    final name =
                                        controllers['اسم المستخدم']?.text ?? '';
                                    final email =
                                        controllers['البريد الإلكتروني']
                                                ?.text ??
                                            '';
                                    final phone =
                                        controllers['رقم الهاتف']?.text ?? '';

                                    data.cubit!.updateProfileLoginData(
                                      name: name,
                                      email: email,
                                      phone: phone,
                                      password: password,
                                      passwordConfirmation:
                                          passwordConfirmation,
                                    );
                                  }
                                }
                              },
                              textButton: 'تعديل',
                              backgroundColor: AppColors.darkSunray,
                              styleTextButton: AppTextStyles
                                  .font14DesiredMediumLamaSans
                                  .copyWith(color: AppColors.jet),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'خطأ: لم يتم توفير UpdateProfileCubit',
                  style: AppTextStyles.font18JetMediumLamaSans,
                  textAlign: TextAlign.center,
                ),
                verticalSpace(20),
                CustomElevatedButton(
                  height: 41.h,
                  onPressed: () => Navigator.pop(context),
                  textButton: 'إغلاق',
                  backgroundColor: AppColors.red,
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
              // Password fields are optional, so no validation needed here
              // The validation logic is handled in the save button onPressed
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
