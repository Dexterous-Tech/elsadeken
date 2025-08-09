import 'package:elsadeken/features/profile/my_ignoring_list/presentation/view/widgets/my_ignoring_list_items.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/spacing.dart';
import '../../../../widgets/container_success_way.dart';
import '../../../../widgets/profile_header.dart';

class MyIgnoringListBody extends StatelessWidget {
  const MyIgnoringListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          ProfileHeader(title: 'قائمة التجاهل'),
          verticalSpace(42),
          ContainerSuccessWay(),
          verticalSpace(32),
          Expanded(child: MyIgnoringListItems()),
        ],
      ),
    );
  }
}
