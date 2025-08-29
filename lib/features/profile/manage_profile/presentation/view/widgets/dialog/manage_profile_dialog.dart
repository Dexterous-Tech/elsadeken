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

import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
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
                verticalSpace(10),
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
  // Store data mappings for ID extraction
  List<NationalCountryResponseModel> nationalitiesList = [];
  List<NationalCountryResponseModel> countriesList = [];
  List<CityResponseModels> citiesList = [];
  Map<String, List<GeneralInfoResponseModels>> generalDataLists = {};

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
    // Create list of listeners based on available cubits
    List<BlocListener> listeners = [
      BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          _handleUpdateProfileState(context, state);
        },
      ),
    ];

    // Only add SignUpListsCubit listener if it's available
    if (widget.data.signUpListsCubit != null) {
      listeners.add(
        BlocListener<SignUpListsCubit, SignUpListsState>(
          listener: (context, state) {
            _handleSignUpListsState(state);
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
            children: [
              // Title
              Text(
                widget.data.title,
                style: AppTextStyles.font20LightOrangeMediumLamaSans,
                textAlign: TextAlign.center,
              ),
              verticalSpace(10),

              // Fields
              ...widget.data.fields.map((field) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildFieldInternal(
                    field: field,
                    controller: widget.controllers[field.label]!,
                    selectedValue: widget.selectedValues[field.label],
                    onChanged: (value) {
                      print(
                          'DEBUG: Field "${field.label}" changed to: "$value"');
                      widget.selectedValues[field.label] = value;
                      // Also update the controller for dropdown fields
                      if (field.type == ManageProfileFieldType.dropdown) {
                        widget.controllers[field.label]?.text = value ?? '';
                      }
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
      // Extract country ID from the selected country name
      final countryId = _getCountryIdByName(value);
      if (countryId != null) {
        signUpListsCubit.getCites(countryId.toString());

        // Reset city field when country changes
        final cityController = widget.controllers['المدينة'];
        if (cityController != null) {
          cityController.clear();
          widget.selectedValues['المدينة'] =
              null; // Set to null instead of empty string
          setState(() {}); // Trigger rebuild to update UI
        }
      }
    }
  }

  int? _getCountryIdByName(String countryName) {
    try {
      print('DEBUG: Looking for country: "$countryName"');
      print(
          'DEBUG: Available countries: ${countriesList.map((c) => '${c.name} (ID: ${c.id})').toList()}');
      final country = countriesList.firstWhere(
        (country) => country.name == countryName,
      );
      print('DEBUG: Found country ID: ${country.id}');
      return country.id;
    } catch (e) {
      print('DEBUG: Country not found: $e');
      return null;
    }
  }

  int? _getNationalityIdByName(String nationalityName) {
    try {
      print('DEBUG: Looking for nationality: "$nationalityName"');
      print(
          'DEBUG: Available nationalities: ${nationalitiesList.map((n) => '${n.name} (ID: ${n.id})').toList()}');
      final nationality = nationalitiesList.firstWhere(
        (nationality) => nationality.name == nationalityName,
      );
      print('DEBUG: Found nationality ID: ${nationality.id}');
      return nationality.id;
    } catch (e) {
      print('DEBUG: Nationality not found: $e');
      return null;
    }
  }

  int? _getCityIdByName(String cityName) {
    try {
      print('DEBUG: Looking for city: "$cityName"');
      print(
          'DEBUG: Available cities: ${citiesList.map((c) => '${c.name} (ID: ${c.id})').toList()}');
      final city = citiesList.firstWhere(
        (city) => city.name == cityName,
      );
      print('DEBUG: Found city ID: ${city.id}');
      return city.id;
    } catch (e) {
      print('DEBUG: City not found: $e');
      return null;
    }
  }

  int? _getSkinColorIdByName(String skinColorName) {
    try {
      final skinColors = generalDataLists['skinColors'];
      if (skinColors != null && skinColors.isNotEmpty) {
        final skinColor = skinColors.firstWhere(
          (item) => item.name == skinColorName,
        );
        return skinColor.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  int? _getPhysiqueIdByName(String physiqueName) {
    try {
      final physiques = generalDataLists['physiques'];
      if (physiques != null && physiques.isNotEmpty) {
        final physique = physiques.firstWhere(
          (item) => item.name == physiqueName,
        );
        return physique.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  int? _getQualificationIdByName(String qualificationName) {
    try {
      final qualifications = generalDataLists['qualifications'];
      if (qualifications != null && qualifications.isNotEmpty) {
        final qualification = qualifications.firstWhere(
          (item) => item.name == qualificationName,
        );
        return qualification.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  int? _getFinancialSituationIdByName(String financialSituationName) {
    try {
      final financialSituations = generalDataLists['financialSituations'];
      if (financialSituations != null && financialSituations.isNotEmpty) {
        final financialSituation = financialSituations.firstWhere(
          (item) => item.name == financialSituationName,
        );
        return financialSituation.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  int? _getHealthConditionIdByName(String healthConditionName) {
    try {
      final healthConditions = generalDataLists['healthConditions'];
      if (healthConditions != null && healthConditions.isNotEmpty) {
        final healthCondition = healthConditions.firstWhere(
          (item) => item.name == healthConditionName,
        );
        return healthCondition.id;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _handleSignUpListsState(SignUpListsState state) {
    if (state is NationalitiesSuccess) {
      setState(() {
        nationalitiesList = state.nationalitiesList;
      });
    } else if (state is CountriesSuccess) {
      setState(() {
        countriesList = state.countriesList;
      });
    } else if (state is CitiesSuccess) {
      setState(() {
        citiesList = state.citiesList;
      });
    } else if (state is SkinColorsSuccess) {
      setState(() {
        generalDataLists['skinColors'] = state.generalList;
      });
    } else if (state is PhysiquesSuccess) {
      setState(() {
        generalDataLists['physiques'] = state.generalList;
      });
    } else if (state is QualificationsSuccess) {
      setState(() {
        generalDataLists['qualifications'] = state.generalList;
      });
    } else if (state is FinancialSituationsSuccess) {
      setState(() {
        generalDataLists['financialSituations'] = state.generalList;
      });
    } else if (state is HealthConditionsSuccess) {
      setState(() {
        generalDataLists['healthConditions'] = state.generalList;
      });
    }
  }

  void _handleUpdateProfileState(
      BuildContext context, UpdateProfileState state) {
    if (state is UpdateProfileLoginDataLoading ||
        state is UpdateProfileLocationDataLoading ||
        state is UpdateProfileMarriageDataLoading ||
        state is UpdateProfilePhysicalDataLoading ||
        state is UpdateProfileReligiousDataLoading ||
        state is UpdateProfileWorkDataLoading ||
        state is UpdateProfileAboutMeDataLoading ||
        state is UpdateProfileAboutPartnerDataLoading) {
      // Show loading dialog and keep the edit dialog open in background
      loadingDialog(context);
    } else if (state is UpdateProfileLoginDataFailure ||
        state is UpdateProfileLocationDataFailure ||
        state is UpdateProfileMarriageDataFailure ||
        state is UpdateProfilePhysicalDataFailure ||
        state is UpdateProfileReligiousDataFailure ||
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
      else if (state is UpdateProfileReligiousDataFailure)
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
        state is UpdateProfileReligiousDataSuccess ||
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
      final password = widget.controllers['كلمة المرور (اختياري)']?.text ?? '';
      final passwordConfirmation =
          widget.controllers['تأكيد كلمة المرور (اختياري)']?.text ?? '';

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
        // Extract selected values from controllers
        final nationalityName = widget.controllers['الجنسية']?.text ?? '';
        final countryName = widget.controllers['الدولة']?.text ?? '';
        final cityName = widget.controllers['المدينة']?.text ?? '';

        print('DEBUG: Extracted values from controllers:');
        print('  - nationalityName: "$nationalityName"');
        print('  - countryName: "$countryName"');
        print('  - cityName: "$cityName"');

        // Get IDs from names using mapping functions - only send if valid selections are made
        final nationalityId = _getNationalityIdByName(nationalityName);
        final countryId = _getCountryIdByName(countryName);
        final cityId = _getCityIdByName(cityName);

        print('DEBUG: Extracted IDs:');
        print('  - nationalityId: $nationalityId');
        print('  - countryId: $countryId');
        print('  - cityId: $cityId');

        // Only proceed if we have valid IDs for all required fields
        if (nationalityId != null && countryId != null && cityId != null) {
          print('DEBUG: All IDs are valid, making API call');
          widget.data.cubit!.updateProfileLocationData(
            nationalityId: nationalityId,
            countryId: countryId,
            cityId: cityId,
          );
        } else {
          print('DEBUG: Some IDs are null, showing error message');
          // Show error message if any required field is missing
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('يرجى اختيار جميع الحقول المطلوبة'),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;

      case ManageProfileDialogType.job:
        final qualificationName =
            widget.controllers['المؤهل التعليمي']?.text ?? '';
        final financialSituationName =
            widget.controllers['الوضع المادي']?.text ?? '';
        final jobTitle = widget.controllers['الوظيفة']?.text ?? '';
        final monthlyIncomeStr = widget.controllers['الدخل الشهري']?.text ?? '';
        final healthConditionName =
            widget.controllers['الحالة الصحية']?.text ?? '';

        // Debug: Print collected values
        print('DEBUG: Collected Job Values:');
        print('  - qualificationName: "$qualificationName"');
        print('  - financialSituationName: "$financialSituationName"');
        print('  - jobTitle: "$jobTitle"');
        print('  - monthlyIncomeStr: "$monthlyIncomeStr"');
        print('  - healthConditionName: "$healthConditionName"');

        // Get IDs from names using mapping functions
        final qualificationId = _getQualificationIdByName(qualificationName);
        final financialSituationId =
            _getFinancialSituationIdByName(financialSituationName);
        final healthConditionId =
            _getHealthConditionIdByName(healthConditionName);

        // Convert income string to number
        int? income;
        try {
          income =
              monthlyIncomeStr.isNotEmpty ? int.parse(monthlyIncomeStr) : null;
        } catch (e) {
          print('DEBUG: Income parsing error: $e');
          income = null;
        }

        // Debug: Print extracted IDs
        print('DEBUG: Extracted Job IDs:');
        print('  - qualificationId: $qualificationId');
        print('  - financialSituationId: $financialSituationId');
        print('  - healthConditionId: $healthConditionId');
        print('  - income: $income');

        widget.data.cubit!.updateProfileWorkData(
          qualificationId: qualificationId?.toString(),
          income: income,
          job: jobTitle.isNotEmpty ? jobTitle : null,
          healthConditionId: healthConditionId?.toString(),
          financialSituationId: financialSituationId?.toString(),
        );
        break;

      case ManageProfileDialogType.socialStatus:
        final maritalStatus =
            widget.controllers['الحالة الاجتماعية']?.text ?? '';
        final typeOfMarriage = widget.controllers['نوع الزواج']?.text ?? '';
        final ageStr = widget.controllers['العمر']?.text ?? '';
        final childrenStr = widget.controllers['عدد الأطفال']?.text ?? '';

        // Convert Arabic text to API values
        String? maritalStatusValue;
        if (maritalStatus.isNotEmpty) {
          switch (maritalStatus) {
            // Female options
            case 'آنسة':
              maritalStatusValue = 'single';
              break;
            case 'متزوجة':
              maritalStatusValue = 'married';
              break;
            case 'مطلقة':
              maritalStatusValue = 'divorced';
              break;
            case 'أرملة':
              maritalStatusValue = 'widwed';
              break;
            // Male options
            case 'عازب':
              maritalStatusValue = 'single';
              break;
            case 'متزوج':
              maritalStatusValue = 'married';
              break;
            case 'مطلق':
              maritalStatusValue = 'divorced';
              break;
            case 'أرمل':
              maritalStatusValue = 'widwed';
              break;
          }
        }

        String? typeOfMarriageValue;
        if (typeOfMarriage.isNotEmpty) {
          switch (typeOfMarriage) {
            // Female options
            case 'الزوج الوحيد':
              typeOfMarriageValue = 'only_one';
              break;
            case 'لا مانع من تعدل الزوجات':
              typeOfMarriageValue = 'multi';
              break;
            // Male options
            case 'زوجة اولي':
              typeOfMarriageValue = 'only_one';
              break;
            case 'زوجة ثانية':
              typeOfMarriageValue = 'multi';
              break;
          }
        }

        // Convert strings to numbers
        int? age;
        int? childrenNumber;
        try {
          age = ageStr.isNotEmpty ? int.parse(ageStr) : null;
        } catch (e) {
          // Handle age parsing error
        }
        try {
          childrenNumber =
              childrenStr.isNotEmpty ? int.parse(childrenStr) : null;
        } catch (e) {
          // Handle children number parsing error
        }

        widget.data.cubit!.updateProfileMarriageData(
          maritalStatus: maritalStatusValue,
          typeOfMarriage: typeOfMarriageValue,
          childrenNumber: childrenNumber,
          age: age,
        );
        break;

      case ManageProfileDialogType.bodyInfo:
        final weightStr = widget.controllers['الوزن']?.text ?? '';
        final heightStr = widget.controllers['الطول']?.text ?? '';
        final skinColorName = widget.controllers['لون البشرة']?.text ?? '';
        final physiqueName = widget.controllers['البنية الجسدية']?.text ?? '';

        // Convert string values to integers
        int? weight = weightStr.isNotEmpty ? int.tryParse(weightStr) : null;
        int? height = heightStr.isNotEmpty ? int.tryParse(heightStr) : null;

        // Get IDs from names (we'll need to implement these methods)
        int? skinColorId = _getSkinColorIdByName(skinColorName);
        int? physiqueId = _getPhysiqueIdByName(physiqueName);

        widget.data.cubit!.updateProfilePhysicalData(
          weight: weight,
          height: height,
          skinColorId: skinColorId,
          physiqueId: physiqueId,
        );
        break;

      case ManageProfileDialogType.education:
        final qualificationName =
            widget.controllers['المؤهل التعليمي']?.text ?? '';
        final financialSituationName =
            widget.controllers['الوضع المادي']?.text ?? '';
        final jobTitle = widget.controllers['الوظيفة']?.text ?? '';
        final monthlyIncomeStr = widget.controllers['الدخل الشهري']?.text ?? '';
        final healthConditionName =
            widget.controllers['الحالة الصحية']?.text ?? '';

        // Convert income string to number
        int? income =
            monthlyIncomeStr.isNotEmpty ? int.tryParse(monthlyIncomeStr) : null;

        widget.data.cubit!.updateProfileWorkData(
          qualificationId:
              qualificationName.isNotEmpty ? qualificationName : null,
          income: income,
          job: jobTitle.isNotEmpty ? jobTitle : null,
          healthConditionId:
              healthConditionName.isNotEmpty ? healthConditionName : null,
          financialSituationId:
              financialSituationName.isNotEmpty ? financialSituationName : null,
        );
        break;

      case ManageProfileDialogType.descriptions:
        final aboutMe = widget.controllers['نبذة عني']?.text ?? '';
        final aboutPartner = widget.controllers['شريك الحياة']?.text ?? '';

        // Update about me if field exists and is not empty
        if (aboutMe.isNotEmpty) {
          widget.data.cubit!.updateProfileAboutMeData(
            aboutMe: aboutMe,
          );
        }

        // Update about partner if field exists and is not empty
        if (aboutPartner.isNotEmpty) {
          widget.data.cubit!.updateProfileAboutPartnerData(
            lifePartner: aboutPartner,
          );
        }
        break;

      case ManageProfileDialogType.religion:
        final religiousCommitment =
            widget.controllers['الإلتزام الديني']?.text ?? '';
        final prayer = widget.controllers['الصلاة']?.text ?? '';
        final smokingStr = widget.controllers['التدخين']?.text ?? '';
        final hijab = widget.controllers['هل تريد شريك حياتك بحجاب ؟']?.text ??
            widget.controllers['الحجاب']?.text ??
            '';
        final beard = widget.controllers['اللحية']?.text ?? '';

        // Debug: Print collected values
        print('DEBUG: Collected Religious Commitment: "$religiousCommitment"');
        print('DEBUG: Collected Prayer: "$prayer"');
        print('DEBUG: Collected Smoking: "$smokingStr"');
        print('DEBUG: Collected Hijab: "$hijab"');
        print('DEBUG: Collected Beard: "$beard"');

        // Convert Arabic text to API values
        String? religiousCommitmentValue;
        if (religiousCommitment.isNotEmpty) {
          switch (religiousCommitment) {
            case 'غير متدين':
              religiousCommitmentValue = 'irreligious';
              break;
            case 'متدين قليلا':
              religiousCommitmentValue = 'little_religious';
              break;
            case 'متدين':
              religiousCommitmentValue = 'religious';
              break;
            case 'متدين كثيرا':
              religiousCommitmentValue = 'much_religious';
              break;
            case 'أفضل الا اقول':
              religiousCommitmentValue = 'dont_say';
              break;
          }
        }

        String? prayerValue;
        if (prayer.isNotEmpty) {
          switch (prayer) {
            case 'اصلي دائما':
              prayerValue = 'always';
              break;
            case 'اصلي اغلب الاوقات':
              prayerValue = 'most_times';
              break;
            case 'اصلي بعض الاحيان':
              prayerValue = 'sometimes';
              break;
            case 'لا اصلي':
              prayerValue = 'no_pray';
              break;
            case 'أفضل الا اقول':
              prayerValue = 'dont_say';
              break;
          }
        }

        // Convert smoking string to int (0 for "لا", 1 for "نعم")
        int? smoking;
        if (smokingStr.isNotEmpty) {
          smoking = smokingStr == 'نعم' ? 1 : 0;
        }

        String? hijabValue;
        if (hijab.isNotEmpty) {
          switch (hijab) {
            case 'غير محجبه':
              hijabValue = 'not_hijab';
              break;
            case 'محجبه(كشف الوجه)':
              hijabValue = 'hijab';
              break;
            case 'محجبه (النقاب)':
              hijabValue = 'hijab_and_veil';
              break;
            case 'محجبه (غطاء الوجه)':
              hijabValue = 'hijab_face';
              break;
            case 'افضل الا اقول':
              hijabValue = 'dont_say';
              break;
          }
        }

        String? beardValue;
        if (beard.isNotEmpty) {
          switch (beard) {
            case 'ملتحي':
              beardValue = 'beard';
              break;
            case 'بدون لحية':
              beardValue = 'without_beard';
              break;
          }
        }

        // Debug: Print final API values
        print('DEBUG: Final API Values:');
        print('  - religiousCommitment: $religiousCommitmentValue');
        print('  - prayer: $prayerValue');
        print('  - smoking: $smoking');
        print('  - hijab: $hijabValue');
        print('  - beard: $beardValue');

        widget.data.cubit!.updateProfileReligiousData(
          religiousCommitment: religiousCommitmentValue,
          prayer: prayerValue,
          smoking: smoking,
          hijab: hijabValue,
          beard: beardValue,
        );
        break;

      case ManageProfileDialogType.personalInfo:
      case null:
        // For now, fall back to login data if no type is specified
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
    }
  }

  Widget _buildDynamicDropdownInternal(
    ManageProfileField field,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    // If SignUpListsCubit is not available, show empty dropdown
    if (widget.data.signUpListsCubit == null) {
      return Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: AppTextStyles.font18JetMediumLamaSans,
            textAlign: TextAlign.right,
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
                    initialValue:
                        selectedValue, // Pass the selected value directly
                  ),
          ],
        );
      },
    );
  }

  Widget _buildFieldInternal({
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
            verticalSpace(2),
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
            verticalSpace(2),
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
          return _buildDynamicDropdownInternal(field, selectedValue, onChanged);
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
  }
}
