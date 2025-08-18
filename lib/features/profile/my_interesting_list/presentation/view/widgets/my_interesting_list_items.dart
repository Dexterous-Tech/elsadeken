import 'dart:developer';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/manager/interesting_list_state.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/manager/interesting_list_cubit.dart';
import 'package:elsadeken/features/profile/widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyInterestingListItems extends StatelessWidget {
  const MyInterestingListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterestingListCubit, InterestingListState>(
      builder: (context, state) {
        if (state is InterestingListStateFailure) {
          log('failure');
          return Center(
            child: Text(
              state.error,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14DesiredMediumLamaSans,
            ),
          );
        } else if (state is InterestingListStateSuccess) {
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
            itemCount: interestingList.length,
            itemBuilder: (context, index) {
              return ContainerItem(
                favUser: interestingList[index],
              );
            },
            separatorBuilder: (context, index) => Column(
              children: [
                verticalSpace(11),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Color(0xffF4F4F4),
                ),
                verticalSpace(11),
              ],
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
