import 'dart:developer';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/manager/ignore_user_cubit.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/manager/ignore_user_state.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyIgnoringListItems extends StatelessWidget {
  const MyIgnoringListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IgnoreUserCubit, IgnoreUserState>(
      builder: (context, state) {
        if (state is IgnoreUserFailure) {
          log('error');
          return Center(
            child: Text(
              state.errorMessage,
              style: AppTextStyles.font14DesiredMediumLamaSans,
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
          return ListView.separated(
            itemBuilder: (context, index) {
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
            itemCount: ignoreList.length,
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
