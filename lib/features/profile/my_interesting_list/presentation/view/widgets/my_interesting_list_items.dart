import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/widgets/item/profile_lists_item.dart';
import 'package:flutter/material.dart';

class MyInterestingListItems extends StatelessWidget {
  const MyInterestingListItems({super.key});

  @override
  Widget build(BuildContext context) {
    int length = 10;
    return length == 0
        ? Center(
            child: Text(
              '0 عضو',
              style: AppTextStyles.font20LightOrangeMediumPlexSans
                  .copyWith(color: AppColors.jet),
            ),
          )
        : ListView.separated(
            itemBuilder: (context, index) {
              return ProfileListsItem();
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
            itemCount: 10,
          );
  }
}
