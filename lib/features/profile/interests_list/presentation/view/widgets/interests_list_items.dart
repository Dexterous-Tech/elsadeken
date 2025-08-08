import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';

class InterestsListItems extends StatelessWidget {
  const InterestsListItems({super.key});

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
              return ContainerItem(
                isTime: true,
              );
            },
            separatorBuilder: (context, index) {
              return verticalSpace(3);
            },
            itemCount: 10,
          );
  }
}
