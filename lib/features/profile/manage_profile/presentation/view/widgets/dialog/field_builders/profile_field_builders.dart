import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_drop_down_menu.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/core/widgets/forms/custom_country_code_picker.dart';
import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Base class for all field builders
abstract class ProfileFieldBuilder {
  Widget build({
    required ManageProfileField field,
    required TextEditingController controller,
    required String? selectedValue,
    required Function(String?) onChanged,
    required BuildContext context,
    required SignUpListsCubit? signUpListsCubit,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
  });
}

/// Builder for text input fields
class TextFieldBuilder extends ProfileFieldBuilder {
  @override
  Widget build({
    required ManageProfileField field,
    required TextEditingController controller,
    required String? selectedValue,
    required Function(String?) onChanged,
    required BuildContext context,
    required SignUpListsCubit? signUpListsCubit,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
  }) {
    return Column(
      textDirection: LocalizationService.instance.textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: AppTextStyles.font18JetMediumLamaSans,
          textAlign: LocalizationService.instance.isArabic
              ? TextAlign.right
              : TextAlign.left,
        ),
        verticalSpace(2),
        CustomTextFormField(
          hintText: field.hint,
          controller: controller,
          keyboardType: field.keyboardType,
          maxLines: field.maxLines,
          validator: (value) {
            if (field.isRequired && (value == null || value.isEmpty)) {
              return AppLocalizations.of(context)!.fieldRequired;
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Builder for password input fields
class PasswordFieldBuilder extends ProfileFieldBuilder {
  @override
  Widget build({
    required ManageProfileField field,
    required TextEditingController controller,
    required String? selectedValue,
    required Function(String?) onChanged,
    required BuildContext context,
    required SignUpListsCubit? signUpListsCubit,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
  }) {
    return Column(
      textDirection: LocalizationService.instance.textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: AppTextStyles.font18JetMediumLamaSans,
          textAlign: LocalizationService.instance.isArabic
              ? TextAlign.right
              : TextAlign.left,
        ),
        verticalSpace(2),
        _PasswordFieldWithVisibility(
          hintText: field.hint,
          controller: controller,
          inputFormatters: _getInputFormattersForField(field.label, context),
          validator: (value) {
            // Password fields are optional, so no validation needed here
            // The validation logic is handled in the save button onPressed
            return null;
          },
        ),
      ],
    );
  }

  List<TextInputFormatter>? _getInputFormattersForField(
      String label, BuildContext context) {
    final phoneNumber = AppLocalizations.of(context)!.phoneNumber;
    final countryCode = AppLocalizations.of(context)!.countryCode;
    final age = AppLocalizations.of(context)!.age;
    final numberOfChildren = AppLocalizations.of(context)!.numberOfChildren;
    final weight = AppLocalizations.of(context)!.weight;
    final height = AppLocalizations.of(context)!.height;
    final monthlyIncome = AppLocalizations.of(context)!.monthlyIncome;

    if (label == phoneNumber ||
        label == countryCode ||
        label == age ||
        label == numberOfChildren ||
        label == weight ||
        label == height ||
        label == monthlyIncome) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }
}

/// Builder for dropdown fields
class DropdownFieldBuilder extends ProfileFieldBuilder {
  @override
  Widget build({
    required ManageProfileField field,
    required TextEditingController controller,
    required String? selectedValue,
    required Function(String?) onChanged,
    required BuildContext context,
    required SignUpListsCubit? signUpListsCubit,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
  }) {
    if (field.dataType != null) {
      return _buildDynamicDropdown(
        field: field,
        selectedValue: selectedValue,
        onChanged: onChanged,
        context: context,
        signUpListsCubit: signUpListsCubit,
        generalDataLists: generalDataLists,
        nationalitiesList: nationalitiesList,
        countriesList: countriesList,
        citiesList: citiesList,
      );
    } else if (field.keyValueOptions != null) {
      // Handle key-value options
      return CustomDropDownMenu(
        label: field.label,
        hint: field.hint,
        items: field.keyValueOptions!.values.toList(),
        onChanged: (selectedDisplayValue) {
          print(
              'DEBUG: Dropdown "${field.label}" - Selected display value: "$selectedDisplayValue"');
          print(
              'DEBUG: Dropdown "${field.label}" - Available key-value options: ${field.keyValueOptions}');

          // Find the key for the selected display value
          final selectedKey = field.keyValueOptions!.entries
              .firstWhere(
                (entry) => entry.value == selectedDisplayValue,
                orElse: () => const MapEntry('', ''),
              )
              .key;

          print('DEBUG: Dropdown "${field.label}" - Found key: "$selectedKey"');

          // Store the key (API value) in the controller
          controller.text = selectedKey;
          onChanged(selectedKey);

          print(
              'DEBUG: Dropdown "${field.label}" - Controller updated to: "${controller.text}"');
        },
        initialValue:
            _getDisplayValueForKey(selectedValue, field.keyValueOptions!),
      );
    } else {
      return CustomDropDownMenu(
        label: field.label,
        hint: field.hint,
        items: field.options ?? [],
        onChanged: onChanged,
        initialValue: selectedValue,
      );
    }
  }

  /// Helper method to get display value for a given key
  String? _getDisplayValueForKey(
      String? key, Map<String, String> keyValueOptions) {
    if (key == null || key.isEmpty) return null;
    return keyValueOptions[key];
  }

  Widget _buildDynamicDropdown({
    required ManageProfileField field,
    required String? selectedValue,
    required Function(String?) onChanged,
    required BuildContext context,
    required SignUpListsCubit? signUpListsCubit,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
  }) {
    // If SignUpListsCubit is not available, show empty dropdown
    if (signUpListsCubit == null) {
      return Column(
        textDirection: LocalizationService.instance.textDirection,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: AppTextStyles.font18JetMediumLamaSans,
            textAlign: LocalizationService.instance.isArabic
                ? TextAlign.right
                : TextAlign.left,
          ),
          verticalSpace(2),
          CustomDropDownMenu(
            label: '',
            hint: field.hint,
            items: [], // Empty items when cubit not available
            onChanged: onChanged,
            initialValue: null, // Always null when no items available
          ),
        ],
      );
    }

    return BlocBuilder<SignUpListsCubit, SignUpListsState>(
      builder: (context, state) {
        List<String> items = [];
        bool isLoading = false;

        switch (field.dataType!) {
          case ManageProfileFieldDataType.nationality:
            if (nationalitiesList.isNotEmpty) {
              items = nationalitiesList.map((item) => item.name ?? '').toList();
            } else if (state is NationalitiesLoading) {
              isLoading = true;
            }
            break;
          case ManageProfileFieldDataType.country:
            if (countriesList.isNotEmpty) {
              items = countriesList.map((item) => item.name ?? '').toList();
            } else if (state is CountriesLoading) {
              isLoading = true;
            }
            break;
          case ManageProfileFieldDataType.city:
            if (citiesList.isNotEmpty) {
              items = citiesList.map((item) => item.name ?? '').toList();

              // Auto-select first city if no city is currently selected and cities are loaded
              if (selectedValue == null || selectedValue.isEmpty) {
                final firstCity = items.isNotEmpty ? items.first : null;
                if (firstCity != null) {
                  // Use a post-frame callback to avoid setState during build
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Don't auto-select first city - let user choose manually
                    // onChanged(firstCity);
                  });
                }
              }
            } else if (state is CitiesLoading) {
              isLoading = true;
            }
            break;
          case ManageProfileFieldDataType.skinColor:
            final skinColors = generalDataLists['skinColors'];
            if (skinColors != null && skinColors.isNotEmpty) {
              items = skinColors.map((item) => item.name ?? '').toList();
            } else if (state is SkinColorsLoading) {
              isLoading = true;
            }
            break;
          case ManageProfileFieldDataType.physique:
            final physiques = generalDataLists['physiques'];
            if (physiques != null && physiques.isNotEmpty) {
              items = physiques.map((item) => item.name ?? '').toList();
            } else if (state is PhysiquesLoading) {
              isLoading = true;
            }
            break;
          case ManageProfileFieldDataType.qualification:
            final qualifications = generalDataLists['qualifications'];
            if (qualifications != null && qualifications.isNotEmpty) {
              items = qualifications.map((item) => item.name ?? '').toList();
            } else if (state is QualificationsLoading) {
              isLoading = true;
            }
            break;
          case ManageProfileFieldDataType.financialSituation:
            final financialSituations = generalDataLists['financialSituations'];
            if (financialSituations != null && financialSituations.isNotEmpty) {
              items =
                  financialSituations.map((item) => item.name ?? '').toList();
            } else if (state is FinancialSituationsLoading) {
              isLoading = true;
            }
            break;
          case ManageProfileFieldDataType.healthCondition:
            final healthConditions = generalDataLists['healthConditions'];
            if (healthConditions != null && healthConditions.isNotEmpty) {
              items = healthConditions.map((item) => item.name ?? '').toList();
            } else if (state is HealthConditionsLoading) {
              isLoading = true;
            }
            break;
          case ManageProfileFieldDataType.income:
            final incomes = generalDataLists['incomes'];
            if (incomes != null && incomes.isNotEmpty) {
              items = incomes.map((item) => item.name ?? '').toList();
            } else if (state is IncomesLoading) {
              isLoading = true;
            }
            break;
        }

        return Column(
          textDirection: LocalizationService.instance.textDirection,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: AppTextStyles.font18JetMediumLamaSans,
              textAlign: LocalizationService.instance.isArabic
                  ? TextAlign.right
                  : TextAlign.left,
            ),
            verticalSpace(2),
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
                    initialValue: selectedValue,
                  ),
          ],
        );
      },
    );
  }
}

/// Builder for phone with country code fields
class PhoneWithCountryCodeFieldBuilder extends ProfileFieldBuilder {
  @override
  Widget build({
    required ManageProfileField field,
    required TextEditingController controller,
    required String? selectedValue,
    required Function(String?) onChanged,
    required BuildContext context,
    required SignUpListsCubit? signUpListsCubit,
    required Map<String, List<GeneralInfoResponseModels>> generalDataLists,
    required List<NationalCountryResponseModel> nationalitiesList,
    required List<NationalCountryResponseModel> countriesList,
    required List<CityResponseModels> citiesList,
  }) {
    // Get the country code from the field's code ValueNotifier (from user profile data)
    String currentCountryCode = '+966'; // Default country code
    String currentPhone = selectedValue ?? ''; // Use the phone number directly

    // Create a ValueNotifier for the country code - use the one from field or create default
    final countryCodeNotifier =
        field.code ?? ValueNotifier<String>(currentCountryCode);

    // Get the initial country code from the ValueNotifier (which contains user's country code)
    currentCountryCode = countryCodeNotifier.value;

    // Initialize the controller with phone number only (country code is handled by the picker)
    if (controller.text.isEmpty) {
      controller.text = currentPhone;
    }

    return Column(
      textDirection: LocalizationService.instance.textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: AppTextStyles.font18JetMediumLamaSans,
          textAlign: LocalizationService.instance.isArabic
              ? TextAlign.right
              : TextAlign.left,
        ),
        verticalSpace(2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: LocalizationService.instance.textDirection,
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: field.hint,
                controller: controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (field.isRequired && (value == null || value.isEmpty)) {
                    return AppLocalizations.of(context)!.fieldRequired;
                  }
                  return null;
                },
              ),
            ),
            horizontalSpace(8),
            SizedBox(
              height: 50.h, // Match the height of CustomTextFormField
              child: CustomCountryCodePicker(
                code: countryCodeNotifier,
                initialCountryCode: currentCountryCode,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Factory class to get the appropriate field builder
class ProfileFieldBuilderFactory {
  static ProfileFieldBuilder getBuilder(ManageProfileFieldType type) {
    switch (type) {
      case ManageProfileFieldType.text:
        return TextFieldBuilder();
      case ManageProfileFieldType.password:
        return PasswordFieldBuilder();
      case ManageProfileFieldType.dropdown:
        return DropdownFieldBuilder();
      case ManageProfileFieldType.phoneWithCountryCode:
        return PhoneWithCountryCodeFieldBuilder();
    }
  }
}

/// Custom password field with visibility toggle
class _PasswordFieldWithVisibility extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final dynamic Function(String?) validator;

  const _PasswordFieldWithVisibility({
    required this.hintText,
    required this.controller,
    this.inputFormatters,
    required this.validator,
  });

  @override
  State<_PasswordFieldWithVisibility> createState() =>
      _PasswordFieldWithVisibilityState();
}

class _PasswordFieldWithVisibilityState
    extends State<_PasswordFieldWithVisibility> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: widget.hintText,
      controller: widget.controller,
      obscureText: _obscureText,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.lightGray,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
