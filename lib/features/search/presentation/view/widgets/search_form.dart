// File: lib/presentation/widgets/search_form.dart
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/features/auth/signup/data/data_source/signup_data_source.dart';
import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/results/presentation/view/results_screen.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/range_text_field.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  // final List<String> x = const ['مصري', 'سعودي', 'إماراتي', 'كويتي'];

  int? cityId; // ده بيساوي let city_id;

  late Future<List<NationalCountryResponseModel>> _nationalities;
  late Future<List<NationalCountryResponseModel>> _countries;
  late Future<List<CityResponseModels>> _cities;

  

  @override
  void initState() {
    super.initState();
    _initNationalities();
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

    print("cities: ${_cities}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search Fields
        SearchTextField(
          hintText: 'بحث بإسم المستخدم',
          onChanged: (value) =>
              context.read<SearchCubit>().updateUsername(value),
        ),
        SizedBox(height: 16),
        SearchTextField(
          hintText: 'البحث السريع',
          onChanged: (value) =>
              context.read<SearchCubit>().updateQuickSearch(value),
        ),
        SizedBox(height: 24),

        // Nationality & Location Section
        ExpandableSection(
          title: 'الجنسية والإقامة',
          children: [
            FutureBuilder<List<NationalCountryResponseModel>>(
              future: _nationalities, // الفيوتشر اللي بيرجع الجنسيات
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("خطأ: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("لا توجد جنسيات متاحة");
                }

                // ✅ تحويل الجنسيات من موديل إلى List<String>
                final nationalities = snapshot.data!
                    .map((e) => e.name ?? "")
                    .where((name) => name.isNotEmpty)
                    .toList();

                return DropdownField(
                  label: 'الجنسية',
                  hint: 'مختار',
                  items: nationalities,
                  onChanged: (value) =>
                      context.read<SearchCubit>().updateNationality(value!),
                );
              },
            ),
            //
            SizedBox(height: 12),
            // DropdownField(
            //   label: 'الدولة',
            //   hint: 'مختار',
            //   items: ['مصر', 'السعودية', 'الإمارات', 'الكويت'],
            //   onChanged: (value) =>
            //       context.read<SearchCubit>().updateCountry(value!),
            // ),

            FutureBuilder<List<NationalCountryResponseModel>>(
              future: _countries, // الفيوتشر اللي بيرجع الجنسيات
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("خطأ: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("لا توجد جنسيات متاحة");
                }

                // ✅ تحويل الجنسيات من موديل إلى List<String>
                final countryObjects = snapshot.data!;

                final countries = countryObjects
                    .map((e) => e.name ?? "")
                    .where((name) => name.isNotEmpty)
                    .toList();

                return DropdownField(
                  label: 'الدولة',
                  hint: 'مختار',
                  items: countries,
                  onChanged: (value) async {
                    if (value != null) {
                      // العثور على العنصر المختار
                      final selectedCountry = countryObjects.firstWhere(
                        (element) => element.name == value,
                      );

                      // تحديث المدن حسب الدولة المختارة
                      final apiServices = await ApiServices.init();
                      final signupDataSource = SignupDataSource(apiServices);
                      final newCities = signupDataSource
                          .getCities(selectedCountry.id.toString());

                      setState(() {
                        cityId = selectedCountry.id;
                        _cities = newCities; // تحديث Future المدن
                      });

                      context
                          .read<SearchCubit>()
                          .updateCountry((selectedCountry.id!).toString());
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
                  return Text("خطأ: ${snapshot.error}");
                } else if (_countries == null) {
                  return const Text("اختر دولة اولا");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("لا توجد مدن متاحة");
                }

                // ✅ تحويل الجنسيات من موديل إلى List<String>
                final cities = snapshot.data!
                    .map((e) => e.name ?? "")
                    .where((name) => name.isNotEmpty)
                    .toList();

                return DropdownField(
                  label: 'الدولة',
                  hint: 'اختار',
                  items: cities,
                  onChanged: (value) =>
                      context.read<SearchCubit>().updateNationality(value!),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 16),

        // Physical Attributes Section
        ExpandableSection(
          title: 'تفضيلات المظهر والطول والوزن',
          children: [
            DropdownField(
              label: 'نوع الزواج',
              hint: 'الكل',
              // items: ['تقليدي', 'مسيار', 'متعة'],
              items: ['اولي','ثانية','ارملة','مطلقة'],
              onChanged: (value) {},
            ),
            SizedBox(height: 12),
            DropdownField(
              label: 'الحالة الإجتماعية',
              hint: 'الكل',
              items: ['أعزب', 'مطلق', 'أرمل'],
              onChanged: (value) {},
            ),
            SizedBox(height: 12),
            RangeTextField(
                label: 'العمر',
                fromHint: 'من',
                toHint: 'الي',
                onRangeChanged: (from, to) {
                  if (from != null || to != null) {
                    context
                        .read<SearchCubit>()
                        .updateAgeRange(from ?? 0, to ?? 0);
                  }
                }),
            SizedBox(height: 12),
            RangeTextField(
              label: 'الطول (سم)',
              fromHint: 'من',
              toHint: 'إلى',
              maxLength: 3, // Height: max 3 digits (250 cm)
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
              label: 'الوزن (كم)',
              fromHint: 'من',
              toHint: 'إلى',
              maxLength: 3, // Weight: max 3 digits (200 kg)
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
              label: 'لون البشرة',
              hint: 'الكل',
              items: ['فاتح', 'متوسط', 'داكن'],
              onChanged: (value) {},
            ),
            SizedBox(height: 12),
            DropdownField(
              label: 'المؤهل التعليمي',
              hint: 'الكل',
              items: ['ثانوي', 'جامعي', 'دراسات عليا'],
              onChanged: (value) =>
                  context.read<SearchCubit>().updateQualification(value!),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Sort Section
        ExpandableSection(
          title: 'ترتيب النتائج',
          children: [
            DropdownField(
              label: 'الأكثر دخولاً أولاً',
              hint: '',
              items: ['الأكثر دخولاً أولاً', 'الأحدث أولاً', 'الأقدم أولاً'],
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
                    content:
                        Text('تم العثور على ${state.results.length} نتيجة')),
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
    );
  }
}