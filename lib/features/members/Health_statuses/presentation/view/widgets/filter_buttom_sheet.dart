import 'package:elsadeken/core/helper/localization_helper.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import '../../../../../../core/di/injection_container.dart';
import '../../../../../../core/theme/app_color.dart';

class FilterHealthStatues extends StatefulWidget {
  const FilterHealthStatues({
    super.key,
  });

  @override
  State<FilterHealthStatues> createState() => _FilterHealthStatuesState();
}

class _FilterHealthStatuesState extends State<FilterHealthStatues> {
  late final String all;
  late List<_HealthOption> _healthOptions;
  late List<_Country> _countries;

  int _selectedHealthIndex = 0;
  int _selectedCountryIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    all = LocalizationHelper.getLocalizedText('الكل', 'all');
    _healthOptions = [_HealthOption(id: 0, name: all)];
    _countries = [_Country(id: 0, name: all)];
  }

  static const Color kMuted = Color(0xFF9E9E9E);
  static const Color kClearRed = Color(0xFFF04438);

  final LinearGradient _applyGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF8B64C),
      Color(0xFFF0852E),
    ],
  );

  List<_HealthOption> _parseHealthConditions(
      List<GeneralInfoResponseModels> healthList) {
    final parsed = healthList
        .map((e) {
          final id = e.id;
          final name = e.name ?? '';
          if (id == null || name.isEmpty) return null;
          return _HealthOption(id: id, name: name);
        })
        .whereType<_HealthOption>()
        .toList();

    return [_HealthOption(id: 0, name: all), ...parsed];
  }

  List<_Country> _parseCountries(
      List<NationalCountryResponseModel> countriesList) {
    final parsed = countriesList
        .map((e) {
          final id = e.id;
          final name = e.name ?? '';
          if (id == null || name.isEmpty) return null;
          return _Country(id: id, name: name);
        })
        .whereType<_Country>()
        .toList();

    return [_Country(id: 0, name: all), ...parsed];
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return BlocProvider(
      create: (context) => sl<SignUpListsCubit>(),
      child: Directionality(
        textDirection: LocalizationService.instance.textDirection,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: media.size.height * 0.5,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.cosmicLatte,
                AppColors.antiqueWhite,
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              textDirection: LocalizationService.instance.textDirection,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: LocalizationService.instance.textDirection,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close, color: kMuted),
                        tooltip: AppLocalizations.of(context)!.close,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      textDirection: LocalizationService.instance.textDirection,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<SignUpListsCubit, SignUpListsState>(
                          builder: (context, state) {
                            // If this is the initial state, trigger data loading
                            if (state is SignUpListsStateInitial) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                final cubit = context.read<SignUpListsCubit>();
                                cubit.getHealthConditions();
                                cubit.getCountries();
                              });
                            }

                            // Show loading state until both data are loaded
                            if (state is SignUpListsStateInitial ||
                                state is HealthConditionsLoading ||
                                state is CountriesLoading) {
                              return Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Column(
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.of(context)!.loading,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // Handle both states independently
                            if (state is HealthConditionsSuccess) {
                              _healthOptions =
                                  _parseHealthConditions(state.generalList);
                              print(
                                  'Health conditions loaded: ${_healthOptions.map((e) => '${e.id}:${e.name}').toList()}');
                            }

                            if (state is CountriesSuccess) {
                              _countries = _parseCountries(state.countriesList);
                              print(
                                  'Countries loaded: ${_countries.map((e) => '${e.id}:${e.name}').toList()}');
                            }

                            // Only show content when both data are loaded
                            if (_healthOptions.length <= 1 ||
                                _countries.length <= 1) {
                              return Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Column(
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.of(context)!.loading,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Column(
                              textDirection:
                                  LocalizationService.instance.textDirection,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Section(
                                  title: AppLocalizations.of(context)!
                                      .filterByHealthStatus,
                                  options: _healthOptions
                                      .map((e) => e.name)
                                      .toList(),
                                  selectedIndex: _selectedHealthIndex,
                                  onSelect: (i) =>
                                      setState(() => _selectedHealthIndex = i),
                                ),
                                const SizedBox(height: 20),
                                _Section(
                                  title: AppLocalizations.of(context)!
                                      .filterByCountry,
                                  options:
                                      _countries.map((e) => e.name).toList(),
                                  selectedIndex: _selectedCountryIndex,
                                  onSelect: (i) =>
                                      setState(() => _selectedCountryIndex = i),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.all(16),
                  child: Row(
                    textDirection: LocalizationService.instance.textDirection,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _GradientButton(
                          label: AppLocalizations.of(context)!.filter,
                          gradient: _applyGradient,
                          isLoading: _isLoading,
                          onTap: _isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  // Simulate loading delay for better UX
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));

                                  if (mounted) {
                                    final selectedHealth =
                                        (_selectedHealthIndex >= 0 &&
                                                _selectedHealthIndex <
                                                    _healthOptions.length)
                                            ? _healthOptions[
                                                _selectedHealthIndex]
                                            : const _HealthOption(
                                                id: 0, name: 'all');

                                    final selectedCountry =
                                        (_selectedCountryIndex >= 0 &&
                                                _selectedCountryIndex <
                                                    _countries.length)
                                            ? _countries[_selectedCountryIndex]
                                            : const _Country(
                                                id: 0, name: 'all');

                                    // Return the filter data to the parent screen
                                    if (context.mounted) {
                                      Navigator.of(context).maybePop({
                                        'health': {
                                          'id': selectedHealth.id == 0
                                              ? null
                                              : selectedHealth.id,
                                          'name': selectedHealth.name,
                                        },
                                        'country': {
                                          'id': selectedCountry.id == 0
                                              ? null
                                              : selectedCountry.id,
                                          'name': selectedCountry.name,
                                        },
                                      });
                                    }
                                  }
                                },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _OutlinedActionButton(
                          label: AppLocalizations.of(context)!.clear,
                          color: kClearRed,
                          onTap: () {
                            setState(() {
                              _selectedHealthIndex = 0;
                              _selectedCountryIndex = 0;
                            });
                          },
                        ),
                      ),
                    ],
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

class _HealthOption {
  final int id;
  final String name;
  const _HealthOption({required this.id, required this.name});
}

class _Country {
  final int id;
  final String name;
  const _Country({required this.id, required this.name});
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  final String title;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const Color kTitle = Color(0xFF111111);
  static const Color kText = Color(0xFF2C2C2C);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kTitle,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(options.length, (i) {
          final selected = i == selectedIndex;
          return Column(
            textDirection: LocalizationService.instance.textDirection,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => onSelect(i),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 8),
                  child: Row(
                    textDirection: LocalizationService.instance.textDirection,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        options[i],
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 16,
                          color: kText,
                        ),
                      ),
                      Spacer(),
                      _SquareCheck(value: selected),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _SquareCheck extends StatelessWidget {
  const _SquareCheck({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: value ? AppColors.congoPink : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: value ? AppColors.congoPink : const Color(0xFFCDCDCD),
          width: 1.4,
        ),
      ),
      child:
          value ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.gradient,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final Gradient gradient;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onTap != null ? () => onTap!() : null,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: color, width: 1.4),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
