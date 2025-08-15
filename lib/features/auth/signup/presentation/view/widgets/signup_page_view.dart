import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/widgets/custom_page_view.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/nationalities_countries_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_additions/signup_additions.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_body/signup_body_shape.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_city/signup_city.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_country/signup_country.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_descriptions/signup_descriptions.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_education/signup_education.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_general_info/signup_general_info.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_job/signup_job.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_national/signup_national.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_passwords/signup_passwords.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_personal_info/signup_personal_info.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_religion/signup_religion.dart';
import 'package:elsadeken/features/auth/signup/presentation/view/widgets/signup_social_status/signup_social_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPageView extends StatefulWidget {
  const SignupPageView({
    super.key,
    required this.currentStep,
    required this.onStepChanged,
    required this.gender,
  });

  final int currentStep;
  final ValueChanged<int> onStepChanged;
  final String gender;

  @override
  State<SignupPageView> createState() => _SignupPageViewState();
}

class _SignupPageViewState extends State<SignupPageView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List pages = [
    'personal info',
    'passwords',
    'national',
    'country',
    'city',
    'social status',
    'general info',
    'body',
    'religion',
    'additions',
    'education',
    'job',
    'descriptions',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: pages.length,
      vsync: this,
      initialIndex: widget.currentStep,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(covariant SignupPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep &&
        _tabController.index != widget.currentStep) {
      _tabController.animateTo(widget.currentStep);
    }
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onStepChanged(_tabController.index);
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      tabController: _tabController,
      taps: pages,
      pages: buildPages,
    );
  }

  Widget buildPages(index) {
    switch (index) {
      case 0:
        return SignupPersonalInfo(
          gender: widget.gender,
          key: const ValueKey(0),
          onNextPressed: () => widget.onStepChanged(1),
        );

      case 1:
        return SignupPasswords(
          key: const ValueKey(1),
          onNextPressed: () => widget.onStepChanged(2),
          onPreviousPressed: () => widget.onStepChanged(0),
        );
      case 2:
        return BlocProvider.value(
          value: sl<NationalitiesCountriesCubit>(),
          child: SignupNational(
            key: const ValueKey(2),
            onNextPressed: () => widget.onStepChanged(3),
            onPreviousPressed: () => widget.onStepChanged(1),
          ),
        );
      case 3:
        return BlocProvider.value(
          value: sl<NationalitiesCountriesCubit>(),
          child: SignupCountry(
            key: const ValueKey(3),
            onNextPressed: () => widget.onStepChanged(4),
            onPreviousPressed: () => widget.onStepChanged(2),
          ),
        );
      case 4:
        return BlocProvider.value(
          value: sl<NationalitiesCountriesCubit>(),
          child: SignupCity(
            key: const ValueKey(4),
            onNextPressed: () => widget.onStepChanged(5),
            onPreviousPressed: () => widget.onStepChanged(3),
          ),
        );
      case 5:
        return SignupSocialStatus(
          key: const ValueKey(5),
          gender: widget.gender,
          onNextPressed: () => widget.onStepChanged(6),
          onPreviousPressed: () => widget.onStepChanged(4),
        );
      case 6:
        return SignupGeneralInfo(
          key: const ValueKey(6),
          onNextPressed: () => widget.onStepChanged(7),
          onPreviousPressed: () => widget.onStepChanged(5),
        );
      case 7:
        return SignupBodyShape(
          key: const ValueKey(7),
          onNextPressed: () => widget.onStepChanged(8),
          onPreviousPressed: () => widget.onStepChanged(6),
        );
      case 8:
        return SignupReligion(
          key: const ValueKey(8),
          onNextPressed: () => widget.onStepChanged(9),
          onPreviousPressed: () => widget.onStepChanged(7),
        );
      case 9:
        return SignupAdditions(
          key: const ValueKey(9),
          onNextPressed: () => widget.onStepChanged(10),
          onPreviousPressed: () => widget.onStepChanged(8),
        );
      case 10:
        return SignupEducation(
          key: const ValueKey(10),
          onNextPressed: () => widget.onStepChanged(11),
          onPreviousPressed: () => widget.onStepChanged(9),
        );
      case 11:
        return SignupJob(
          key: const ValueKey(11),
          onNextPressed: () => widget.onStepChanged(12),
          onPreviousPressed: () => widget.onStepChanged(10),
        );
      case 12:
        return SignupDescriptions(
          key: const ValueKey(12),
          onPreviousPressed: () => widget.onStepChanged(11),
          onNextPressed: () {
            context.pushNamed(AppRoutes.homeScreen);
          },
        );
      default:
        return SignupPersonalInfo(
          gender: widget.gender,
          key: const ValueKey(0),
          onNextPressed: () => widget.onStepChanged(1),
        );
    }
  }
}
