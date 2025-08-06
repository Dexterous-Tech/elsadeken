// File: lib/presentation/pages/search_page.dart
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/helper/app_constants.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/custom_app_bar.dart';
import 'package:elsadeken/features/search/presentation/cubit/search_cubit.dart';
import 'package:elsadeken/features/search/presentation/view/widgets/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(title: 'بحث'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppConstants.defaultPadding),
                  child: SearchForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}