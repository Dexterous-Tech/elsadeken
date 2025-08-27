import 'dart:developer';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/my_excellence/presentation/manager/feature_cubit/cubit/features_state.dart';
import 'package:elsadeken/features/profile/my_excellence/presentation/view/widgets/my_excellence_item.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../payment_methods/presentation/view/payment_methods.dart';
import '../../../../widgets/profile_header.dart';
import '../../manager/feature_cubit/cubit/features_cubit.dart';

class MyExcellenceBody extends StatelessWidget {
  const MyExcellenceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: BlocBuilder<FeaturesCubit, FeaturesState>(
        builder: (context, state) {
          if (state is GetFeaturesLoading) {
            log('Features loading');

            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFeaturesFailure) {
            log('Features Failed');

            return Center(child: Text(state.error));
          } else if (state is GetFeaturesSuccess) {
            log('Features loaded successfully');
            final features = state.featuresModel.data ?? [];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                textDirection: TextDirection.rtl,
                children: [
                  ProfileHeader(title: 'باقـــة التميــــز'),
                  verticalSpace(42),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      features.length,
                      (index) {
                        final feature = features[index];
                        return MyExcellenceItem(
                          isCorrect: feature.active == 1, 
                          title: feature.feature ?? "",
                        );
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
                    height: 66.h,
                    onPressed: () {
                      showPaymentMethodsBottomSheet(context);
                    },
                    textButton: 'اشترك الان',
                    radius: 100,
                  )
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
