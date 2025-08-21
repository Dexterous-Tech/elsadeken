import 'package:flutter/material.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/di/injection_container.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<_Country> _countries = const [];
  int _selectedCountryIndex = 0;
  bool _isLoadingCountries = true;
  

  
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

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final api = sl<ApiServices>();
      final res = await api.get(endpoint: ApiConstants.listCountries, requiresAuth: false);
      final raw = res.data;
      List list;
      if (raw is List) {
        list = raw;
      } else if (raw is Map && raw['data'] is List) {
        list = raw['data'] as List;
      } else if (raw is Map && raw['data'] is Map && raw['data']['countries'] is List) {
        list = raw['data']['countries'] as List;
      } else {
        list = const [];
      }
      final parsed = list
          .map((e) {
            final map = e as Map<String, dynamic>;
            final id = (map['id'] ?? map['country_id']) as int?;
            final name = (map['name_ar'] ?? map['name'] ?? map['title'] ?? map['country_name_ar'] ?? '').toString();
            if (id == null || name.isEmpty) return null;
            return _Country(id: id, name: name);
          })
          .whereType<_Country>()
          .toList();
      setState(() {
        _countries = [const _Country(id: 0, name: 'الكل'), ...parsed];
        _isLoadingCountries = false;
      });
    } catch (_) {
      // fallback to just All
      setState(() {
        _countries = const [
          _Country(id: 0, name: 'الكل'),
        ];
        _isLoadingCountries = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: media.size.height * 0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      
                      if (_isLoadingCountries)
                        const Center(child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: CircularProgressIndicator(),
                        ))
                      else
                        _Section(
                          title: 'فلتره بواسطه الدوله',
                          options: _countries.map((e) => e.name).toList(),
                          selectedIndex: _selectedCountryIndex,
                          onSelect: (i) => setState(() => _selectedCountryIndex = i),
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
                          final selected = (_selectedCountryIndex >= 0 && _selectedCountryIndex < _countries.length)
                              ? _countries[_selectedCountryIndex]
                              : const _Country(id: 0, name: 'الكل');
                          Navigator.of(context).maybePop({
                            'id': selected.id == 0 ? null : selected.id,
                            'name': selected.name,
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
    );
  }
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
      child: value
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
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
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                'فلتره',
                style: TextStyle(
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

class _Country {
  final int id;
  final String name;
  const _Country({required this.id, required this.name});
}