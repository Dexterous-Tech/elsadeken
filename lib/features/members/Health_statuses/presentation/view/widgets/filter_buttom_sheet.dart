import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import '../../../../../../core/di/injection_container.dart';

class FilterHealthStatues extends StatefulWidget {
  const FilterHealthStatues({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterHealthStatues> createState() => _FilterHealthStatuesState();
}

class _FilterHealthStatuesState extends State<FilterHealthStatues> {
  List<_HealthOption> _healthOptions = const [
    const _HealthOption(id: 0, name: 'الكل')
  ];
  List<_Country> _countries = const [const _Country(id: 0, name: 'الكل')];

  int _selectedHealthIndex = 0;
  int _selectedCountryIndex = 0;

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

    return [const _HealthOption(id: 0, name: 'الكل'), ...parsed];
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

    return [const _Country(id: 0, name: 'الكل'), ...parsed];
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return BlocProvider(
      create: (context) => sl<SignUpListsCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: media.size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close, color: kMuted),
                        tooltip: 'إغلاق',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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

                            return Column(
                              children: [
                                _Section(
                                  title: 'فلتره بواسطه الحاله الصحيه',
                                  options: _healthOptions
                                      .map((e) => e.name)
                                      .toList(),
                                  selectedIndex: _selectedHealthIndex,
                                  onSelect: (i) =>
                                      setState(() => _selectedHealthIndex = i),
                                ),
                                const SizedBox(height: 20),
                                _Section(
                                  title: 'فلتره بواسطه الدوله',
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _GradientButton(
                          label: 'فلتره',
                          gradient: _applyGradient,
                          onTap: () {
                            final selectedHealth = (_selectedHealthIndex >= 0 &&
                                    _selectedHealthIndex <
                                        _healthOptions.length)
                                ? _healthOptions[_selectedHealthIndex]
                                : const _HealthOption(id: 0, name: 'الكل');

                            final selectedCountry = (_selectedCountryIndex >=
                                        0 &&
                                    _selectedCountryIndex < _countries.length)
                                ? _countries[_selectedCountryIndex]
                                : const _Country(id: 0, name: 'الكل');

                            // Return the filter data to the parent screen
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
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _OutlinedActionButton(
                          label: 'مسح',
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
            children: [
              InkWell(
                onTap: () => onSelect(i),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          options[i],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 16,
                            color: kText,
                          ),
                        ),
                      ),
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
        color: value ? const Color(0xFF22C55E) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: value ? const Color(0xFF22C55E) : const Color(0xFFCDCDCD),
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
  });

  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
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
            padding: const EdgeInsets.symmetric(vertical: 14),
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
