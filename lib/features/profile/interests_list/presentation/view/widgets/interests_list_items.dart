import 'dart:developer';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_cubit.dart';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';

class InterestsListItems extends StatelessWidget {
  const InterestsListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavUserCubit, FavUserState>(
      builder: (context, state) {
        if (state is FavUserLoading) {
          log('Loading');
          return Center(child: CircularProgressIndicator());
        }
        if (state is FavUserSuccess) {
          log('Success');
          final interstingList = state.favUserListModel.data ?? [];

          if (interstingList.isEmpty) {
            return Center(
              child: Text(
                '0 عضو',
                style: AppTextStyles.font20LightOrangeMediumPlexSans
                    .copyWith(color: AppColors.jet),
              ),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              return ContainerItem(
                favUser: interstingList[index],
              );
            },
            separatorBuilder: (context, index) {
              return verticalSpace(3);
            },
            itemCount: interstingList.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
