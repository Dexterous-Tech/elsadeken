import 'dart:developer';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_cubit.dart';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../../../features/profile/widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';

class InterestsListItems extends StatelessWidget {
  const InterestsListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavUserCubit, FavUserState>(
      builder: (context, state) {
        if (state is FavUserFailure) {
          log('Loading');
          return Center(
            child: Text(
              state.error,
              style: AppTextStyles.font14DesiredMediumLamaSans,
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
          return ListView.separated(
            itemBuilder: (context, index) {
              return ContainerItem(
                favUser: interestingList[index],
              );
            },
            separatorBuilder: (context, index) {
              return verticalSpace(3);
            },
            itemCount: interestingList.length,
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
