import 'dart:io';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/my_image/presentation/manager/my_image_cubit.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyImageBody extends StatelessWidget {
  const MyImageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<MyImageCubit>(),
        child: Builder(builder: (context) {
          return BlocConsumer<MyImageCubit, MyImageState>(
            listener: (context, state) {
              if (state is MyImageLoading) {
                loadingDialog(context);
              } else if (state is MyImageFailure) {
                Navigator.pop(context); // Close loading dialog
                errorDialog(
                  context: context,
                  error: state.error,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              } else if (state is MyImageSuccess) {
                Navigator.pop(context); // Close loading dialog
                successDialog(
                  context: context,
                  message: state.profileActionResponseModel.message ??
                      'تم رفع الصورة بنجاح',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                );
              }
            },
            builder: (context, state) {
              return CustomProfileBody(
                contentBody: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    ProfileHeader(title: 'صورتي'),
                    verticalSpace(30),
                    Text(
                      'معلومات هامة :',
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.font20LightOrangeMediumLamaSans
                          .copyWith(
                        color: Color(0xffF9F9F9),
                      ),
                    ),
                    verticalSpace(30),
                    informationItem(
                        'يجب ان تكون الصورة محترمة ، ولائقة بطابع التطبيق الإسلامي'),
                    informationItem(
                        'أي إستخدام سيء لهذه الخدمة يؤدي إاى حظر إشتراكك بدون سابق إنذار'),
                    verticalSpace(35),
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImageSourceDialog(
                            context, context.read<MyImageCubit>()),
                        child: state is MyImageImageSelected
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.file(
                                  state.image,
                                  width: 134.w,
                                  height: 134.h,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                AppImages.cameraProfile,
                                width: 134.w,
                                height: 134.h,
                              ),
                      ),
                    ),
                    Spacer(),
                    CustomElevatedButton(
                      onPressed: state is MyImageImageSelected
                          ? () => context.read<MyImageCubit>().updateImage()
                          : () {},
                      textButton: 'تحميل صوره',
                    )
                  ],
                ),
              );
            },
          );
        }));
  }

  void _showImageSourceDialog(BuildContext context, MyImageCubit cubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          title: Text(
            'اختر مصدر الصورة',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16BlackSemiBoldLamaSans,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primaryOrange),
                title: Text(
                  'التقاط صورة من الكاميرا',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font14BlackRegularLamaSans,
                ),
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImageFromCamera();
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.photo_library, color: AppColors.primaryOrange),
                title: Text(
                  'اختيار من المعرض',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font14BlackRegularLamaSans,
                ),
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget informationItem(String info) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 4.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 14.h),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: AppColors.jet),
          ),
          horizontalSpace(16),
          Expanded(
            child: Text(
              info,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTextStyles.font19JetRegularLamaSans,
            ),
          )
        ],
      ),
    );
  }
}
