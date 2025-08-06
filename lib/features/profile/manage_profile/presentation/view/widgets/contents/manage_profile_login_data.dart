import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_content_item.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/manage_profile_custom_separator.dart';
import 'package:flutter/material.dart';

class ManageProfileLoginData extends StatelessWidget {
  const ManageProfileLoginData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: TextDirection.rtl,
      children: [
        ManageProfileContentItem(
          title: 'رقم العضوية',
          itemContent: Text(
            '12345678',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(context),
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'اسم المستخدم',
          itemContent: Row(
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'Esraa Mohamed',
                style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(
                  context,
                ),
              ),
              horizontalSpace(3),
              Text(
                'تعديل',
                style: AppTextStyles.font14JetRegularPlexSans(context),
              ),
            ],
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'تاريخ التسجيل',
          itemContent: Text(
            'منذ 2 ايام',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(context),
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'كلمة المرور',
          itemContent: Text(
            'تعديل',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(context),
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'البريد الإلكتروني',
          itemContent: Text(
            'تعديل',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(context),
          ),
        ),
        ManageProfileCustomSeparator(),
        ManageProfileContentItem(
          title: 'حذف حسابي',
          itemContent: Text(
            'حذف',
            style: AppTextStyles.font18PhilippineBronzeRegularPlexSans(
              context,
            ).copyWith(color: AppColors.vividRed),
          ),
        ),
      ],
    );
  }
}
