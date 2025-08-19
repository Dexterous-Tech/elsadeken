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
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart'
    as error_dialog;
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart'
    as loading_dialog;
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart'
    as success_dialog;
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:elsadeken/features/profile/contact_us/presentation/manager/contact_us_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsBody extends StatelessWidget {
  const ContactUsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactUsCubit, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsLoading) {
          loading_dialog.loadingDialog(context);
        } else if (state is ContactUsSuccess) {
          Navigator.pop(context); // Close loading dialog
          success_dialog.successDialog(
            context: context,
            message: 'تم إرسال رسالتك بنجاح',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        } else if (state is ContactUsFailure) {
          Navigator.pop(context); // Close loading dialog
          error_dialog.errorDialog(
            context: context,
            error: state.message,
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }
      },
      builder: (context, state) {
        return CustomProfileBody(
          contentBody: SingleChildScrollView(
            child: Form(
              key: ContactUsCubit.get(context).formKey,
              child: Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ProfileHeader(title: 'إتصل بنا'),
                  verticalSpace(50),
                  Container(
                    padding: EdgeInsets.only(
                        left: 13.w, right: 13.w, top: 13.h, bottom: 16.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        color:
                            AppColors.lightCarminePink.withValues(alpha: 0.05)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'في حالة قمت بشراء بطاقة الصادقون و الصادقات من الوكيل المحلي ، فسيرسل لك رقم لتفعيل باقة التميز ، قم بإدخاله في الخانة اسفله و سيتم ترقية حسابك الى عضوية مميزة مباشرة',
                          style: AppTextStyles.font13BlackMediumLamaSans
                              .copyWith(
                                  fontWeight: FontWeightHelper.regular,
                                  color: AppColors.jet),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(32),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 34.w),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller:
                                    ContactUsCubit.get(context).emailController,
                                hintText: 'البريد الإلكتروني الخاص بك',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال البريد الإلكتروني';
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'يرجى إدخال بريد إلكتروني صحيح';
                                  }
                                  return null;
                                },
                                borderColor: Color(0xffFFB74D),
                              ),
                              verticalSpace(8),
                              CustomTextFormField(
                                controller:
                                    ContactUsCubit.get(context).titleController,
                                hintText: 'موضوع الرسالة',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال موضوع الرسالة';
                                  }
                                  return null;
                                },
                                borderColor: Color(0xffFFB74D),
                              ),
                              verticalSpace(8),
                              CustomTextFormField(
                                controller: ContactUsCubit.get(context)
                                    .descriptionController,
                                hintText: 'اكتب رسالتك',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال محتوى الرسالة';
                                  }
                                  if (value.length < 10) {
                                    return 'يجب أن تكون الرسالة أكثر من 10 أحرف';
                                  }
                                  return null;
                                },
                                maxLines: 5,
                                borderColor: Color(0xffFFB74D),
                              ),
                              verticalSpace(16),
                              CustomElevatedButton(
                                height: 39.h,
                                onPressed: () {
                                  ContactUsCubit.get(context).contactUs();
                                },
                                textButton: 'ارســــــــل',
                              ),
                              verticalSpace(13),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                      AppRoutes.profileTechnicalSupportScreen);
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
                                      style: AppTextStyles
                                          .font13BlackMediumLamaSans
                                          .copyWith(
                                              fontFamily: FontFamilyHelper
                                                  .lamaSansArabic,
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
