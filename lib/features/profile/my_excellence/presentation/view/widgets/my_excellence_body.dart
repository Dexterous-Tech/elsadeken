import 'dart:developer';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/my_excellence/presentation/manager/feature_cubit/cubit/features_state.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/manager/packages_cubit/cubit/packages_state.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/manager/packages_cubit/cubit/packages_cubit.dart';
import 'package:elsadeken/features/profile/excellence_package/data/models/packages_model.dart';
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

  Future<void> _handlePackageSelection(
      BuildContext context, List<Data> packages) async {
    final result = await showPaymentMethodsBottomSheet(
      context,
      packages: packages,
    );

    if (result != null && result["selectedPackage"] != null) {
      final selected = result["selectedPackage"];
      // ignore: use_build_context_synchronously
      context.read<PackagesCubit>().assignPackageToUser(selected.id.toString());

      log("Selected Package: ${selected.name} - ${selected.price}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: BlocBuilder<FeaturesCubit, FeaturesState>(
        builder: (context, featuresState) {
          if (featuresState is GetFeaturesLoading) {
            log('Features loading');
            return const Center(child: CircularProgressIndicator());
          } else if (featuresState is GetFeaturesFailure) {
            log('Features Failed');
            return Center(child: Text(featuresState.error));
          } else if (featuresState is GetFeaturesSuccess) {
            log('Features loaded successfully');
            final features = featuresState.featuresModel.data ?? [];

            // Check if user has any active features (indicating active subscription)
            final hasActiveSubscription =
                features.any((feature) => (feature.active ?? 0) == 1);

            return BlocListener<PackagesCubit, PackagesState>(
              listener: (context, packagesState) {
                if (packagesState is AssignPackageSuccess) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        packagesState.response.message ?? 'تم الاشتراك بنجاح!',
                        textDirection: TextDirection.rtl,
                        style:
                            AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );

                  // Refresh features to update the UI
                  context.read<FeaturesCubit>().refreshFeatures();
                } else if (packagesState is AssignPackageFailure) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        packagesState.error,
                        textDirection: TextDirection.rtl,
                        style:
                            AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
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
                          final activeValue = feature.active ?? 0;

                          log("FEATURE: ${feature.feature} | ACTIVE: $activeValue | isCorrect: ${activeValue == 1}");

                          return MyExcellenceItem(
                            isCorrect: activeValue == 1,
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
                    BlocBuilder<PackagesCubit, PackagesState>(
                      builder: (context, packagesState) {
                        if (packagesState is AssignPackageLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return CustomElevatedButton(
                          height: 66.h,
                          onPressed: hasActiveSubscription
                              ? () {} // Disable button if already subscribed
                              : () {
                                  if (packagesState is GetPackagesSuccess &&
                                      packagesState.packages.data != null) {
                                    _handlePackageSelection(
                                        context, packagesState.packages.data!);
                                  }
                                },
                          textButton: hasActiveSubscription
                              ? 'لديك اشتراك نشط'
                              : 'اشترك الان',
                          radius: 100,
                        );
                      },
                    ),
                    if (hasActiveSubscription) ...[
                      verticalSpace(16),
                      Center(
                        child: Text(
                          'لا يمكن الاشتراك في باقة أخرى أثناء وجود اشتراك نشط',
                          style:
                              AppTextStyles.font14JetRegularLamaSans.copyWith(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
