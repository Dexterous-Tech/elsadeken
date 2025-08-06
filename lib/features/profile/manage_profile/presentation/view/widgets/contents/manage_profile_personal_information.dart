import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_text_styles.dart';
import '../manage_profile_content_item.dart';
import '../manage_profile_custom_separator.dart';

class ManageProfilePersonalInformation extends StatelessWidget {
  const ManageProfilePersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'الإسم الكامل',
          itemContent: Text(
            'ملك محمد',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(context),
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'رقم الهاتف',
          itemContent: Text(
            '0122356666',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(context),
          ),
        ),
      ],
    );
  }
}
