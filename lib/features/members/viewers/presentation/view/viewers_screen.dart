import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:elsadeken/features/members/data/repositories/members_repository.dart';
import 'package:elsadeken/features/members/logic/cubit/members_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/core/helper/app_images.dart';

import '../../../../../core/theme/app_color.dart';

class ViewersView extends StatefulWidget {
  const ViewersView({Key? key}) : super(key: key);

  @override
  State<ViewersView> createState() => _ViewersViewState();
}

class _ViewersViewState extends State<ViewersView> {
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
          'Loading more viewers: current page ${state.currentPage}, next page $nextPage');
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

  String _calculateTimeSinceVisited(
      String? visitedAtDate, String? visitedAtTime) {
    if (visitedAtDate == null || visitedAtTime == null) {
      return 'غير محدد';
    }

    try {
      // Parse the date and time
      final dateTimeStr = '$visitedAtDate $visitedAtTime';
      final visitedDateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(visitedDateTime);

      if (difference.inMinutes < 1) {
        return 'الآن';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        if (minutes == 1) {
          return 'منذ دقيقة';
        } else if (minutes == 2) {
          return 'منذ دقيقتين';
        } else if (minutes < 11) {
          return 'منذ $minutes دقائق';
        } else {
          return 'منذ $minutes دقيقة';
        }
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        if (hours == 1) {
          return 'منذ ساعة';
        } else if (hours == 2) {
          return 'منذ ساعتين';
        } else if (hours < 11) {
          return 'منذ $hours ساعات';
        } else {
          return 'منذ $hours ساعة';
        }
      } else {
        final days = difference.inDays;
        if (days == 1) {
          return 'منذ يوم';
        } else if (days == 2) {
          return 'منذ يومين';
        } else if (days < 11) {
          return 'منذ $days أيام';
        } else {
          return 'منذ $days يوم';
        }
      }
    } catch (e) {
      return 'غير محدد';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = MembersListCubit<UsersDataModel>(
      ({int? page}) async {
        final response = await sl<MembersRepository>().getVisitors();
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
            ' من زار بياناتي ',
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
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 12),
                    //   color: Colors.white,
                    //   child: const Text(
                    //     'اليوم',
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 42),
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
                          log(
                            state.message,
                          );
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
                                'لا توجد نتائج حالياً',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        if (state is MembersListLoaded<UsersDataModel>) {
                          final items = state.items;
                          return Expanded(
                            child: RefreshIndicator(
                              onRefresh: _onRefresh,
                              child: ListView.builder(
                                controller: _scrollController,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount:
                                    items.length + (_isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == items.length && _isLoadingMore) {
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
                                  final timeSinceVisited =
                                      _calculateTimeSinceVisited(
                                    m.visitedAtDate,
                                    m.visitedAtTime,
                                  );
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ContainerItem(
                                      favUser: m,
                                      isTime: true,
                                      time: timeSinceVisited,
                                    ),
                                  );
                                },
                              ),
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
