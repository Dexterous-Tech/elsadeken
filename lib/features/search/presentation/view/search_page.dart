// File: lib/presentation/pages/search_page.dart
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/helper/app_constants.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SearchCubit>()),
        BlocProvider(create: (context) => sl<SignUpListsCubit>()),
      ],
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Close keyboard
          },
          child: CustomProfileBody(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            contentBody: Column(
              children: [
                ProfileHeader(title: AppLocalizations.of(context)!.search),
                verticalSpace(42),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: SearchForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
