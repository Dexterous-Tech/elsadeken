import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_text_styles.dart';
import '../manage_profile_content_item.dart';
import '../manage_profile_custom_separator.dart';
import '../manage_profile_icon_drop_menu.dart';

class ManageProfileJob extends StatelessWidget {
  const ManageProfileJob({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'المؤهل التعليمي ',
          itemContent: ManageProfileIconDropMenu(title: 'دراسة جامعية'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الوضع المادي',
          itemContent: ManageProfileIconDropMenu(title: 'متوسط'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'مجال العمل',
          itemContent: ManageProfileIconDropMenu(title: 'مجال النقل'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الوظيفة',
          itemContent: Text(
            'مبرمجة',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(context),
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الدخل الشهري',
          itemContent: ManageProfileIconDropMenu(title: 'أقل من 2000 ريال'),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'الحالة الصحية',
          itemContent: ManageProfileIconDropMenu(title: 'بهاق'),
        ),
      ],
    );
  }
}
