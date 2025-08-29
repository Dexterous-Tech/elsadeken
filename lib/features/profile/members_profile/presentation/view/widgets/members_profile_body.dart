import 'package:elsadeken/features/profile/members_profile/presentation/view/widgets/members_profile_country.dart';
import 'package:elsadeken/features/profile/members_profile/presentation/view/widgets/members_profile_tab_bar.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';

import '../../../../widgets/profile_header.dart';
import 'members_profile_items.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/spacing.dart';

class MembersProfileBody extends StatelessWidget {
  const MembersProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          ProfileHeader(title: 'صور الأعضاء'),
          verticalSpace(42),
          MembersProfileCountry(),
          verticalSpace(32),
          Expanded(child: MembersProfileItems()),
        ],
      ),
    );
  }
}
