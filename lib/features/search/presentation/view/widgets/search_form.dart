// File: lib/presentation/widgets/search_form.dart
import 'package:elsadeken/features/results/presentation/view/results_screen.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/range_text_field.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/search_cubit.dart';
import 'dropdown_field.dart';
import 'expandable_section.dart';
import 'search_text_field.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

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
            DropdownField(
              label: 'الجنسية',
              hint: 'مختار',
              items: ['مصري', 'سعودي', 'إماراتي', 'كويتي'],
              onChanged: (value) =>
                  context.read<SearchCubit>().updateNationality(value!),
            ),
            SizedBox(height: 12),
            DropdownField(
              label: 'الدولة',
              hint: 'مختار',
              items: ['مصر', 'السعودية', 'الإمارات', 'الكويت'],
              onChanged: (value) =>
                  context.read<SearchCubit>().updateCountry(value!),
            ),
            SizedBox(height: 12),
            DropdownField(
              label: 'المدينة',
              hint: 'اختر مدينتك',
              items: ['القاهرة', 'الإسكندرية', 'الجيزة', 'الرياض'],
              onChanged: (value) =>
                  context.read<SearchCubit>().updateCity(value!),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Physical Attributes Section
        ExpandableSection(
          title: 'تفضيلات المضهر والطول والوزن',
          children: [
            DropdownField(
              label: 'نوع الزواج',
              hint: 'الكل',
              items: ['تقليدي', 'مسيار', 'متعة'],
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
              onChanged: (value) {},
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchResultsView()),
                );
              }
            );
          },
        ),
      ],
    );
  }
}
