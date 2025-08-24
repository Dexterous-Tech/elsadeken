import 'package:elsadeken/features/members/Health_statuses/presentation/view/widgets/filter_buttom_sheet.dart';
import 'package:elsadeken/features/members/Health_statuses/presentation/view/widgets/health_statuses_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/members/data/models/members.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';

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
    final cubit = MembersListCubit<Member>(
      () => sl<MembersRepository>().getHealthConditionMembers(),
    )..fetch();

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
              child: BlocProvider<MembersListCubit<Member>>(
                create: (_) => cubit,
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
                            size: 16,
                            color: Color(0xFFD4AF37)
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
              BlocBuilder<MembersListCubit<Member>, MembersListState<Member>>(
                builder: (context, state) {
                  if (state is MembersListLoading<Member>) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is MembersListError<Member>) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                  if (state is MembersListEmpty<Member>) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          'لا توجد نتائج حالياً',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (state is MembersListLoaded<Member>) {
                    final items = state.items;
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            color: Colors.white,
                            child: Text(
                              'عدد الحالات : ${items.length}',
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final m = items[index];
                                final data = HealthStatusData(
                                  id: m.id,
                                  name: m.name,
                                  age: m.attribute?.age ?? 0,
                                  location:
                                      '${m.attribute?.country ?? ''}، ${m.attribute?.city ?? ''}',
                                  profileImageUrl: m.image,
                                );
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: HealthStatusCard(
                                    healthStatusData: data,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthStatusData {
  final int? id;
  final String name;
  final int age;
  final String location;
  final String profileImageUrl;

  HealthStatusData({
    this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.profileImageUrl,
  });
}
