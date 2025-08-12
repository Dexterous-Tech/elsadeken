import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/theme/spacing.dart';
import '../custom_next_and_previous_button.dart';
import '../../../manager/signup_cubit.dart';
import '../../../../data/models/national_country_models.dart';
import '../../../../../widgets/custom_searchable_list.dart';

class SignupCountry extends StatefulWidget {
  const SignupCountry({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupCountry> createState() => _SignupCountryState();
}

class _SignupCountryState extends State<SignupCountry> {
  NationalCountryResponseModel? _selectedCountry;

  void _onCountrySelected(ListItemModel country) {
    final countryModel = country as NationalCountryResponseModel;
    setState(() {
      _selectedCountry = countryModel;
      // Save the country ID to the existing countryIdController
      context.read<SignupCubit>().countryIdController.text =
          countryModel.id?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Custom Searchable List
                  Expanded(
                    child: CustomSearchableList(
                      listType: ListType.country,
                      selectedItem: _selectedCountry,
                      onItemSelected: _onCountrySelected,
                    ),
                  ),
                  verticalSpace(50),
                  CustomNextAndPreviousButton(
                    onNextPressed: widget.onNextPressed,
                    onPreviousPressed: widget.onPreviousPressed,
                    isNextEnabled: _selectedCountry != null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
