// File: lib/presentation/pages/search_page.dart
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/helper/app_constants.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchCubit>(),
      child: Scaffold(
        body: CustomProfileBody(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          contentBody: Column(
          children: [
            ProfileHeader(title: 'بحث'),
            verticalSpace(42),
            Expanded(
              child: SingleChildScrollView(
                child: SearchForm(),
              ),
            ),
          ],
        ),),
      ),
    );
  }
}
