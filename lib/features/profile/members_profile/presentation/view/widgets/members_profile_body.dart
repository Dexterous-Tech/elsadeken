import 'package:elsadeken/features/profile/members_profile/presentation/view/widgets/members_profile_country.dart';
import 'package:elsadeken/features/profile/members_profile/presentation/view/widgets/members_profile_tab_bar.dart';

import '../../../../widgets/profile_header.dart';
import 'members_profile_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/spacing.dart';

class MembersProfileBody extends StatelessWidget {
  const MembersProfileBody({super.key});

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
          ProfileHeader(title: 'صور الأعضاء'),
          verticalSpace(42),
          MembersProfileTabBar(),
          verticalSpace(16),
          MembersProfileCountry(),
          verticalSpace(32),
          Expanded(child: MembersProfileItems()),
        ],
      ),
    ));
  }
}
