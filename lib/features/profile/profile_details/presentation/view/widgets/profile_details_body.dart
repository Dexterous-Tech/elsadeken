import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/core/widgets/dialog/error_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/loading_dialog.dart';
import 'package:elsadeken/core/widgets/dialog/success_dialog.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/profile_details_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card_item.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_logo.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsBody extends StatelessWidget {
  ProfileDetailsBody({super.key});

  final List logHistory = [
    {
      'title': 'مسجل منذ',
      'subTitle': 'منذ يوم',
    },
    {
      'title': 'تاريخ اخر زياره',
      'subTitle': 'متواجد حاليا',
    },
  ];

  final List information = [
    {
      'title': 'الجنسيه',
      'subTitle': 'مصر',
    },
    {
      'title': 'الاقامه',
      'subTitle': 'مصر',
    },
    {
      'title': 'المدينه',
      'subTitle': 'مصر',
    },
    {
      'title': 'نوع الزواج',
      'subTitle': 'زوجه اولي',
    },
    {
      'title': 'الحاله الاجتماعيه',
      'subTitle': 'مطلق',
    },
    {
      'title': 'عدد الاطفال',
      'subTitle': 'لا يوجد',
    },
    {
      'title': 'لون البشره',
      'subTitle': 'حنطي مايل للبياض',
    },
    {
      'title': 'الطول',
      'subTitle': 'سنتي 190',
    },
    {
      'title': 'الوزن',
      'subTitle': 'كيلو 80',
    },
    {
      'title': 'المؤهل التعليمي',
      'subTitle': 'دكتوراه',
    },
    {
      'title': 'الوضع المادي',
      'subTitle': 'جيدة',
    },
    {
      'title': 'الدخل الشهري',
      'subTitle': 'جنية 9000-1200',
    },
    {
      'title': 'الحالة الصحية',
      'subTitle': 'سليمة-لا ادخن',
    },
    {
      'title': 'الإتزام الديني',
      'subTitle': 'متدينة اصلي اغلب الوقت',
    },
    {
      'title': 'الحجاب',
      'subTitle': 'محجبة (كشف الوجه)',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: TextDirection.ltr,
          children: [
            CustomArrowBack(),
            ProfileDetailsLogo(),
            verticalSpace(20),
            Row(
              // spacing: 37.75,
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomContainer(
                  img: AppImages.share,
                  color: AppColors.lightBlue.withValues(alpha: 0.07),
                  text: 'مشاركة',
                ),
                BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
                  buildWhen: (context, current) =>
                      current is LikeUserLoading ||
                      current is LikeUserFailure ||
                      current is LikeUserSuccess,
                  listenWhen: (context, current) =>
                      current is LikeUserLoading ||
                      current is LikeUserFailure ||
                      current is LikeUserSuccess,
                  listener: (context, state) {
                    if (state is LikeUserLoading) {
                      loadingDialog(context);
                    } else if (state is LikeUserFailure) {
                      context.pop();
                      errorDialog(context: context, error: state.error);
                    } else if (state is LikeUserSuccess) {
                      context.pop();
                      successDialog(
                          context: context,
                          message:
                              state.profileDetailsActionResponseModel.message ??
                                  'تم الاعجاب',
                          onPressed: () {
                            context.pop();
                          });
                    }
                  },
                  builder: (context, state) {
                    return CustomContainer(
                      img: AppImages.like,
                      color: AppColors.lightPink.withValues(alpha: 0.07),
                      text: 'اهتمام',
                      onTap: () {
                        context.read<ProfileDetailsCubit>().likeUser("3");
                      },
                    );
                  },
                ),
                BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
                  buildWhen: (context, current) =>
                      current is IgnoreUserLoading ||
                      current is IgnoreUserFailure ||
                      current is IgnoreUserSuccess,
                  listenWhen: (context, current) =>
                      current is IgnoreUserLoading ||
                      current is IgnoreUserFailure ||
                      current is IgnoreUserSuccess,
                  listener: (context, state) {
                    if (state is IgnoreUserLoading) {
                      loadingDialog(context);
                    } else if (state is IgnoreUserFailure) {
                      context.pop();
                      errorDialog(context: context, error: state.error);
                    } else if (state is IgnoreUserSuccess) {
                      context.pop();
                      successDialog(
                          context: context,
                          message:
                              state.profileDetailsActionResponseModel.message ??
                                  'تم التجاهل',
                          onPressed: () {
                            context.pop();
                          });
                    }
                  },
                  builder: (context, state) {
                    return CustomContainer(
                      img: AppImages.thumbDown,
                      color: AppColors.lightPink.withValues(alpha: 0.07),
                      text: 'تجاهل',
                      onTap: () {
                        context.read<ProfileDetailsCubit>().ignoreUser("3");
                      },
                    );
                  },
                ),
                CustomContainer(
                  img: AppImages.message,
                  color: AppColors.orangeLight.withValues(alpha: 0.07),
                  text: 'رسائل',
                ),
                CustomContainer(
                  img: AppImages.block,
                  color: AppColors.lightRed.withValues(alpha: 0.07),
                  text: 'ابلاغ',
                ),
              ],
            ),
            verticalSpace(40),
            ProfileDetailsCard(
              cardTitle: 'تاريخ السجل',
              cardContent: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...logHistory.map((item) {
                    return ProfileDetailsCardItem(
                        itemTitle: item['title'],
                        itemSubTitle: item['subTitle']);
                  }),
                  verticalSpace(11),
                ],
              ),
            ),
            verticalSpace(27),
            ProfileDetailsCard(
              cardTitle: 'المعلومات',
              cardContent: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...information.map((item) {
                    return ProfileDetailsCardItem(
                        itemTitle: item['title'],
                        itemSubTitle: item['subTitle']);
                  }),
                  verticalSpace(11),
                ],
              ),
            ),
            verticalSpace(16),
            ProfileDetailsCard(
              cardTitle: 'موصفات زوجي المستقبلي',
              cardContent: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  'يكون بيصلي وعارف ربنا ويراعي ربنا في ولادي ويكون ححنين',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font18GreyRegularLamaSans
                      .copyWith(fontFamily: FontFamilyHelper.plexSansArabic),
                ),
              ),
            ),
            verticalSpace(16),
            ProfileDetailsCard(
              cardTitle: 'موصفاتي انا',
              cardContent: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  'إنسانة ناضجة الى حد كبير مهتمة ببناء العلاقات حقيقة وببني بيت امن وسكينة بالحب',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font18GreyRegularLamaSans
                      .copyWith(fontFamily: FontFamilyHelper.plexSansArabic),
                ),
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
