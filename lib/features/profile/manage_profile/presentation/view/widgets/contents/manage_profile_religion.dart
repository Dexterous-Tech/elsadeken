import 'package:flutter/material.dart';

import '../manage_profile_content_item.dart';
import '../manage_profile_custom_separator.dart';
import '../manage_profile_icon_drop_menu.dart';

class ManageProfileReligion extends StatelessWidget {
  const ManageProfileReligion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الإلتزام الديني',
          itemContent: ManageProfileIconDropMenu(title: 'متدينة كثرا'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الصلاة',
          itemContent: ManageProfileIconDropMenu(title: 'اصلي دائما'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'التدخين',
          itemContent: ManageProfileIconDropMenu(title: 'لأ'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الحجاب',
          itemContent: ManageProfileIconDropMenu(title: 'افضل ان اقول لا'),
        ),
      ],
    );
  }
}
