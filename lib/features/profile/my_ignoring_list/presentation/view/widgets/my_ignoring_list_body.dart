import 'package:elsadeken/features/profile/my_ignoring_list/presentation/view/widgets/my_ignoring_list_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/spacing.dart';
import '../../../../widgets/container_success_way.dart';
import '../../../../widgets/profile_header.dart';

class MyIgnoringListBody extends StatelessWidget {
  const MyIgnoringListBody({super.key});

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
          ProfileHeader(title: 'قائمة التجاهل'),
          verticalSpace(42),
          ContainerSuccessWay(),
          verticalSpace(32),
          Expanded(child: MyIgnoringListItems()),
        ],
      ),
    ));
  }
}
