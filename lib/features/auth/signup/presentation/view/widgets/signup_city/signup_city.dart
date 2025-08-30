import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/theme/spacing.dart';
import '../custom_next_and_previous_button.dart';
import '../../../manager/signup_cubit.dart';
import '../../../../data/models/cities_models.dart';
import '../custom_searchable_list.dart';

class SignupCity extends StatefulWidget {
  const SignupCity({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupCity> createState() => _SignupCityState();
}

class _SignupCityState extends State<SignupCity> {
  CityResponseModels? _selectedCity;

  void _onCitySelected(ListItemModel city) {
    final cityModel = city as CityResponseModels;
    setState(() {
      _selectedCity = cityModel;
      // Save the city ID to the existing cityIdController
      context.read<SignupCubit>().cityIdController.text =
          cityModel.id?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the selected country ID from the signup chat_settings_cubit
    final countryId = context.read<SignupCubit>().countryIdController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Check if country is selected
        if (countryId.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                'يرجى اختيار الدولة أولاً',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          )
        else
          // Custom Searchable List for cities
          Expanded(
            child: CustomSearchableList(
              listType: ListType.city,
              selectedItem: _selectedCity,
              onItemSelected: _onCitySelected,
              countryId: countryId, // Pass the country ID
            ),
          ),
        verticalSpace(50),
        CustomNextAndPreviousButton(
          onNextPressed: widget.onNextPressed,
          onPreviousPressed: widget.onPreviousPressed,
          isNextEnabled: _selectedCity != null,
        ),
      ],
    );
  }
}
