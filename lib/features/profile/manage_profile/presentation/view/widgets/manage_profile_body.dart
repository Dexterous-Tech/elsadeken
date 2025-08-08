import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/contents/manage_profile_login_data.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/contents/manage_profile_religion.dart';
import '../../../../widgets/profile_header.dart';
import 'contents/manage_profile_appearance.dart';
import 'contents/manage_profile_marital_status.dart';
import 'contents/manage_profile_personal_information.dart';
import 'contents/manage_profile_writing_content.dart';
import 'manage_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'contents/manage_profile_national_country.dart';

class ManageProfileBody extends StatelessWidget {
  const ManageProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 19.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ProfileHeader(title: 'تعديل بياناتي'),
              verticalSpace(28),
              ManageProfileCard(
                title: 'بيانات تسجيل الدخول',
                cardContent: ManageProfileLoginData(),
              ),
              verticalSpace(10),
              ManageProfileCard(
                title: 'الجنسية و الإقامة',
                cardContent: ManageProfileNationalCountry(),
              ),
              verticalSpace(10),
              ManageProfileCard(
                title: 'الحالة الإجتماعية',
                cardContent: ManageProfileMaritalStatus(),
              ),
              verticalSpace(10),
              ManageProfileCard(
                title: 'مظهرك',
                cardContent: ManageProfileAppearance(),
              ),
              verticalSpace(10),
              ManageProfileCard(
                title: 'الدين',
                cardContent: ManageProfileReligion(),
              ),
              verticalSpace(10),
              ManageProfileCard(
                title: 'الدراسة و العمل',
                cardContent: ManageProfileReligion(),
              ),
              verticalSpace(10),
              ManageProfileCard(
                title: 'موصفات شريكة حياتك التي ترغب الإرتباط بها',
                cardContent: ManageProfileWritingContent(),
              ),
              verticalSpace(10),
              ManageProfileCard(
                title: 'تحدث عن نفسك',
                cardContent: ManageProfileWritingContent(),
              ),
              verticalSpace(10),
              ManageProfileCard(
                title: 'المعلومات الشخصية',
                cardContent: ManageProfilePersonalInformation(),
              ),
              verticalSpace(63),
              CustomElevatedButton(onPressed: () {}, textButton: 'تعديل'),
            ],
          ),
        ),
      ),
    );
  }
}
