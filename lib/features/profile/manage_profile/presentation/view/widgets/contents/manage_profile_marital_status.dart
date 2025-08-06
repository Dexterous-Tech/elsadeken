import 'package:flutter/material.dart';

import '../manage_profile_content_item.dart';
import '../manage_profile_custom_separator.dart';
import '../manage_profile_icon_drop_menu.dart';

class ManageProfileMaritalStatus extends StatelessWidget {
  const ManageProfileMaritalStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'حالة الحساب',
          itemContent: ManageProfileIconDropMenu(title: 'مطلقة'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'نوع الزواج',
          itemContent: ManageProfileIconDropMenu(title: 'الزوجة الوحيدة'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'العمر',
          itemContent: ManageProfileIconDropMenu(title: '23'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الاطفال',
          itemContent: ManageProfileIconDropMenu(title: '0'),
        ),
      ],
    );
  }
}
