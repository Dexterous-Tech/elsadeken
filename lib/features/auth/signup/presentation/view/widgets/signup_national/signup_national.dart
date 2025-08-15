import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/theme/spacing.dart';
import '../custom_next_and_previous_button.dart';
import '../../../manager/signup_cubit.dart';
import '../../../../data/models/national_country_models.dart';
import '../../../../../widgets/custom_searchable_list.dart';

class SignupNational extends StatefulWidget {
  const SignupNational({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  final void Function() onNextPressed;
  final void Function() onPreviousPressed;

  @override
  State<SignupNational> createState() => _SignupNationalState();
}

class _SignupNationalState extends State<SignupNational> {
  NationalCountryResponseModel? _selectedNationality;

  void _onNationalitySelected(ListItemModel nationality) {
    final nationalityModel = nationality as NationalCountryResponseModel;
    setState(() {
      _selectedNationality = nationalityModel;
      // Save the nationality ID to the existing nationalIdController
      context.read<SignupCubit>().nationalIdController.text =
          nationalityModel.id?.toString() ?? '';
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
                      listType: ListType.nationality,
                      selectedItem: _selectedNationality,
                      onItemSelected: _onNationalitySelected,
                    ),
                  ),
                  verticalSpace(50),
                  CustomNextAndPreviousButton(
                    onNextPressed: widget.onNextPressed,
                    onPreviousPressed: widget.onPreviousPressed,
                    isNextEnabled: _selectedNationality != null,
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
