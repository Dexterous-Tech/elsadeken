import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/members/data/models/members.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/new_members/presentation/view/widgets/new_members_card.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/members/online_members/presentation/view/widgets/filter_buttom_sheet.dart';

import '../../../Health_statuses/presentation/view/widgets/gender_filter.dart';

class NewMembersView extends StatefulWidget {
  const NewMembersView({Key? key, this.countryId}) : super(key: key);

  final int? countryId;

  @override
  State<NewMembersView> createState() => _NewMembersViewState();
}

class _NewMembersViewState extends State<NewMembersView> {
  String _activeFilter = 'الكل';
  int? _selectedCountryId;
  List<Member> _allMembers = [];

  List<Member> _getFilteredMembers(List<Member> allMembers) {
    switch (_activeFilter) {
      case 'الذكور':
        return allMembers.where((member) => member.gender == 'ذكر').toList();
      case 'الإناث':
        return allMembers.where((member) => member.gender == 'انثى').toList();
      default:
        return allMembers;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = MembersListCubit<Member>(
      () => sl<MembersRepository>().getNewMembers(countryId: widget.countryId),
    )..fetch();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'أعضاء جدد',
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
          child: BlocProvider<MembersListCubit<Member>>(
            create: (_) => cubit,
            child: Column(
              children: [
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
                      onTap: () {
                        setState(() => _activeFilter = 'الكل');
                      },
                    ),
                    const SizedBox(width: 2),
                    GenderFilter(
                      text: 'الذكور',
                      isActive: _activeFilter == 'الذكور',
                      onTap: () {
                        setState(() => _activeFilter = 'الذكور');
                      },
                    ),
                    const SizedBox(width: 2),
                    GenderFilter(
                      text: 'الإناث',
                      isActive: _activeFilter == 'الإناث',
                      onTap: () {
                        setState(() => _activeFilter = 'الإناث');
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      final result = await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const FilterBottomSheet(),
                      );
                      if (result != null) {
                        setState(() {
                          _selectedCountryId = result['id'] as int?;
                        });
                        // Recreate cubit with country filter
                        final newCubit = MembersListCubit<Member>(
                          () => sl<MembersRepository>().getNewMembers(
                              countryId: _selectedCountryId),
                        );
                        // Push a new provider scope with updated loader
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider<MembersListCubit<Member>>(
                              create: (_) => newCubit..fetch(),
                              child: NewMembersView(
                                countryId: _selectedCountryId,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'فلترة',
                          style: TextStyle(color: Color(0xFFD4AF37), fontSize: 16),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios, size: 16,color: Color(0xFFD4AF37)),
                      ],
                    ),
                  ),
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
                    _allMembers = state.items;
                    final items = _getFilteredMembers(_allMembers);
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            color: Colors.white,
                            child: Text(
                              'عدد النتائج: ${items.length}',
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
                                final data = NewMemberData(
                                  name: m.name,
                                  age: m.attribute?.age ?? 0,
                                  location:
                                      '${m.attribute?.country ?? ''}، ${m.attribute?.city ?? ''}',
                                  profileImageUrl: m.image,
                                  isOnline: false,
                                );
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: NewMemberCard(
                                    memberData: data,
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
      ),
    );
  }
}

class NewMemberData {
  final String name;
  final int age;
  final String location;
  final String profileImageUrl;
  final bool isOnline;

  NewMemberData({
    required this.name,
    required this.age,
    required this.location,
    required this.profileImageUrl,
    required this.isOnline,
  });
}
