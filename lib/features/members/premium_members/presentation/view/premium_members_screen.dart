import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';

import '../../../Health_statuses/presentation/view/widgets/gender_filter.dart';
import '../../../online_members/presentation/view/widgets/filter_buttom_sheet.dart';

class PremiumMembersView extends StatefulWidget {
  const PremiumMembersView({Key? key}) : super(key: key);

  @override
  State<PremiumMembersView> createState() => _PremiumMembersViewState();
}

class _PremiumMembersViewState extends State<PremiumMembersView> {
  String _activeFilter = 'الكل';
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreUsers() {
    final cubit = context.read<MembersListCubit<UsersDataModel>>();
    final state = cubit.state;

    if (state is MembersListLoaded<UsersDataModel> &&
        state.hasNextPage &&
        !_isLoadingMore) {
      final nextPage = state.currentPage + 1;
      print(
          'Loading more premium members: current page ${state.currentPage}, next page $nextPage');
      setState(() {
        _isLoadingMore = true;
      });
      cubit.fetch(page: nextPage).then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
          print('Pagination loading completed');
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      print('Scroll threshold reached, triggering pagination');
      _loadMoreUsers();
    }
  }

  Future<void> _onRefresh() async {
    context.read<MembersListCubit<UsersDataModel>>().fetch(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = MembersListCubit<UsersDataModel>(
      ({int? page}) async {
        final response =
            await sl<MembersRepository>().getDistinguishedMembers();
        return response.data ?? [];
      },
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
            'أعضاء مميزين',
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
              child: BlocProvider<MembersListCubit<UsersDataModel>>(
                create: (_) => cubit,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الأعضاء المميزون',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const FilterBottomSheet(),
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
                            onTap: () => setState(() => _activeFilter = 'الكل'),
                          ),
                          const SizedBox(width: 6),
                          GenderFilter(
                            text: 'الذكور',
                            isActive: _activeFilter == 'الذكور',
                            onTap: () =>
                                setState(() => _activeFilter = 'الذكور'),
                          ),
                          const SizedBox(width: 6),
                          GenderFilter(
                            text: 'الإناث',
                            isActive: _activeFilter == 'الإناث',
                            onTap: () =>
                                setState(() => _activeFilter = 'الإناث'),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<MembersListCubit<UsersDataModel>,
                        MembersListState<UsersDataModel>>(
                      builder: (context, state) {
                        if (state is MembersListLoading<UsersDataModel>) {
                          return Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: AppColors.beer,
                            )),
                          );
                        }
                        if (state is MembersListError<UsersDataModel>) {
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
                        if (state is MembersListEmpty<UsersDataModel>) {
                          return const Expanded(
                            child: Center(
                              child: Text(
                                'لايوجد اعضاء مميزين',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        if (state is MembersListLoaded<UsersDataModel>) {
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
                                    'عدد الأعضاء المميزين: ${items.length}',
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
                                  child: RefreshIndicator(
                                    onRefresh: _onRefresh,
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      itemCount: items.length +
                                          (_isLoadingMore ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (index == items.length &&
                                            _isLoadingMore) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    'جاري تحميل المزيد...',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }

                                        final m = items[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: ContainerItem(
                                            favUser: m,
                                            isSpecial: true,
                                          ),
                                        );
                                      },
                                    ),
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
