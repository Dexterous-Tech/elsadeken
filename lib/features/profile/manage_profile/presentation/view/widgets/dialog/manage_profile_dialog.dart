import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/custom_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';

import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/update_profile_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Import refactored components
import 'field_builders/profile_field_builders.dart';
import 'validation/profile_validation_handlers.dart';
import 'update_handlers/profile_update_handlers.dart';
import 'utils/profile_data_loader.dart';
import 'utils/profile_data_mappers.dart';
import 'utils/profile_state_handler.dart';
import 'utils/profile_snackbar_handler.dart';

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
  final Map<String, String>? keyValueOptions; // For key-value mapping
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final String?
      dependentFieldLabel; // For fields that depend on other fields (like city depends on country)
  final ManageProfileFieldDataType? dataType;
  final ValueNotifier<String>? code; // To identify what type of data to load

  ManageProfileField(
      {required this.label,
      required this.hint,
      required this.currentValue,
      required this.type,
      this.options,
      this.keyValueOptions,
      this.isRequired = true,
      this.keyboardType,
      this.obscureText = false,
      this.maxLines,
      this.dependentFieldLabel,
      this.dataType,
      this.code});
}

enum ManageProfileFieldType {
  text,
  dropdown,
  password,
  phoneWithCountryCode,
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
  income,
  job,
}

Future<void> manageProfileDialog(
  BuildContext context,
  ManageProfileDialogData data,
) async {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, String?> selectedValues = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Initialize controllers and selected values
  print(
      'DEBUG: Dialog Initialization - Processing ${data.fields.length} fields');
  for (var field in data.fields) {
    // For key-value fields, store the key (API value) in the controller
    // For regular fields, store the display value
    String controllerValue = field.currentValue;
    print(
        'DEBUG: Field "${field.label}" - Initial current value: "${field.currentValue}"');
    print(
        'DEBUG: Field "${field.label}" - Has keyValueOptions: ${field.keyValueOptions != null}');

    if (field.keyValueOptions != null) {
      print(
          'DEBUG: Field "${field.label}" - Available options: ${field.keyValueOptions}');

      // Find the key for the current display value
      // Trim both values to handle potential whitespace issues
      final trimmedCurrentValue = field.currentValue.trim();
      final key = field.keyValueOptions!.entries.firstWhere(
        (entry) {
          final matches = entry.value.trim() == trimmedCurrentValue;
          if (matches) {
            print(
                'DEBUG: Field "${field.label}" - Found matching entry: "${entry.key}" => "${entry.value}"');
          }
          return matches;
        },
        orElse: () {
          print(
              'DEBUG: Field "${field.label}" - No matching key found for value "${field.currentValue}"');
          // Try to find by key instead (in case the current value is already a key)
          final keyEntry = field.keyValueOptions!.entries
              .where((entry) => entry.key.trim() == trimmedCurrentValue)
              .firstOrNull;
          if (keyEntry != null) {
            print(
                'DEBUG: Field "${field.label}" - Found by key match: "${keyEntry.key}" => "${keyEntry.value}"');
            return keyEntry;
          }
          return const MapEntry('', '');
        },
      ).key;

      print('DEBUG: Field "${field.label}" - Selected key: "$key"');
      controllerValue = key;
    }

    controllers[field.label] = TextEditingController(text: controllerValue);
    selectedValues[field.label] = controllerValue;

    print(
        'DEBUG: Field "${field.label}" - Final controller value: "$controllerValue"');
    print('DEBUG: Field "${field.label}" - Created controller successfully');
  }

  print(
      'DEBUG: Dialog Initialization - All controllers created. Total: ${controllers.length}');

  return customDialog(
    context: context,
    backgroundColor: AppColors.white,
    showFilter: false,
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
              textDirection: LocalizationService.instance.textDirection,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.errorNoUpdateProfileCubit,
                  style: AppTextStyles.font18JetMediumLamaSans,
                  textAlign: TextAlign.center,
                ),
                verticalSpace(10),
                CustomElevatedButton(
                  height: 41.h,
                  onPressed: () => Navigator.pop(context),
                  textButton: AppLocalizations.of(context)!.close,
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
  // Store data mappings for ID extraction
  List<NationalCountryResponseModel> nationalitiesList = [];
  List<NationalCountryResponseModel> countriesList = [];
  List<CityResponseModels> citiesList = [];
  Map<String, List<GeneralInfoResponseModels>> generalDataLists = {};
  Map<String, dynamic> validationFlags = {}; // Track validation state

  @override
  void initState() {
    super.initState();
    _loadRequiredData();
  }

  /// Get visible fields based on current selections (for dynamic field visibility)
  List<ManageProfileField> _getVisibleFields() {
    List<ManageProfileField> visibleFields = [];

    print(
        'DEBUG: _getVisibleFields() called - Dialog type: ${widget.data.dialogType}');
    print('DEBUG: Total fields: ${widget.data.fields.length}');

    for (var field in widget.data.fields) {
      print('DEBUG: Processing field: "${field.label}"');

      // For social status dialog, check if children field should be visible
      if (widget.data.dialogType == ManageProfileDialogType.socialStatus &&
          field.label == AppLocalizations.of(context)!.numberOfChildren) {
        print(
            'DEBUG: Found children field - checking marital status for visibility');

        // Check if marital status is single
        final maritalStatusLabel = AppLocalizations.of(context)!.maritalStatus;
        print(
            'DEBUG: Looking for marital status field with label: "$maritalStatusLabel"');

        final maritalStatusField = widget.data.fields.firstWhere(
          (f) {
            print(
                'DEBUG: Checking field "${f.label}" against "$maritalStatusLabel"');
            return f.label == maritalStatusLabel;
          },
          orElse: () {
            print('DEBUG: ERROR - Marital status field not found!');
            return ManageProfileField(
              label: '',
              hint: '',
              currentValue: '',
              type: ManageProfileFieldType.text,
            );
          },
        );

        print(
            'DEBUG: Marital status field found: "${maritalStatusField.label}"');
        print(
            'DEBUG: Available selectedValues keys: ${widget.selectedValues.keys.toList()}');

        final currentMaritalStatus =
            widget.selectedValues[maritalStatusField.label];
        print(
            'DEBUG: Current marital status value from selectedValues: "$currentMaritalStatus"');

        final isSingle = _isSingleStatus(currentMaritalStatus);
        print('DEBUG: Is single status? $isSingle');

        if (isSingle) {
          print(
              'DEBUG: HIDING children field because marital status is single');
          // Hide children field if single
          continue;
        } else {
          print(
              'DEBUG: SHOWING children field because marital status is NOT single');
        }
      }

      visibleFields.add(field);
    }

    print('DEBUG: Visible fields count: ${visibleFields.length}');
    return visibleFields;
  }

  /// Check if the marital status indicates single status
  /// This method checks against the API key, not the display value
  bool _isSingleStatus(String? maritalStatus) {
    print('DEBUG: _isSingleStatus() called with value: "$maritalStatus"');

    if (maritalStatus == null || maritalStatus.isEmpty) {
      print(
          'DEBUG: _isSingleStatus() returning false - value is null or empty');
      return false;
    }

    final statusTrimmed = maritalStatus.trim();
    print('DEBUG: _isSingleStatus() trimmed value: "$statusTrimmed"');

    // Check for 'single' API key - this is the key used in the API
    // Note: We check against the key, not the display value
    if (statusTrimmed == 'single') {
      print('DEBUG: _isSingleStatus() returning true - matches "single" key');
      return true;
    }

    print(
        'DEBUG: _isSingleStatus() returning false - does not match "single" key');
    return false;
  }

  void _loadRequiredData() {
    // Only load data if SignUpListsCubit is available
    if (widget.data.signUpListsCubit == null) return;

    final signUpListsCubit = context.read<SignUpListsCubit>();
    ProfileDataLoader.loadRequiredData(signUpListsCubit, widget.data.fields);

    // If this is national country dialog, also load cities for the current country
    if (widget.data.dialogType == ManageProfileDialogType.nationalCountry) {
      _loadCitiesForCurrentCountry(signUpListsCubit);
    }
  }

  void _loadCitiesForCurrentCountry(SignUpListsCubit signUpListsCubit) {
    // Find the country field and get its current value
    final countryField = widget.data.fields.firstWhere(
      (field) => field.dataType == ManageProfileFieldDataType.country,
      orElse: () => ManageProfileField(
        label: '',
        hint: '',
        currentValue: '',
        type: ManageProfileFieldType.text,
      ),
    );

    if (countryField.currentValue.isNotEmpty) {
      // We need to wait for countries to be loaded first, then find the country ID
      // This will be handled in the state listener when countries are loaded
    }
  }

  void _handleCountriesLoadedForNationalCountry() {
    // Find the country field and get its current value
    final countryField = widget.data.fields.firstWhere(
      (field) => field.dataType == ManageProfileFieldDataType.country,
      orElse: () => ManageProfileField(
        label: '',
        hint: '',
        currentValue: '',
        type: ManageProfileFieldType.text,
      ),
    );

    if (countryField.currentValue.isNotEmpty && countriesList.isNotEmpty) {
      // Find the country ID and load cities
      final countryId = ProfileDataMappers.getCountryIdByName(
          countryField.currentValue, countriesList);
      if (countryId != null && widget.data.signUpListsCubit != null) {
        ProfileDataLoader.loadCitiesForCountry(
            widget.data.signUpListsCubit!, countryId);
      }
    }
  }

  void _handleCitiesLoadedForNationalCountry() {
    // Find the city field and get its current value
    final cityField = widget.data.fields.firstWhere(
      (field) => field.dataType == ManageProfileFieldDataType.city,
      orElse: () => ManageProfileField(
        label: '',
        hint: '',
        currentValue: '',
        type: ManageProfileFieldType.text,
      ),
    );

    if (cityField.currentValue.isNotEmpty && citiesList.isNotEmpty) {
      // Update the city controller and selected value with the current user's city
      final cityController = widget.controllers[cityField.label];
      if (cityController != null) {
        cityController.text = cityField.currentValue;
        widget.selectedValues[cityField.label] = cityField.currentValue;
        print('DEBUG: Set default city to: "${cityField.currentValue}"');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create list of listeners based on available cubits
    List<BlocListener> listeners = [
      BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          ProfileStateHandler.handleUpdateProfileState(context, state);
        },
      ),
    ];

    // Only add SignUpListsCubit listener if it's available
    if (widget.data.signUpListsCubit != null) {
      listeners.add(
        BlocListener<SignUpListsCubit, SignUpListsState>(
          listener: (context, state) {
            ProfileStateHandler.handleSignUpListsState(
              state,
              () => setState(() {}),
              nationalitiesList: nationalitiesList,
              countriesList: countriesList,
              citiesList: citiesList,
              generalDataLists: generalDataLists,
            );

            // Handle special case for national country dialog
            if (state is CountriesSuccess &&
                widget.data.dialogType ==
                    ManageProfileDialogType.nationalCountry) {
              _handleCountriesLoadedForNationalCountry();
            }

            // Handle cities loaded for national country dialog
            if (state is CitiesSuccess &&
                widget.data.dialogType ==
                    ManageProfileDialogType.nationalCountry) {
              _handleCitiesLoadedForNationalCountry();
            }
          },
        ),
      );
    }
    return MultiBlocListener(
      listeners: listeners,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            textDirection: LocalizationService.instance.textDirection,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.data.title,
                style: AppTextStyles.font20LightOrangeMediumLamaSans,
                textAlign: TextAlign.center,
              ),
              verticalSpace(10),
              // Fields
              ..._getVisibleFields().map((field) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 16.h),
                  child:
                      ProfileFieldBuilderFactory.getBuilder(field.type).build(
                    field: field,
                    controller: widget.controllers[field.label]!,
                    selectedValue: widget.selectedValues[field.label],
                    onChanged: (value) {
                      print(
                          'DEBUG: Field "${field.label}" changed to: "$value"');

                      // Check if this is the marital status field
                      final isMaritalStatusField = widget.data.dialogType ==
                              ManageProfileDialogType.socialStatus &&
                          field.label ==
                              AppLocalizations.of(context)!.maritalStatus;

                      if (isMaritalStatusField) {
                        print('DEBUG: *** MARITAL STATUS CHANGED ***');
                        print('DEBUG: New marital status value: "$value"');
                        print(
                            'DEBUG: Previous selectedValues: ${widget.selectedValues}');
                      }

                      widget.selectedValues[field.label] = value;

                      if (isMaritalStatusField) {
                        print(
                            'DEBUG: Updated selectedValues: ${widget.selectedValues}');
                      }

                      // Also update the controller for dropdown fields
                      // Only update if value is not null (null means user didn't change selection)
                      if (field.type == ManageProfileFieldType.dropdown &&
                          value != null) {
                        widget.controllers[field.label]?.text = value;
                      }

                      // Handle field-specific changes (like loading cities for country)
                      ProfileStateHandler.handleFieldChange(
                        field,
                        value,
                        context,
                        controllers: widget.controllers,
                        selectedValues: widget.selectedValues,
                        signUpListsCubit: widget.data.signUpListsCubit,
                        setState: () => setState(() {}),
                        countriesList: countriesList,
                        citiesList: citiesList,
                        validationFlags: validationFlags,
                      );

                      // Always trigger a rebuild for any field change
                      // This is especially important for conditional field visibility (e.g., children field based on marital status)
                      if (isMaritalStatusField) {
                        print(
                            'DEBUG: About to call setState() to trigger rebuild...');
                      }
                      setState(() {});
                      if (isMaritalStatusField) {
                        print(
                            'DEBUG: setState() called - UI should rebuild now');
                      }
                    },
                    context: context,
                    signUpListsCubit: widget.data.signUpListsCubit,
                    generalDataLists: generalDataLists,
                    nationalitiesList: nationalitiesList,
                    countriesList: countriesList,
                    citiesList: citiesList,
                  ),
                );
              }),

              verticalSpace(20),

              // Buttons
              Row(
                textDirection: LocalizationService.instance.textDirection,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      height: 41.h,
                      onPressed: () => Navigator.pop(context),
                      textButton: AppLocalizations.of(context)!.close,
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
                      textButton: AppLocalizations.of(context)!.edit,
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

  void _handleSave(BuildContext context) {
    // Check country-city validation first (for national country dialog)
    if (widget.data.dialogType == ManageProfileDialogType.nationalCountry &&
        ProfileStateHandler.isCountryCityValidationRequired(validationFlags)) {
      ProfileSnackbarHandler.showSnackBarAboveDialog(
        context,
        AppLocalizations.of(context)!.youShouldChooseCityFirst,
        Colors.red,
      );
      return;
    }

    if (widget.formKey.currentState!.validate()) {
      // Validate using the appropriate validation handler
      final validationHandler = ProfileValidationHandlerFactory.getHandler(
        widget.data.dialogType,
        dataLists: {
          'nationalities': nationalitiesList,
          'countries': countriesList,
          'cities': citiesList,
          ...generalDataLists,
        },
      );

      final validationResult =
          validationHandler.validate(widget.controllers, context);

      if (!validationResult.isValid) {
        ProfileSnackbarHandler.showSnackBarAboveDialog(
          context,
          validationResult.errorMessage!,
          Colors.red,
        );
        return;
      }

      // Handle save logic based on dialog type
      if (widget.data.cubit != null) {
        final updateHandler =
            ProfileUpdateHandlerFactory.getHandler(widget.data.dialogType);

        // Special handling for login data to pass field data for country code
        if (widget.data.dialogType == ManageProfileDialogType.loginData) {
          final loginHandler = updateHandler as LoginDataUpdateHandler;
          loginHandler.updateWithFieldData(
            widget.controllers,
            widget.data.cubit!,
            context,
            widget.data.fields,
            nationalitiesList: nationalitiesList,
            countriesList: countriesList,
            citiesList: citiesList,
            generalDataLists: generalDataLists,
          );
        }
        // Special handling for national country data to pass field data for old values
        else if (widget.data.dialogType ==
            ManageProfileDialogType.nationalCountry) {
          final nationalCountryHandler =
              updateHandler as NationalCountryUpdateHandler;
          nationalCountryHandler.updateWithFieldData(
            widget.controllers,
            widget.data.cubit!,
            context,
            widget.data.fields,
            nationalitiesList: nationalitiesList,
            countriesList: countriesList,
            citiesList: citiesList,
            generalDataLists: generalDataLists,
          );
        } else {
          updateHandler.update(
            widget.controllers,
            widget.data.cubit!,
            context,
            nationalitiesList: nationalitiesList,
            countriesList: countriesList,
            citiesList: citiesList,
            generalDataLists: generalDataLists,
          );
        }
      }
    }
  }
}
