import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../widgets/container_item/container_item.dart';
import 'package:flutter/material.dart';

class MembersProfileItems extends StatelessWidget {
  const MembersProfileItems({super.key});

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
              return ContainerItem();
            },
            separatorBuilder: (context, index) {
              return verticalSpace(15);
            },
            itemCount: 10,
          );
  }
}
