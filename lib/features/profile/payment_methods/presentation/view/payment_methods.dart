import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_text_styles.dart';

class PaymentMethodsBottomSheet extends StatefulWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  State<PaymentMethodsBottomSheet> createState() =>
      _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  int? selectedOption;

  final List<Map<String, dynamic>> subscriptionOptions = [
    {
      'title': 'شهر واحد',
      'duration': '1',
      'price': '246.99',
      'currency': 'جنيه',
    },
    {
      'title': '3 اشهر',
      'duration': '3',
      'price': '246.99',
      'currency': 'جنيه',
    },
    {
      'title': '6 اشهر',
      'duration': '6',
      'price': '246.99',
      'currency': 'جنيه',
    },
    {
      'title': 'عام واحد',
      'duration': '12',
      'price': '246.99',
      'currency': 'جنيه',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 31.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: subscriptionOptions.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = index;
                    });
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalSpace(24),
                        Text(
                          '${option['title']} - ${option['price']} ${option['currency']}',
                          style: AppTextStyles.font18BabyBlueRegularLamaSans,
                          textDirection: TextDirection.rtl,
                        ),
                        verticalSpace(24),
                        index == 3
                            ? SizedBox.shrink()
                            : Container(
                                width: double.infinity,
                                height: 0.5,
                                color: AppColors.grey,
                              ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          verticalSpace(10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Text(
                  'الغاء',
                  style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
                    fontWeight: FontWeightHelper.bold,
                    color: AppColors.vividRed,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to show the bottom sheet
Future<Map<String, dynamic>?> showPaymentMethodsBottomSheet(
    BuildContext context) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const PaymentMethodsBottomSheet(),
  );
}
