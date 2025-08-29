import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/members/online_members/presentation/view/widgets/filter_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/members/data/models/members.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/routes/app_routes.dart';

import '../../../../results/presentation/view/results_screen.dart';
import '../../../../results/presentation/view/widgets/result_card.dart';
import '../../../Health_statuses/presentation/view/widgets/gender_filter.dart';

class OnlineMembersView extends StatefulWidget {
  const OnlineMembersView({Key? key}) : super(key: key);

  @override
  State<OnlineMembersView> createState() => _OnlineMembersViewState();
}

class _OnlineMembersViewState extends State<OnlineMembersView> {
  String _activeFilter = 'الكل';
  int? _selectedCountryId;
  String _selectedCountryName = '';
  List<Member> _allMembers = [];
  List<Member> _filteredMembers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repository = sl<MembersRepository>();
      final response = await repository.getOnlineMembers();

      setState(() {
        _allMembers = response.data;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
        );
      }
    }
  }

  void _applyFilters() {
    List<Member> filtered = List.from(_allMembers);

    // Apply gender filter
    if (_activeFilter == 'الذكور') {
      filtered = filtered.where((member) {
        final gender = member.gender.toLowerCase().trim();
        final isMale = gender == 'male' ||
            gender == 'ذكر' ||
            gender == 'm' ||
            gender == 'ذكر' ||
            gender == 'male' ||
            gender == 'm';
        print('Member ${member.name}: gender="$gender", isMale=$isMale');
        return isMale;
      }).toList();
    } else if (_activeFilter == 'الإناث') {
      filtered = filtered.where((member) {
        final gender = member.gender.toLowerCase().trim();
        final isFemale = gender == 'female' ||
            gender == 'أنثى' ||
            gender == 'f' ||
            gender == 'أنثى' ||
            gender == 'female' ||
            gender == 'f';
        print('Member ${member.name}: gender="$gender", isFemale=$isFemale');
        return isFemale;
      }).toList();
    }

    // Apply country filter
    if (_selectedCountryId != null && _selectedCountryId != 0) {
      // Note: This assumes the API supports country filtering
      // If not, you'll need to implement client-side filtering based on member attributes
      // For now, we'll filter by the country name in attributes
      filtered = filtered.where((member) {
        final country = member.attribute?.country ?? '';
        final isValidCountry =
            country.isNotEmpty && country != 'لا يوجد' && country != 'null';
        print(
            'Member ${member.name}: country="$country", isValidCountry=$isValidCountry');
        return isValidCountry;
      }).toList();
    }

    print('Filtered members: ${filtered.length} out of ${_allMembers.length}');
    setState(() {
      _filteredMembers = filtered;
    });
  }

  void _onGenderFilterChanged(String filter) {
    setState(() {
      _activeFilter = filter;
    });
    _applyFilters();
  }

  void _onCountryFilterChanged(Map<String, dynamic> filterData) {
    setState(() {
      _selectedCountryId = filterData['id'];
      _selectedCountryName = filterData['name'] ?? '';
    });
    _applyFilters();
  }

  String _getLocationText(Member member) {
    final country = member.attribute?.country;
    final city = member.attribute?.city;

    // Debug logging
    print('Member ${member.name}: country="$country", city="$city"');

    // Handle null or empty values
    if (country == null ||
        country.isEmpty ||
        country == 'لا يوجد' ||
        country == 'null') {
      if (city == null || city.isEmpty || city == 'لا يوجد' || city == 'null') {
        return 'غير محدد';
      }
      return city;
    }

    if (city == null || city.isEmpty || city == 'لا يوجد' || city == 'null') {
      return country;
    }

    // Both country and city are valid
    return '$country، $city';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            ' المتواجدون الان',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: -20,
              child: Image.asset(
                AppImages.starProfile,
                width: 488.w,
                height: 325.h,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المتواجدون',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet<
                                Map<String, dynamic>>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const FilterBottomSheet(),
                            );
                            if (result != null) {
                              _onCountryFilterChanged(result);
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                'فلترة',
                                style: TextStyle(
                                    color: Color(0xFFD4AF37), fontSize: 18),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Color(0xFFD4AF37)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F1E8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GenderFilter(
                          text: 'الكل',
                          isActive: _activeFilter == 'الكل',
                          onTap: () => _onGenderFilterChanged('الكل'),
                        ),
                        const SizedBox(width: 2),
                        GenderFilter(
                          text: 'الذكور',
                          isActive: _activeFilter == 'الذكور',
                          onTap: () => _onGenderFilterChanged('الذكور'),
                        ),
                        const SizedBox(width: 2),
                        GenderFilter(
                          text: 'الإناث',
                          isActive: _activeFilter == 'الإناث',
                          onTap: () => _onGenderFilterChanged('الإناث'),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedCountryName.isNotEmpty &&
                      _selectedCountryName != 'الكل')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Color(0xFFD4AF37), size: 16),
                          SizedBox(width: 8),
                          Text(
                            'تم الفلترة حسب: $_selectedCountryName',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedCountryId = null;
                                _selectedCountryName = '';
                              });
                              _applyFilters();
                            },
                            child: Text(
                              'إلغاء',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 16),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_filteredMembers.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              _allMembers.isEmpty
                                  ? 'لا توجد نتائج حالياً'
                                  : 'لا توجد نتائج تطابق الفلتر المحدد',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_allMembers.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _activeFilter = 'الكل';
                                    _selectedCountryId = null;
                                    _selectedCountryName = '';
                                  });
                                  _applyFilters();
                                },
                                child: Text('إلغاء الفلترة'),
                              ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            color: Colors.white,
                            child: Text(
                              ' المتواجدون الآن : ${_filteredMembers.length}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _filteredMembers.length,
                              itemBuilder: (context, index) {
                                final m = _filteredMembers[index];
                                final person = PersonData(
                                  id: m.id,
                                  name: m.name,
                                  age: m.attribute?.age ?? 0,
                                  country: m.attribute?.country ?? 'لا يوجد',
                                  city: m.attribute?.city ?? 'لا يوجد',
                                  location: _getLocationText(m),
                                  profileImageUrl: m.image,
                                  isOnline: true,
                                );
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: PersonCardWidget(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          AppRoutes.profileDetailsScreen,
                                          arguments: m.id);
                                    },
                                    personData: person,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
