import 'dart:developer';
import 'package:elsadeken/features/profile/members_profile/presentation/manager/members_profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MembersProfileItems extends StatefulWidget {
  const MembersProfileItems({super.key});

  @override
  State<MembersProfileItems> createState() => _MembersProfileItemsState();
}

class _MembersProfileItemsState extends State<MembersProfileItems> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Remove automatic data loading - country widget will handle initial load
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreUsers() {
    final cubit = context.read<MembersProfileCubit>();
    final state = cubit.state;

    if (state is MembersProfileStateSuccess &&
        state.hasNextPage &&
        !_isLoadingMore) {
      final nextPage = state.currentPage + 1;
      log('Loading more members profile: current page ${state.currentPage}, next page $nextPage, hasNextPage: ${state.hasNextPage}');
      setState(() {
        _isLoadingMore = true;
      });
      cubit.getMembersProfile(page: nextPage).then((_) {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
          log('Pagination loading completed');
        }
      });
    } else {
      log('Cannot load more: state is ${state.runtimeType}, hasNextPage: ${state is MembersProfileStateSuccess ? state.hasNextPage : false}, isLoadingMore: $_isLoadingMore');
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
    final cubit = context.read<MembersProfileCubit>();
    cubit.getMembersProfile(page: 1);
  }

  Widget _buildMemberItem(dynamic member) {
    final country = member.attribute?.country?.trim();
    final city = member.attribute?.city?.trim();

    final location = [
      country?.isNotEmpty == true ? country : 'لا يوجد',
      city?.isNotEmpty == true ? city : 'لا يوجد',
    ].join(' , ');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6).r,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 36,
              offset: Offset(0, 4),
            ),
          ]),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage:
                member.image != null ? NetworkImage(member.image) : null,
            child: member.image == null
                ? Icon(Icons.person, size: 30.sp, color: AppColors.grey)
                : null,
          ),
          horizontalSpace(16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  member.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font14BeerMediumLamaSans
                      .copyWith(color: Color(0xff7D7D7D)),
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12.5.sp,
                      color: AppColors.grey,
                    ),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.font13BlackMediumLamaSans.copyWith(
                          color: AppColors.black.withValues(
                            alpha: 0.87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersProfileCubit, MembersProfileState>(
      builder: (context, state) {
        log('MembersProfileItems: State changed to ${state.runtimeType}');

        if (state is MembersProfileStateFailure) {
          log('Failure: ${state.error}');
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
                  onPressed: () {
                    final cubit = context.read<MembersProfileCubit>();
                    cubit.getMembersProfile(page: 1);
                  },
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
        if (state is MembersProfileStateSuccess) {
          final membersList = state.membersProfileResponseModel.data ?? [];
          log('Success: Loaded ${membersList.length} members');

          if (membersList.isEmpty) {
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
                if (index == membersList.length && _isLoadingMore) {
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
                return _buildMemberItem(membersList[index]);
              },
              separatorBuilder: (context, index) {
                return verticalSpace(15);
              },
              itemCount: membersList.length + (_isLoadingMore ? 1 : 0),
            ),
          );
        } else {
          log('Loading state');
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
