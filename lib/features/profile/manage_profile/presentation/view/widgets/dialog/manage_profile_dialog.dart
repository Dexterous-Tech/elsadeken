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

import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
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
  final SignUpListsCubit? signUpListsCubit;
  final ManageProfileDialogType? dialogType;

  ManageProfileDialogData({
    required this.title,
    required this.fields,
    this.onSave,
    this.cubit,
    this.signUpListsCubit,
    this.dialogType,
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
  final String?
      dependentFieldLabel; // For fields that depend on other fields (like city depends on country)
  final ManageProfileFieldDataType?
      dataType; // To identify what type of data to load

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
    this.dependentFieldLabel,
    this.dataType,
  });
}

enum ManageProfileFieldType {
  text,
  dropdown,
  password,
}

enum ManageProfileFieldDataType {
  nationality,
  country,
  city,
  skinColor,
  physique,
  qualification,
  financialSituation,
  healthCondition,
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
        ? MultiBlocProvider(
            providers: [
              BlocProvider.value(value: data.cubit!),
              if (data.signUpListsCubit != null)
                BlocProvider.value(value: data.signUpListsCubit!),
            ],
            child: _ManageProfileDialogContent(
              data: data,
              formKey: formKey,
              controllers: controllers,
              selectedValues: selectedValues,
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

class _ManageProfileDialogContent extends StatefulWidget {
  final ManageProfileDialogData data;
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> controllers;
  final Map<String, String?> selectedValues;

  const _ManageProfileDialogContent({
    required this.data,
    required this.formKey,
    required this.controllers,
    required this.selectedValues,
  });

  @override
  State<_ManageProfileDialogContent> createState() =>
      _ManageProfileDialogContentState();
}

class _ManageProfileDialogContentState
    extends State<_ManageProfileDialogContent> {
  @override
  void initState() {
    super.initState();
    _loadRequiredData();
  }

  void _loadRequiredData() {
    // Only load data if SignUpListsCubit is available
    if (widget.data.signUpListsCubit == null) return;

    final signUpListsCubit = context.read<SignUpListsCubit>();
    final fieldsRequiringData =
        widget.data.fields.where((field) => field.dataType != null);

    final Set<ManageProfileFieldDataType> dataTypesToLoad =
        fieldsRequiringData.map((field) => field.dataType!).toSet();

    for (final dataType in dataTypesToLoad) {
      switch (dataType) {
        case ManageProfileFieldDataType.nationality:
          signUpListsCubit.getNationalities();
          break;
        case ManageProfileFieldDataType.country:
          signUpListsCubit.getCountries();
          break;
        case ManageProfileFieldDataType.skinColor:
          signUpListsCubit.getSkinColors();
          break;
        case ManageProfileFieldDataType.physique:
          signUpListsCubit.getPhysiques();
          break;
        case ManageProfileFieldDataType.qualification:
          signUpListsCubit.getQualification();
          break;
        case ManageProfileFieldDataType.financialSituation:
          signUpListsCubit.getFinancialSituations();
          break;
        case ManageProfileFieldDataType.healthCondition:
          signUpListsCubit.getHealthConditions();
          break;
        case ManageProfileFieldDataType.city:
          // Cities will be loaded when country is selected
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, state) {
        _handleUpdateProfileState(context, state);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                widget.data.title,
                style: AppTextStyles.font20LightOrangeMediumLamaSans,
                textAlign: TextAlign.center,
              ),
              verticalSpace(20),

              // Fields
              ...widget.data.fields.map((field) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildField(
                    field: field,
                    controller: widget.controllers[field.label]!,
                    selectedValue: widget.selectedValues[field.label],
                    onChanged: (value) {
                      widget.selectedValues[field.label] = value;
                      _handleFieldChange(field, value);
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
                      onPressed: () => _handleSave(context),
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
      ),
    );
  }

  void _handleFieldChange(ManageProfileField field, String? value) {
    // Handle dependent fields (like loading cities when country is selected)
    if (field.dataType == ManageProfileFieldDataType.country &&
        value != null &&
        widget.data.signUpListsCubit != null) {
      final signUpListsCubit = context.read<SignUpListsCubit>();
      // Extract country ID from the value and load cities
      // Note: This assumes the value format includes the ID, you might need to adjust based on actual implementation
      final countryId = _extractIdFromValue(value);
      if (countryId != null) {
        signUpListsCubit.getCites(countryId.toString());
      }
    }
  }

  int? _extractIdFromValue(String value) {
    // This function should extract the ID from the display value
    // Implementation depends on how the dropdown values are formatted
    // For now, return null as placeholder
    return null;
  }

  void _handleUpdateProfileState(
      BuildContext context, UpdateProfileState state) {
    if (state is UpdateProfileLoginDataLoading ||
        state is UpdateProfileLocationDataLoading ||
        state is UpdateProfileMarriageDataLoading ||
        state is UpdateProfilePhysicalDataLoading ||
        state is UpdateProfileWorkDataLoading ||
        state is UpdateProfileAboutMeDataLoading ||
        state is UpdateProfileAboutPartnerDataLoading) {
      // Show loading dialog and keep the edit dialog open in background
      loadingDialog(context);
    } else if (state is UpdateProfileLoginDataFailure ||
        state is UpdateProfileLocationDataFailure ||
        state is UpdateProfileMarriageDataFailure ||
        state is UpdateProfilePhysicalDataFailure ||
        state is UpdateProfileWorkDataFailure ||
        state is UpdateProfileAboutMeDataFailure ||
        state is UpdateProfileAboutPartnerDataFailure) {
      // Close loading dialog first
      Navigator.pop(context);

      // Get error message
      String errorMessage = '';
      if (state is UpdateProfileLoginDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileLocationDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileMarriageDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfilePhysicalDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileWorkDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileAboutMeDataFailure)
        errorMessage = state.error;
      else if (state is UpdateProfileAboutPartnerDataFailure)
        errorMessage = state.error;

      // Show error dialog
      errorDialog(
        context: context,
        error: errorMessage,
        onPressed: () {
          Navigator.pop(context); // Close error dialog
          // Edit dialog remains open for user to try again
        },
      );
    } else if (state is UpdateProfileLoginDataSuccess ||
        state is UpdateProfileLocationDataSuccess ||
        state is UpdateProfileMarriageDataSuccess ||
        state is UpdateProfilePhysicalDataSuccess ||
        state is UpdateProfileWorkDataSuccess ||
        state is UpdateProfileAboutMeDataSuccess ||
        state is UpdateProfileAboutPartnerDataSuccess) {
      // Close loading dialog first
      Navigator.pop(context);

      // Show success dialog
      successDialog(
        context: context,
        message: 'تم تحديث البيانات بنجاح',
        onPressed: () {
          Navigator.pop(context); // Close success dialog
          Navigator.pop(context); // Close edit dialog
          // User returns to manage profile screen with updated data
        },
      );
    }
  }

  void _handleSave(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      // Get password and confirm password values for login data
      final password = widget.controllers['كلمة المرور']?.text ?? '';
      final passwordConfirmation =
          widget.controllers['تأكيد كلمة المرور']?.text ?? '';

      // If password is entered, confirm password is required
      if (password.isNotEmpty && passwordConfirmation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى تأكيد كلمة المرور'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // If both password fields are filled, validate they match
      if (password.isNotEmpty && passwordConfirmation.isNotEmpty) {
        if (password != passwordConfirmation) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('كلمة المرور وتأكيد كلمة المرور غير متطابقين'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // Handle save logic based on dialog type
      if (widget.data.cubit != null) {
        _callAppropriateUpdateMethod(password, passwordConfirmation);
      }
    }
  }

  void _callAppropriateUpdateMethod(
      String password, String passwordConfirmation) {
    switch (widget.data.dialogType) {
      case ManageProfileDialogType.loginData:
        final name = widget.controllers['اسم المستخدم']?.text ?? '';
        final email = widget.controllers['البريد الإلكتروني']?.text ?? '';
        final phone = widget.controllers['رقم الهاتف']?.text ?? '';

        widget.data.cubit!.updateProfileLoginData(
          name: name.isNotEmpty ? name : null,
          email: email.isNotEmpty ? email : null,
          phone: phone.isNotEmpty ? phone : null,
          password: password.isNotEmpty ? password : null,
          passwordConfirmation:
              passwordConfirmation.isNotEmpty ? passwordConfirmation : null,
        );
        break;

      case ManageProfileDialogType.nationalCountry:
        // For location data, we need to extract IDs from the selected values
        // This is a simplified version - you might need to implement proper ID extraction
        // final nationalityName = widget.controllers['الجنسية']?.text ?? '';
        // final countryName = widget.controllers['الدولة']?.text ?? '';
        // final cityName = widget.controllers['المدينة']?.text ?? '';

        // Note: You'll need to implement proper ID mapping from names to IDs
        // For now, using placeholder values
        widget.data.cubit!.updateProfileLocationData(
          nationalityId:
              1, // Replace with actual ID mapping from nationalityName
          countryId: 1, // Replace with actual ID mapping from countryName
          cityId: 1, // Replace with actual ID mapping from cityName
        );
        break;

      case ManageProfileDialogType.job:
        final qualificationName =
            widget.controllers['المؤهل التعليمي']?.text ?? '';
        final financialSituationName =
            widget.controllers['الوضع المادي']?.text ?? '';
        // final workField = widget.controllers['مجال العمل']?.text ?? ''; // Not used in API
        final jobTitle = widget.controllers['الوظيفة']?.text ?? '';
        final monthlyIncomeStr = widget.controllers['الدخل الشهري']?.text ?? '';
        final healthConditionName =
            widget.controllers['الحالة الصحية']?.text ?? '';

        // Convert income string to number (you might need to implement proper parsing)
        int income = 0;
        try {
          income = int.parse(monthlyIncomeStr);
        } catch (e) {
          // Handle income parsing error
        }

        widget.data.cubit!.updateProfileWorkData(
          qualificationId:
              qualificationName, // Note: API expects string, not int
          income: income,
          job: jobTitle,
          healthConditionId: healthConditionName,
          financialSituationId: financialSituationName,
        );
        break;

      case ManageProfileDialogType.personalInfo:
      case ManageProfileDialogType.socialStatus:
      case ManageProfileDialogType.bodyInfo:
      case ManageProfileDialogType.religion:
      case ManageProfileDialogType.education:
      case ManageProfileDialogType.descriptions:
      case null:
        // For now, fall back to login data if no type is specified
        final name = widget.controllers['اسم المستخدم']?.text ?? '';
        final email = widget.controllers['البريد الإلكتروني']?.text ?? '';
        final phone = widget.controllers['رقم الهاتف']?.text ?? '';

        widget.data.cubit!.updateProfileLoginData(
          name: name,
          email: email,
          phone: phone,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );
        break;
    }
  }
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
      if (field.dataType != null) {
        return _buildDynamicDropdown(field, selectedValue, onChanged);
      } else {
        return CustomDropDownMenu(
          label: field.label,
          hint: field.hint,
          items: field.options ?? [],
          onChanged: onChanged,
        );
      }
  }
}

Widget _buildDynamicDropdown(
  ManageProfileField field,
  String? selectedValue,
  Function(String?) onChanged,
) {
  return Builder(
    builder: (context) {
      // Check if SignUpListsCubit is available
      try {
        return BlocBuilder<SignUpListsCubit, SignUpListsState>(
          builder: (context, state) {
            List<String> items = [];
            bool isLoading = false;

            switch (field.dataType!) {
              case ManageProfileFieldDataType.nationality:
                if (state is NationalitiesSuccess) {
                  items = state.nationalitiesList
                      .map((item) => item.name ?? '')
                      .toList();
                } else if (state is NationalitiesLoading) {
                  isLoading = true;
                }
                break;
              case ManageProfileFieldDataType.country:
                if (state is CountriesSuccess) {
                  items = state.countriesList
                      .map((item) => item.name ?? '')
                      .toList();
                } else if (state is CountriesLoading) {
                  isLoading = true;
                }
                break;
              case ManageProfileFieldDataType.city:
                if (state is CitiesSuccess) {
                  items =
                      state.citiesList.map((item) => item.name ?? '').toList();
                } else if (state is CitiesLoading) {
                  isLoading = true;
                }
                break;
              case ManageProfileFieldDataType.skinColor:
                if (state is SkinColorsSuccess) {
                  items =
                      state.generalList.map((item) => item.name ?? '').toList();
                } else if (state is SkinColorsLoading) {
                  isLoading = true;
                }
                break;
              case ManageProfileFieldDataType.physique:
                if (state is PhysiquesSuccess) {
                  items =
                      state.generalList.map((item) => item.name ?? '').toList();
                } else if (state is PhysiquesLoading) {
                  isLoading = true;
                }
                break;
              case ManageProfileFieldDataType.qualification:
                if (state is QualificationsSuccess) {
                  items =
                      state.generalList.map((item) => item.name ?? '').toList();
                } else if (state is QualificationsLoading) {
                  isLoading = true;
                }
                break;
              case ManageProfileFieldDataType.financialSituation:
                if (state is FinancialSituationsSuccess) {
                  items =
                      state.generalList.map((item) => item.name ?? '').toList();
                } else if (state is FinancialSituationsLoading) {
                  isLoading = true;
                }
                break;
              case ManageProfileFieldDataType.healthCondition:
                if (state is HealthConditionsSuccess) {
                  items =
                      state.generalList.map((item) => item.name ?? '').toList();
                } else if (state is HealthConditionsLoading) {
                  isLoading = true;
                }
                break;
            }

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
                isLoading
                    ? Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightGray),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.darkSunray,
                          ),
                        ),
                      )
                    : CustomDropDownMenu(
                        label: '',
                        hint: field.hint,
                        items: items,
                        onChanged: onChanged,
                      ),
              ],
            );
          },
        );
      } catch (e) {
        // If SignUpListsCubit is not available, fall back to static dropdown
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
            CustomDropDownMenu(
              label: '',
              hint: field.hint,
              items: [], // Empty list when no data available
              onChanged: onChanged,
            ),
          ],
        );
      }
    },
  );
}
