import 'dart:developer';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/manager/ignore_user_cubit.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/manager/ignore_user_state.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyIgnoringListItems extends StatefulWidget {
  const MyIgnoringListItems({super.key});

  @override
  State<MyIgnoringListItems> createState() => _MyIgnoringListItemsState();
}

class _MyIgnoringListItemsState extends State<MyIgnoringListItems> {
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
    final cubit = context.read<IgnoreUserCubit>();
    final state = cubit.state;

    if (state is IgnoreUserSuccess && state.hasNextPage && !_isLoadingMore) {
      final nextPage = state.currentPage + 1;
      log('Loading more ignore users: current page ${state.currentPage}, next page $nextPage, hasNextPage: ${state.hasNextPage}');
      setState(() {
        _isLoadingMore = true;
      });
      cubit.ignoreUsers(page: nextPage).then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
          log('Pagination loading completed');
        }
      });
    } else {
      log('Cannot load more: state is ${state.runtimeType}, hasNextPage: ${state is IgnoreUserSuccess ? state.hasNextPage : false}, isLoadingMore: $_isLoadingMore');
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
    context.read<IgnoreUserCubit>().ignoreUsers(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IgnoreUserCubit, IgnoreUserState>(
      builder: (context, state) {
        if (state is IgnoreUserFailure) {
          log('error');
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
                  state.errorMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14DesiredMediumLamaSans,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () =>
                      context.read<IgnoreUserCubit>().ignoreUsers(page: 1),
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
        if (state is IgnoreUserSuccess) {
          log('Success');
          final ignoreList = state.ignoreUsersResponseModel.data ?? [];

          if (ignoreList.isEmpty) {
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
                if (index == ignoreList.length && _isLoadingMore) {
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
                  favUser: ignoreList[index],
                );
              },
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    verticalSpace(11),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Color(0xffF4F4F4),
                    ),
                    verticalSpace(11),
                  ],
                );
              },
              itemCount: ignoreList.length + (_isLoadingMore ? 1 : 0),
            ),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.primaryOrange,
            strokeWidth: 2,
          ));
        }
      },
    );
  }
}
