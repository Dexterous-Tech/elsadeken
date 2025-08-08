import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsBody extends StatelessWidget {
  const ContactUsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 25.w),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ProfileHeader(title: 'إتصل بنا'),
          verticalSpace(50),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10).r,
                color: AppColors.lightCarminePink.withValues(alpha: 0.05)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'في حالة قمت بشراء بطاقة الصادقون و الصادقات من الوكيل المحلي ، فسيرسل لك رقم لتفعيل باقة التميز ، قم بإدخاله في الخانة اسفله و سيتم ترقية حسابك الى عضوية مميزة مباشرة',
                  style: AppTextStyles.font13BlackMediumPlexSans.copyWith(
                      fontWeight: FontWeightHelper.regular,
                      color: AppColors.jet),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
                verticalSpace(32),
                CustomTextFormField(
                  hintText: 'البريد الإلكتروني الخاص بك',
                  validator: (value) {},
                  borderColor: Color(0xffFFB74D),
                ),
                verticalSpace(8),
                CustomTextFormField(
                  hintText: 'موضوع الرسالة',
                  validator: (value) {},
                  borderColor: Color(0xffFFB74D),
                ),
                verticalSpace(8),
                CustomTextFormField(
                  hintText: 'اكتب رسالتك',
                  validator: (value) {},
                  maxLines: 5,
                  borderColor: Color(0xffFFB74D),
                ),
                verticalSpace(16),
                CustomElevatedButton(
                  onPressed: () {},
                  textButton: 'ارســــــــل',
                ),
                verticalSpace(13),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(AppRoutes.profileTechnicalSupportScreen);
                  },
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.contactHeadphoneProfile,
                        width: 17.w,
                        height: 17.h,
                      ),
                      horizontalSpace(13),
                      Text(
                        'تحدث معنا',
                        style: AppTextStyles.font13BlackMediumPlexSans.copyWith(
                            fontFamily: FontFamilyHelper.lamaSansArabic,
                            color: AppColors.sinopia),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
