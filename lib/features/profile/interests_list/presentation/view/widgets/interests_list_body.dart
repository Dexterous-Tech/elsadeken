import '../../../../widgets/container_success_way.dart';
import '../../../../widgets/profile_header.dart';
import 'interests_list_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/spacing.dart';

class InterestsListBody extends StatelessWidget {
  const InterestsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          ProfileHeader(title: 'من يهتم بي'),
          verticalSpace(42),
          ContainerSuccessWay(),
          verticalSpace(32),
          Expanded(child: InterestsListItems()),
        ],
      ),
    ));
  }
}
