import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/like_user_cubit.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/like_user_state.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/custom_container.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card_item.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_logo.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

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
              spacing: 37.75,
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomContainer(
                  img: AppImages.share,
                  color: AppColors.lightBlue.withOpacity(0.07),
                  text: 'مشاركة',
                ),
                BlocBuilder<LikeUserCubit, LikeUserState>(
                  buildWhen: (previous, current) =>
                      current is LikeUserLoading ||
                      current is LikeUserFailure ||
                      current is LikeUserSuccess,
                  builder: (context, state) {
                    if (state is LikeUserFailure) {
                      return Expanded(
                          child: Center(
                        child: Text(
                          state.error,
                          style: AppTextStyles.font20LightOrangeMediumPlexSans
                              .copyWith(color: AppColors.red),
                        ),
                      ));
                    } else {
                      return CustomContainer(
                        img: AppImages.like,
                        color: AppColors.lightPink.withOpacity(0.07),
                        text: 'اهتمام',
                        onTap: () {
                          context.read<LikeUserCubit>().likeUser("3");
                        },
                      );
                    }
                  },
                ),
                CustomContainer(
                  img: AppImages.thumbDown,
                  color: AppColors.lightPink.withOpacity(0.07),
                  text: 'تجاهل',
                ),
                CustomContainer(
                  img: AppImages.message,
                  color: AppColors.orangeLight.withOpacity(0.07),
                  text: 'رسائل',
                ),
                CustomContainer(
                  img: AppImages.block,
                  color: AppColors.lightRed.withOpacity(0.07),
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
