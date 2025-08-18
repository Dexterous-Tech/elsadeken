import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/my_excellence/presentation/view/widgets/my_excellence_item.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../payment_methods/presentation/view/payment_methods.dart';
import '../../../../widgets/profile_header.dart';

class MyExcellenceBody extends StatelessWidget {
  const MyExcellenceBody({super.key});

  @override
  Widget build(BuildContext context) {
    final List items = [
      {
        'title': 'تلقي الرسائل',
        'isCorrect': true,
      },
      {
        'title': 'إرسال رسائل إلى أي عضو',
        'isCorrect': false,
      },
      {
        'title': 'التحكم في من يمكنهم إرسال رسائل لك',
        'isCorrect': false,
      },
      {
        'title': 'البحث و عرض الملفات الشخصية لأعضاء',
        'isCorrect': true,
      },
      {
        'title': 'عرض قوائم الأعضاء المتواجدون / الجدد /المتميزين',
        'isCorrect': true,
      },
      {
        'title': 'عرض ملفك بشكل مميز عن باقي الأعضاء',
        'isCorrect': false,
      },
      {
        'title': 'تحديث ملفك الشخصي',
        'isCorrect': true,
      },
      {
        'title': 'تعديل إسم المستخدم الخاص بك',
        'isCorrect': false,
      },
      {
        'title': 'دخول مختفي',
        'isCorrect': false,
      },
      {
        'title': 'التحقق من بلد العضو',
        'isCorrect': false,
      },
      {
        'title': 'تحميل صورتك',
        'isCorrect': true,
      },
      {
        'title': 'رؤية الصور العامة لأعضاء',
        'isCorrect': false,
      },
      {
        'title': 'حذف الإعلانات',
        'isCorrect': false,
      },
    ];
    return CustomProfileBody(
      contentBody: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: TextDirection.rtl,
          children: [
            ProfileHeader(title: 'باقـــة التميــــز'),
            verticalSpace(42),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                items.length,
                (index) {
                  var item = items[index];
                  return MyExcellenceItem(
                      isCorrect: item['isCorrect'], title: item['title']);
                },
              ),
            ),
            verticalSpace(15),
            Center(
              child: Text(
                'باقـــة التميــــز',
                style: AppTextStyles.font20LightOrangeMediumLamaSans,
              ),
            ),
            verticalSpace(16),
            Text(
              'عند الأشتراك في باقة التميز ، ستقوم بتفعيل جميع الميزات المتاحة و بالتالي زيادة تفاعلك في التطبيق و تحقيق هدفك بشكل أسرع',
              style: AppTextStyles.font19JetRegularLamaSans,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            verticalSpace(32),
            CustomElevatedButton(
              onPressed: () {
                showPaymentMethodsBottomSheet(context);
              },
              textButton: 'اشترك الان',
              radius: 100,
            )
          ],
        ),
      ),
    );
  }
}
