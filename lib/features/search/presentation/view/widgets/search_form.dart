// File: lib/presentation/widgets/search_form.dart
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/auth/signup/data/data_source/signup_data_source.dart';
import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/range_text_field.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import '../../cubit/search_cubit.dart';
import 'dropdown_field.dart';
import 'expandable_section.dart';
import 'search_text_field.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  int? cityId; // ده بيساوي let city_id;
  String? userGender; // Store user gender from shared preferences

  late Future<List<NationalCountryResponseModel>> _nationalities;
  late Future<List<NationalCountryResponseModel>> _countries;
  late Future<List<CityResponseModels>> _cities;

  // Store skin colors and qualifications data
  List<GeneralInfoResponseModels> _skinColors = [];
  List<GeneralInfoResponseModels> _qualifications = [];
  bool _isLoadingSkinColors = true;
  bool _isLoadingQualifications = true;

  Map<String, String> get _maritalStatusMaleMap {
    final l10n = AppLocalizations.of(context)!;
    return {
      l10n.single: 'single',
      l10n.married: 'married',
      l10n.divorced: 'divorced',
      l10n.widowed: 'widower',
    };
  }

  Map<String, String> get _maritalStatusFemaleMap {
    final l10n = AppLocalizations.of(context)!;
    return {
      l10n.singleFemale: 'single',
      l10n.divorcedFemale: 'divorced',
      l10n.widowedFemale: 'widower',
    };
  }

  Map<String, String> get _typeOfMarriageMaleMap {
    final l10n = AppLocalizations.of(context)!;
    return {
      l10n.onlyWife: 'only_one',
      l10n.noObjectionToPolygamy: 'multi',
    };
  }

  Map<String, String> get _typeOfMarriageFemaleMap {
    final l10n = AppLocalizations.of(context)!;
    return {
      l10n.firstWife: 'only_one',
      l10n.secondWife: 'multi',
    };
  }

  bool get _isMale {
    final value = (userGender ?? '').trim().toLowerCase();
    return value == 'male' || value == 'm' || value == 'ذكر';
  }

  bool get _isFemale {
    final value = (userGender ?? '').trim().toLowerCase();
    return value == 'female' ||
        value == 'f' ||
        value == 'أنثى' ||
        value == 'انثى';
  }

  @override
  void initState() {
    super.initState();
    _initNationalities();
    _loadUserGender();
    _loadSkinColorsAndQualifications();
  }

  void _loadUserGender() async {
    try {
      final gender = await SharedPreferencesHelper.getSecuredString(
          SharedPreferencesKey.gender);
      setState(() {
        userGender = gender;
      });
    } catch (e) {
      // print('Error loading user gender: $e');
    }
  }

  void _loadSkinColorsAndQualifications() {
    // Load skin colors and qualifications using SignUpListsCubit
    final signUpListsCubit = context.read<SignUpListsCubit>();
    signUpListsCubit.getSkinColors();
    signUpListsCubit.getQualification();
  }

  void _initNationalities() async {
    final apiServices = await ApiServices.init();
    final signupDataSource = SignupDataSource(apiServices);
    setState(() {
      _nationalities = signupDataSource.getNationalities();
      _countries = signupDataSource.getCountries();

      _cities = signupDataSource
          .getCities((cityId ?? 1).toString()); // بدل cityId || 0

      // _cities = signupDataSource.getCities();
    });

    // print("cities: ${_cities}");
  }

  // Get the appropriate marital status map based on gender
  Map<String, String> get maritalStatusMap {
    if (_isMale) {
      return _maritalStatusFemaleMap;
    } else if (_isFemale) {
      return _maritalStatusMaleMap;
    }
    // Default to male map if gender is not determined
    return _maritalStatusMaleMap;
  }

  // Get the appropriate marriage type map based on gender
  Map<String, String> get typeOfMarriageMap {
    if (_isMale) {
      return _typeOfMarriageFemaleMap;
    } else if (_isFemale) {
      return _typeOfMarriageMaleMap;
    }
    // Default to male map if gender is not determined
    return _typeOfMarriageMaleMap;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpListsCubit, SignUpListsState>(
      listener: (context, state) {
        if (state is SkinColorsSuccess) {
          setState(() {
            _skinColors = state.generalList;
            _isLoadingSkinColors = false;
          });
        } else if (state is QualificationsSuccess) {
          setState(() {
            _qualifications = state.generalList;
            _isLoadingQualifications = false;
          });
        } else if (state is SkinColorsLoading) {
          setState(() {
            _isLoadingSkinColors = true;
          });
        } else if (state is QualificationsLoading) {
          setState(() {
            _isLoadingQualifications = true;
          });
        }
      },
      child: Column(
        textDirection: LocalizationService.instance.textDirection,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Search Fields
          SearchTextField(
            onTap: () {
              context.read<SearchCubit>().performSearch();
              Navigator.pushNamed(
                context,
                AppRoutes.searchResultScreen,
                arguments: context.read<SearchCubit>(),
              );
            },
            hintText: AppLocalizations.of(context)!.searchByUsername,
            onChanged: (value) =>
                context.read<SearchCubit>().updateUsername(value),
          ),
          SizedBox(height: 16),
          SearchTextField(
            onTap: () {
              context.read<SearchCubit>().performSearch();
              Navigator.pushNamed(
                context,
                AppRoutes.searchResultScreen,
                arguments: context.read<SearchCubit>(),
              );
            },
            hintText: AppLocalizations.of(context)!.quickSearch,
            onChanged: (value) =>
                context.read<SearchCubit>().updateQuickSearch(value),
          ),
          SizedBox(height: 24),

          // Nationality & Location Section
          ExpandableSection(
            title: AppLocalizations.of(context)!.nationalityAndResidence,
            children: [
              FutureBuilder<List<NationalCountryResponseModel>>(
                future: _nationalities, // الفيوتشر اللي بيرجع الجنسيات
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(AppLocalizations.of(context)!
                        .error(snapshot.error.toString()));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                        AppLocalizations.of(context)!.noNationalitiesAvailable);
                  }

                  final nationalityObjects = snapshot.data!;

                  final nationalities = nationalityObjects
                      .map((e) => e.name ?? "")
                      .where((name) => name.isNotEmpty)
                      .toList();

                  return DropdownField(
                    label: AppLocalizations.of(context)!.nationality,
                    hint: AppLocalizations.of(context)!.choose,
                    items: nationalities,
                    onChanged: (value) {
                      final selected = snapshot.data!
                          .firstWhere((element) => element.name == value);
                      context
                          .read<SearchCubit>()
                          .updateNationality(selected.id.toString());
                    },
                  );
                },
              ),
              //
              SizedBox(height: 12),

              FutureBuilder<List<NationalCountryResponseModel>>(
                future: _countries, // الفيوتشر اللي بيرجع الجنسيات
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(AppLocalizations.of(context)!
                        .error(snapshot.error.toString()));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                        AppLocalizations.of(context)!.noNationalitiesAvailable);
                  }

                  final countryObjects = snapshot.data!;

                  final countries = countryObjects
                      .map((e) => e.name ?? "")
                      .where((name) => name.isNotEmpty)
                      .toList();

                  return DropdownField(
                    label: AppLocalizations.of(context)!.country,
                    hint: AppLocalizations.of(context)!.choose,
                    items: countries,
                    onChanged: (value) async {
                      if (value != null) {
                        final selectedCountry = countryObjects.firstWhere(
                          (element) => element.name == value,
                        );

                        // Capture context before async operation
                        final searchCubit = context.read<SearchCubit>();

                        final apiServices = await ApiServices.init();
                        final signupDataSource = SignupDataSource(apiServices);
                        final newCities = signupDataSource
                            .getCities(selectedCountry.id.toString());

                        setState(() {
                          cityId = selectedCountry.id;
                          _cities = newCities; // تحديث Future المدن
                        });

                        searchCubit
                            .updateCountry(selectedCountry.id.toString());
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 12),
              // DropdownField(
              //   label: 'المدينة',
              //   hint: 'اختر مدينتك',
              //   items: ['القاهرة', 'الإسكندرية', 'الجيزة', 'الرياض'],
              //   onChanged: (value) =>
              //       context.read<SearchCubit>().updateCity(value!),
              // ),

              FutureBuilder<List<CityResponseModels>>(
                future: _cities, // الفيوتشر اللي بيرجع الجنسيات
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(AppLocalizations.of(context)!
                        .error(snapshot.error.toString()));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                        AppLocalizations.of(context)!.noCitiesAvailable);
                  }

                  // ✅ تحويل الجنسيات من موديل إلى List<String>
                  final cities = snapshot.data!
                      .map((e) => e.name ?? "")
                      .where((name) => name.isNotEmpty)
                      .toList();

                  return DropdownField(
                    label: AppLocalizations.of(context)!.city,
                    hint: AppLocalizations.of(context)!.choose,
                    items: cities,
                    onChanged: (value) {
                      final selectedCity = snapshot.data!
                          .firstWhere((element) => element.name == value);

                      context
                          .read<SearchCubit>()
                          .updateCity(selectedCity.id.toString());
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),

          // Physical Attributes Section
          ExpandableSection(
            title: AppLocalizations.of(context)!.appearancePreferences,
            children: [
              DropdownField(
                label: AppLocalizations.of(context)!.typeOfMarriage,
                hint: AppLocalizations.of(context)!.all,
                items: typeOfMarriageMap.keys.toList(),
                onChanged: (value) {
                  final key = typeOfMarriageMap[value];
                  if (key != null) {
                    context.read<SearchCubit>().updateTypeOfMarriage(key);
                  }
                },
              ),
              SizedBox(height: 12),
              DropdownField(
                label: AppLocalizations.of(context)!.maritalStatus,
                hint: AppLocalizations.of(context)!.all,
                items: maritalStatusMap.keys.toList(),
                onChanged: (value) {
                  final key = maritalStatusMap[value];
                  if (key != null) {
                    context.read<SearchCubit>().updateMaritalStatus(key);
                  }
                },
              ),
              SizedBox(height: 12),
              RangeTextField(
                  label: AppLocalizations.of(context)!.age,
                  fromHint: AppLocalizations.of(context)!.from,
                  toHint: AppLocalizations.of(context)!.to,
                  onRangeChanged: (from, to) {
                    if (from != null || to != null) {
                      context
                          .read<SearchCubit>()
                          .updateAgeRange(from ?? 0, to ?? 0);
                    }
                  }),
              SizedBox(height: 12),
              RangeTextField(
                label: AppLocalizations.of(context)!.heightCm,
                fromHint: AppLocalizations.of(context)!.from,
                toHint: AppLocalizations.of(context)!.to,
                maxLength: 3,
                onRangeChanged: (from, to) {
                  if (from != null || to != null) {
                    context
                        .read<SearchCubit>()
                        .updateHeightRange(from ?? 0, to ?? 0);
                  }
                },
              ),
              SizedBox(height: 12),
              RangeTextField(
                label: AppLocalizations.of(context)!.weightKg,
                fromHint: AppLocalizations.of(context)!.from,
                toHint: AppLocalizations.of(context)!.to,
                maxLength: 3,
                onRangeChanged: (from, to) {
                  if (from != null || to != null) {
                    context
                        .read<SearchCubit>()
                        .updateWeightRange(from ?? 0, to ?? 0);
                  }
                },
              ),
              SizedBox(height: 12),
              DropdownField(
                label: AppLocalizations.of(context)!.skinColor,
                hint: AppLocalizations.of(context)!.all,
                items: _isLoadingSkinColors
                    ? [AppLocalizations.of(context)!.loading]
                    : _skinColors
                        .map((e) => e.name ?? "")
                        .where((name) => name.isNotEmpty)
                        .toList(),
                onChanged: (value) {
                  if (!_isLoadingSkinColors &&
                      value != null &&
                      value != AppLocalizations.of(context)!.loading) {
                    final selectedSkinColor = _skinColors.firstWhere(
                      (element) => element.name == value,
                    );
                    context
                        .read<SearchCubit>()
                        .updateSkinColor(selectedSkinColor.id.toString());
                  }
                },
              ),
              SizedBox(height: 12),
              DropdownField(
                label: AppLocalizations.of(context)!.educationalQualification,
                hint: AppLocalizations.of(context)!.all,
                items: _isLoadingQualifications
                    ? [AppLocalizations.of(context)!.loading]
                    : _qualifications
                        .map((e) => e.name ?? "")
                        .where((name) => name.isNotEmpty)
                        .toList(),
                onChanged: (value) {
                  if (!_isLoadingQualifications &&
                      value != null &&
                      value != AppLocalizations.of(context)!.loading) {
                    final selectedQualification = _qualifications.firstWhere(
                      (element) => element.name == value,
                    );
                    context.read<SearchCubit>().updateQualification(
                        selectedQualification.id.toString());
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 16),

          // Sort Section
          ExpandableSection(
            title: AppLocalizations.of(context)!.sortResults,
            children: [
              DropdownField(
                label: '',
                hint: AppLocalizations.of(context)!.mostVisitedFirst,
                items: [
                  AppLocalizations.of(context)!.mostVisitedFirst,
                  AppLocalizations.of(context)!.newestFirst,
                  AppLocalizations.of(context)!.oldestFirst
                ],
                onChanged: (value) {},
              ),
            ],
          ),
          SizedBox(height: 32),

          // Search Button
          BlocConsumer<SearchCubit, SearchState>(
            listener: (context, state) {
              if (state is SearchError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is SearchSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .foundResults(state.results.length.toString()))),
                );
              }
            },
            builder: (context, state) {
              return SearchButton(
                  isLoading: state is SearchLoading,
                  onPressed: () {
                    context.read<SearchCubit>().performSearch();
                    Navigator.pushNamed(
                      context,
                      AppRoutes.searchResultScreen,
                      arguments: context.read<SearchCubit>(),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
