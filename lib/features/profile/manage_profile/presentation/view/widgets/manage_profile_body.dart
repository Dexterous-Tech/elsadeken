import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/contents/manage_profile_login_data.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/contents/manage_profile_religion.dart';
import 'package:elsadeken/features/profile/manage_profile/presentation/manager/manage_profile_cubit.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import '../../../../widgets/profile_header.dart';
import 'contents/manage_profile_appearance.dart';
import 'contents/manage_profile_marital_status.dart';
import 'contents/manage_profile_personal_information.dart';
import 'contents/manage_profile_writing_content.dart';
import 'manage_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'contents/manage_profile_national_country.dart';
import 'contents/manage_profile_job.dart';

class ManageProfileBody extends StatefulWidget {
  const ManageProfileBody({super.key});

  @override
  State<ManageProfileBody> createState() => _ManageProfileBodyState();
}

class _ManageProfileBodyState extends State<ManageProfileBody> {
  @override
  void initState() {
    super.initState();
    // Load profile data when widget initializes
    context.read<ManageProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageProfileCubit, ManageProfileState>(
      listener: (context, state) {
        // Handle state changes if needed
      },
      builder: (context, state) {
        final profileData = state is ManageProfileSuccess
            ? state.myProfileResponseModel.data
            : null;
        final isLoading = state is ManageProfileLoading;

        return CustomProfileBody(
          withStar: false,
          contentBody: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                ProfileHeader(title: 'تعديل بياناتي'),
                verticalSpace(28),
                ManageProfileCard(
                  title: 'بيانات تسجيل الدخول',
                  cardContent: ManageProfileLoginData(
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                verticalSpace(10),
                ManageProfileCard(
                  title: 'الجنسية و الإقامة',
                  cardContent: ManageProfileNationalCountry(
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                verticalSpace(10),
                ManageProfileCard(
                  title: 'الحالة الإجتماعية',
                  cardContent: ManageProfileMaritalStatus(
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                verticalSpace(10),
                ManageProfileCard(
                  title: 'مظهرك',
                  cardContent: ManageProfileAppearance(
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                verticalSpace(10),
                ManageProfileCard(
                  title: 'الدين',
                  cardContent: ManageProfileReligion(
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                verticalSpace(10),
                ManageProfileCard(
                  title: 'الدراسة و العمل',
                  cardContent: ManageProfileJob(
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                verticalSpace(10),
                ManageProfileCard(
                  title: 'موصفات شريكة حياتك التي ترغب الإرتباط بها',
                  cardContent: ManageProfileWritingContent(
                    label: 'موصفات شريكة حياتك التي ترغب الإرتباط بها',
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                verticalSpace(10),
                ManageProfileCard(
                  title: 'تحدث عن نفسك',
                  cardContent: ManageProfileWritingContent(
                    label: 'تحدث عن نفسك',
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                verticalSpace(10),
                ManageProfileCard(
                  title: 'المعلومات الشخصية',
                  cardContent: ManageProfilePersonalInformation(
                    profileData: profileData,
                    isLoading: isLoading,
                  ),
                ),
                // verticalSpace(63),
                // CustomElevatedButton(onPressed: () {}, textButton: 'تعديل'),
              ],
            ),
          ),
        );
      },
    );
  }
}
