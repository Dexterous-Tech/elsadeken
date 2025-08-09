import 'package:elsadeken/features/members/Health_statuses/presentation/view/widgets/filter_buttom_sheet.dart';
import 'package:elsadeken/features/members/Health_statuses/presentation/view/widgets/health_statuses_card.dart';
import 'package:flutter/material.dart';

import '../../../new_members/presentation/view/widgets/gender_filter.dart';

class HealthStatusesView extends StatefulWidget {
  const HealthStatusesView({Key? key}) : super(key: key);

  @override
  State<HealthStatusesView> createState() => _HealthStatusesViewState();
}

class _HealthStatusesViewState extends State<HealthStatusesView> {
  String _activeFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final List<HealthStatusData> healthStatuses = [
      HealthStatusData(
        name: "Ammar muahmmed",
        age: 56,
        location: "السعودية، الرياض",
        profileImageUrl:
            "https://placeholder.svg?height=60&width=60&query=profile+photo+man",
      ),
      HealthStatusData(
        name: "Ammar muahmmed",
        age: 56,
        location: "السعودية، الرياض",
        profileImageUrl:
            "https://placeholder.svg?height=60&width=60&query=profile+photo+man",
      ),
      HealthStatusData(
        name: "Ammar muahmmed",
        age: 56,
        location: "السعودية، الرياض",
        profileImageUrl:
            "https://placeholder.svg?height=60&width=60&query=profile+photo+man",
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'الحالات الصحية',
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
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الحالات',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FilterHealthStatues(),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'فلترة',
                            style: TextStyle(
                                color: Color(0xFFD4AF37), fontSize: 18),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
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
                      onTap: () => setState(() => _activeFilter = 'الكل'),
                    ),
                    const SizedBox(width: 2),
                    GenderFilter(
                      text: 'الذكور',
                      isActive: _activeFilter == 'الذكور',
                      onTap: () => setState(() => _activeFilter = 'الذكور'),
                    ),
                    const SizedBox(width: 2),
                    GenderFilter(
                      text: 'الإناث',
                      isActive: _activeFilter == 'الإناث',
                      onTap: () => setState(() => _activeFilter = 'الإناث'),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.white,
                child: const Text(
                  'عدد الحالات : 66',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: healthStatuses.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HealthStatusCard(
                        healthStatusData: healthStatuses[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthStatusData {
  final String name;
  final int age;
  final String location;
  final String profileImageUrl;

  HealthStatusData(
      {required this.name,
      required this.age,
      required this.location,
      required this.profileImageUrl});
}
