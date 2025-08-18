import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/view/widgets/excellence_package_item.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/font_weight_helper.dart';
import '../../../../payment_methods/presentation/view/payment_methods.dart';
import '../../../../widgets/profile_header.dart';

class ExcellencePackageBody extends StatelessWidget {
  ExcellencePackageBody({super.key});

  final List items = [
    {
      'title': 'باقة التميز ',
      'subTitle':
          'مجموعة من الخدمات و الخصائص المميزة ، تزيد من فعاليتك في تطبيق عبر عرض ملفك بشكل أفضل ونشره بشكل أوسع لتحقيق هدفك بشكل أسرع'
    },
    {
      'title': 'تعزيز ملف الشخصي ',
      'subTitle':
          'سنعرض حسابك بطريقة فريدة ومميزة ، و نضعه في أعلى جميع القوائم وقبل أعضاء آخرين، ستلاحظ زيادة كبيرة في مشاهدات ملفك الشخصي وتفاعل أكبر في التطبيق'
    },
    {
      'title': 'تغيير أسم الملف المستخدم الخاص بك ',
      'subTitle': 'لديك الخيار لتغيير اسم المستخدم إلى أي اسم ترغب فيه '
    },
    {
      'title': 'إعدادات إستقبال الرسائل',
      'subTitle':
          'ستتمكن من تحديد البلدان التي تريد استقبال الرسائل منها واستعباد باقي البلدان'
    },
    {
      'title': 'تمكين وضع التصفح الخفي ',
      'subTitle':
          'يمكنك استخدام التطبيق في وضع التصفح الخفي ، حيث ستظهر غير متصل ولا يتم عرض تواجدك لأعضاء الآخرين'
    },
    {
      'title': 'قائمة الأعضاء المميزين',
      'subTitle':
          'سيتم عرض ملفك الشخصي على صفحة الأعضاء المميزين ، التي تلقي زيارات كثيرة من أغضاء الصادقون و الصادقات'
    },
    {
      'title': 'تحقيق من دولة الإقامة الفعلية لأعضاء',
      'subTitle':
          'مع هذه الميزة، سنكشف عن دولة الإقامة الفعلية لأي عضو/عضوة بناء على عنوان IP الخاص به ، بدلا من البلد الذي قام بإدراجه في ملف الشخصي'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: TextDirection.rtl,
          children: [
            ProfileHeader(title: 'باقـــة التميــــز'),
            verticalSpace(42),
            Container(
              padding: EdgeInsets.only(
                left: 14.w,
                right: 14.w,
                top: 24.h,
                bottom: 19.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.lightWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'يمكنك الآن الإشتراك من خلال رصيد الجوال عبر وكيلنا المعتمد اتصل اللآن',
                    style: AppTextStyles.font18JetMediumLamaSans,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(24),
                  SizedBox(
                    width: 186.w,
                    child: CustomElevatedButton(
                      height: 41.h,
                      onPressed: () {},
                      textButton: 'اتصل الآن',
                      radius: 100,
                      verticalPadding: 13,
                    ),
                  ),
                  verticalSpace(10),
                  Text(
                    'أو استفسر عبر رسالة قصيرة',
                    style: AppTextStyles.font15BistreSemiBoldLamaSans.copyWith(
                      color: AppColors.jet,
                      fontWeight: FontWeightHelper.medium,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.jet,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(32),
            Center(
              child: Text(
                'المزايـــــا',
                style: AppTextStyles.font22BistreSemiBoldLamaSans.copyWith(
                  color: AppColors.jet,
                  fontWeight: FontWeightHelper.medium,
                ),
              ),
            ),
            verticalSpace(33),
            Column(
              children: List.generate(
                items.length,
                (item) {
                  final card = items[item];
                  return ExcellencePackageItem(
                      title: card['title'], subTitle: card['subTitle']);
                },
              ),
            ),
            verticalSpace(32),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 10.5.h,
                bottom: 10.5.h,
                left: 8.w,
              ),
              decoration: BoxDecoration(color: AppColors.lightWhite),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Image.asset(
                    AppImages.boldStar,
                    width: 32.w,
                    height: 32.h,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Text(
                    'إمتيازاتـــي الحاليـــة',
                    style: AppTextStyles.font21PhilippineBronzeMediumLamaSans,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.profileMyExcellenceScreen);
                    },
                    child: Image.asset(
                      AppImages.leftArrow,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(32),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 25.h, bottom: 40.h, left: 8.w, right: 8.w),
              decoration: BoxDecoration(color: AppColors.lightWhite),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                textDirection: TextDirection.rtl,
                children: [
                  Center(
                    child: Text(
                      'الأسعار',
                      style: AppTextStyles.font18JetMediumLamaSans
                          .copyWith(fontSize: 23.sp),
                    ),
                  ),
                  verticalSpace(19),
                  priceItem('الإشتراك شهر واحد بــ 350 ريـــال'),
                  verticalSpace(5),
                  priceItem('الإشتراك 3 أشهر بـــــ 650 ريال'),
                  verticalSpace(5),
                  priceItem('الإشتراك 6 أشهر بـــــ 950 ريال'),
                  verticalSpace(5),
                  priceItem('الإشتراك عام واحد بـــــ 1500 ريال'),
                  verticalSpace(32),
                  Center(
                    child: Text(
                      'طرق الدفع',
                      style: AppTextStyles.font18JetMediumLamaSans
                          .copyWith(fontSize: 23.sp),
                    ),
                  ),
                  verticalSpace(15),
                  CustomElevatedButton(
                    height: 60,
                    onPressed: () {
                      showPaymentMethodsBottomSheet(context);
                    },
                    textButton: 'اشترك الان',
                    radius: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget priceItem(String price) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Image.asset(
          AppImages.boldStar,
          width: 32.w,
          height: 32.h,
        ),
        SizedBox(
          width: 18,
        ),
        Text(
          price,
          style: AppTextStyles.font19PhilippineBronzeRegularLamaSans,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
