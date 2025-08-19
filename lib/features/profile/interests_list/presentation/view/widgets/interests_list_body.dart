import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';

import '../../../../widgets/container_success_way.dart';
import '../../../../widgets/profile_header.dart';
import 'interests_list_items.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/spacing.dart';

class InterestsListBody extends StatelessWidget {
  const InterestsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          ProfileHeader(title: 'قائمة الاهتمام'),
          verticalSpace(42),
          ContainerSuccessWay(),
          verticalSpace(32),
          Expanded(child: InterestsListItems()),
        ],
      ),
    );
  }
}
