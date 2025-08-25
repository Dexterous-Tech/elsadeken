import 'dart:developer';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_cubit.dart';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../../../features/profile/widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestsListItems extends StatefulWidget {
  const InterestsListItems({super.key});

  @override
  State<InterestsListItems> createState() => _InterestsListItemsState();
}

class _InterestsListItemsState extends State<InterestsListItems> {
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
    final cubit = context.read<FavUserCubit>();
    final state = cubit.state;

    if (state is FavUserSuccess && state.hasNextPage && !_isLoadingMore) {
      final nextPage = state.currentPage + 1;
      log('Loading more fav users: current page ${state.currentPage}, next page $nextPage, hasNextPage: ${state.hasNextPage}');
      setState(() {
        _isLoadingMore = true;
      });
      cubit.favUser(page: nextPage).then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
          log('Pagination loading completed');
        }
      });
    } else {
      log('Cannot load more: state is ${state.runtimeType}, hasNextPage: ${state is FavUserSuccess ? state.hasNextPage : false}, isLoadingMore: $_isLoadingMore');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      log('Scroll threshold reached, triggering pagination');
      _loadMoreUsers();
    }
  }

  Future<void> _onRefresh() async {
    context.read<FavUserCubit>().favUser(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavUserCubit, FavUserState>(
      builder: (context, state) {
        if (state is FavUserFailure) {
          log('Failure');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14DesiredMediumLamaSans,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () =>
                      context.read<FavUserCubit>().favUser(page: 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is FavUserSuccess) {
          log('Success');
          final interestingList = state.favUserListModel.data ?? [];

          if (interestingList.isEmpty) {
            return Center(
              child: Text(
                '0 عضو',
                style: AppTextStyles.font20LightOrangeMediumLamaSans
                    .copyWith(color: AppColors.jet),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primaryOrange,
            child: ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == interestingList.length && _isLoadingMore) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryOrange,
                            strokeWidth: 2,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'جاري تحميل المزيد...',
                            style: AppTextStyles.font12JetRegularLamaSans
                                .copyWith(color: AppColors.beer),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ContainerItem(
                  favUser: interestingList[index],
                );
              },
              separatorBuilder: (context, index) {
                return verticalSpace(3);
              },
              itemCount: interestingList.length + (_isLoadingMore ? 1 : 0),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryOrange,
              strokeWidth: 2,
            ),
          );
        }
      },
    );
  }
}
