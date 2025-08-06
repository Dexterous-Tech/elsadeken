import '../manage_profile_icon_drop_menu.dart';
import 'package:flutter/material.dart';
import '../manage_profile_content_item.dart';
import '../manage_profile_custom_separator.dart';

class ManageProfileNationalCountry extends StatelessWidget {
  const ManageProfileNationalCountry({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الجنسية',
          itemContent: ManageProfileIconDropMenu(title: 'السعودية'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الدولة',
          itemContent: ManageProfileIconDropMenu(title: 'السعودية'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'المدينة',
          itemContent: ManageProfileIconDropMenu(title: 'السعودية'),
        ),
      ],
    );
  }
}
