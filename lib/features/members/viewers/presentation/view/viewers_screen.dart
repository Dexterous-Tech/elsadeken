import 'dart:developer';

import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
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
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../profile/widgets/profile_header.dart';

class ViewersView extends StatefulWidget {
  const ViewersView({super.key});

  @override
  State<ViewersView> createState() => _ViewersViewState();
}

class _ViewersViewState extends State<ViewersView> {
  ScrollController? _scrollController;
  final bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  // void _loadMoreUsers(BuildContext context) {
  //   final cubit = context.read<MembersListCubit<UsersDataModel>>();
  //   final state = cubit.state;
  //
  //   if (state is MembersListLoaded<UsersDataModel> &&
  //       state.hasNextPage &&
  //       !_isLoadingMore) {
  //     final nextPage = state.currentPage + 1;
  //     print(
  //         'Loading more viewers: current page ${state.currentPage}, next page $nextPage');
  //     setState(() {
  //       _isLoadingMore = true;
  //     });
  //     cubit.fetch(page: nextPage).then((_) {
  //       if (mounted) {
  //         setState(() {
  //           _isLoadingMore = false;
  //         });
  //         print('Pagination loading completed');
  //       }
  //     });
  //   }
  // }

  // void _onScroll(BuildContext context) {
  //   if (_scrollController?.position.pixels != null &&
  //       _scrollController!.position.pixels >=
  //           _scrollController!.position.maxScrollExtent - 200) {
  //     print('Scroll threshold reached, triggering pagination');
  //     _loadMoreUsers(context);
  //   }
  // }

  Future<void> _onRefresh() async {
    // We'll handle this in the build method where context is available
  }

  String _calculateTimeSinceVisited(
      String? visitedAtDate, String? visitedAtTime) {
    if (visitedAtDate == null || visitedAtTime == null) {
      return AppLocalizations.of(context)!.notSpecified;
    }

    try {
      // Parse the date and time
      final dateTimeStr = '$visitedAtDate $visitedAtTime';
      final visitedDateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(visitedDateTime);

      if (difference.inMinutes < 1) {
        return AppLocalizations.of(context)!.now;
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        if (minutes == 1) {
          return AppLocalizations.of(context)!.minuteAgo;
        } else if (minutes == 2) {
          return AppLocalizations.of(context)!.twoMinutesAgo;
        } else if (minutes < 11) {
          return AppLocalizations.of(context)!.minutesAgo(minutes);
        } else {
          return AppLocalizations.of(context)!.minutesAgoSingle(minutes);
        }
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        if (hours == 1) {
          return AppLocalizations.of(context)!.hourAgo;
        } else if (hours == 2) {
          return AppLocalizations.of(context)!.twoHoursAgo;
        } else if (hours < 11) {
          return AppLocalizations.of(context)!.hoursAgo(hours);
        } else {
          return AppLocalizations.of(context)!.hoursAgoSingle(hours);
        }
      } else {
        final days = difference.inDays;
        if (days == 1) {
          return AppLocalizations.of(context)!.dayAgo;
        } else if (days == 2) {
          return AppLocalizations.of(context)!.twoDaysAgo;
        } else if (days < 11) {
          return AppLocalizations.of(context)!.daysAgo(days);
        } else {
          return AppLocalizations.of(context)!.daysAgoSingle(days);
        }
      }
    } catch (e) {
      return AppLocalizations.of(context)!.notSpecified;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = MembersListCubit<UsersDataModel>(
      ({int? page}) async {
        final response = await sl<MembersRepository>().getVisitors(page: page);
        return response;
      },
    )..fetch();

    return Directionality(
      textDirection: LocalizationService.instance.textDirection,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: ProfileHeader(
                          title:
                              AppLocalizations.of(context)!.whoVisitedMyProfile,
                          titleStyle: AppTextStyles.font20WhiteBoldLamaSans
                              .copyWith(color: AppColors.black)),
                    ),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64.sp,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 16.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 32.w),
                                    child: Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles
                                          .font14DesiredMediumLamaSans,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      cubit.fetch(page: 1);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryOrange,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.w,
                                        vertical: 12.h,
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.retry,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (state is MembersListEmpty<UsersDataModel>) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .noResultsCurrently,
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
                                      padding:
                                          const EdgeInsetsDirectional.all(16.0),
                                      child: Center(
                                        child: Column(
                                          textDirection: LocalizationService
                                              .instance.textDirection,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .loadingMore,
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
                                    padding:
                                        EdgeInsetsDirectional.only(bottom: 12),
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
