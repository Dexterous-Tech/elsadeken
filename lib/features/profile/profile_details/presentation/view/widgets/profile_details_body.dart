import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_family_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/custom_arrow_back.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_card_item.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/view/widgets/profile_details_logo.dart';
import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 22.w,
          vertical: 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            textDirection: TextDirection.ltr,
            children: [
              CustomArrowBack(),
              ProfileDetailsLogo(),
              verticalSpace(20),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: CustomElevatedButton(
                      onPressed: () {
                        context.pushNamed(AppRoutes.manageProfileScreen);
                      },
                      textButton: 'ادارة حساب',
                      radius: 100,
                      verticalPadding: 12,
                    ),
                  ),
                  horizontalSpace(16),
                  Flexible(
                    child: CustomElevatedButton(
                      onPressed: () {},
                      textButton: 'باقة التميز',
                      radius: 100,
                      backgroundColor: AppColors.sunray,
                      verticalPadding: 12,
                    ),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
      ),
    );
  }
}
