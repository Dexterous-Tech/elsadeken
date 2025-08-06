import 'package:flutter/material.dart';

import '../manage_profile_content_item.dart';
import '../manage_profile_custom_separator.dart';
import '../manage_profile_icon_drop_menu.dart';

class ManageProfileAppearance extends StatelessWidget {
  const ManageProfileAppearance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الزون(كغ)',
          itemContent: ManageProfileIconDropMenu(title: '60'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الطول(سم)',
          itemContent: ManageProfileIconDropMenu(title: '166'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'لون البشرة',
          itemContent: ManageProfileIconDropMenu(title: 'حنطي مائل للبياض'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'بنية الجسم',
          itemContent: ManageProfileIconDropMenu(title: 'سمينة'),
        ),
      ],
    );
  }
}
