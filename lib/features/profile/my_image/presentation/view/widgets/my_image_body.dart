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
import 'package:elsadeken/features/profile/widgets/container_success_way.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:elsadeken/features/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyImageBody extends StatefulWidget {
  const MyImageBody({super.key});

  @override
  State<MyImageBody> createState() => _MyImageBodyState();
}

class _MyImageBodyState extends State<MyImageBody> {
  // Default selection: "لا احد" (No one)
  String selectedPrivacyOption = 'no_one';

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
                contentBody: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                              ? Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      child: Image.file(
                                        state.image,
                                        width: 135.w,
                                        height: 135.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: 30.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<MyImageCubit>()
                                                .deleteImage();
                                          },
                                          child: Icon(
                                            Icons.delete_forever,
                                            size: 22.sp,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Image.asset(
                                  AppImages.cameraProfile,
                                  width: 134.w,
                                  height: 134.h,
                                ),
                        ),
                      ),
                      verticalSpace(30),
                      ContainerSuccessWay(text: 'المسموح لهم بمشاهدة صوري'),
                      verticalSpace(30),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Radio<String>(
                            value: 'no_one',
                            groupValue: selectedPrivacyOption,
                            onChanged: (value) {
                              setState(() {
                                selectedPrivacyOption = value!;
                              });
                            },
                            activeColor: AppColors.primaryOrange,
                          ),
                          horizontalSpace(10),
                          Expanded(
                            // Text(
                            //   '',
                            //   textDirection: TextDirection.rtl,
                            //   textAlign: TextAlign.right,
                            //   style:
                            //   AppTextStyles.font14PumpkinOrangeBoldLamaSans,
                            // ),
                            child: RichText(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'لا احد ',
                                      style: AppTextStyles
                                          .font14PumpkinOrangeBoldLamaSans
                                          .copyWith(color: AppColors.black)),
                                  TextSpan(
                                    text: '(حجب صورتي)',
                                    style: AppTextStyles
                                        .font14PumpkinOrangeBoldLamaSans
                                        .copyWith(color: AppColors.beer),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(16),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Radio<String>(
                            value: 'all_members',
                            groupValue: selectedPrivacyOption,
                            onChanged: (value) {
                              setState(() {
                                selectedPrivacyOption = value!;
                              });
                            },
                            activeColor: AppColors.primaryOrange,
                          ),
                          horizontalSpace(10),
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'كل الاعضاء ',
                                    style: AppTextStyles
                                        .font14PumpkinOrangeBoldLamaSans
                                        .copyWith(color: AppColors.black),
                                  ),
                                  TextSpan(
                                    text: '(خاصية للذكور فقط)',
                                    style: AppTextStyles
                                        .font14PumpkinOrangeBoldLamaSans
                                        .copyWith(color: AppColors.beer),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(30),
                      CustomElevatedButton(
                        onPressed: state is MyImageImageSelected
                            ? () => context.read<MyImageCubit>().updateImage()
                            : () {},
                        textButton: 'تحميل صوره',
                      ),
                      verticalSpace(20), // Add bottom padding for scroll safety
                    ],
                  ),
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
