import 'dart:developer';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/excellence_package/data/models/packages_model.dart'
    as packages_model;
import 'package:elsadeken/features/profile/my_excellence/presentation/view/widgets/my_excellence_item.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/spacing.dart';
import '../../../../payment_methods/presentation/view/payment_methods.dart';
import '../../../../widgets/profile_header.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/my_excellence/data/data_source/features_data_source.dart';
import 'package:elsadeken/features/profile/my_excellence/data/models/features_model.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/manager/packages_cubit/cubit/packages_cubit.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/manager/packages_cubit/cubit/packages_state.dart';

class MyExcellenceBody extends StatefulWidget {
  const MyExcellenceBody({super.key});

  @override
  State<MyExcellenceBody> createState() => _MyExcellenceBodyState();
}

class _MyExcellenceBodyState extends State<MyExcellenceBody> {
  bool isLoadingFeatures = true;
  bool isUserFeatured = false;
  List<Data> features = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load isFeatured status from SharedPreferences
    isUserFeatured =
        await SharedPreferencesHelper.getBool(SharedPreferencesKey.isFeatured);

    // Load features from API
    await _loadFeatures();

    setState(() {});
  }

  Future<void> _loadFeatures() async {
    try {
      setState(() {
        isLoadingFeatures = true;
        errorMessage = null;
      });

      final featuresDataSource = sl<FeaturesDataSource>();
      final featuresModel = await featuresDataSource.getFeatures();

      setState(() {
        features = featuresModel.data ?? [];
        isLoadingFeatures = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'فشل في تحميل الميزات: $e';
        isLoadingFeatures = false;
      });
      log('Error loading features: $e');
    }
  }

  Future<void> _handlePackageSelection(
      packages_model.Data selectedPackage) async {
    try {
      // Call API to assign package using PackagesCubit
      final packagesCubit = sl<PackagesCubit>();
      await packagesCubit.assignPackageToUser(selectedPackage.id.toString());

      // Update isFeatured status in SharedPreferences to true after successful subscription
      await SharedPreferencesHelper.setBool(
          SharedPreferencesKey.isFeatured, true);

      // Refresh the features to show updated status
      await _loadFeatures();
    } catch (e) {
      log('Error assigning package: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomProfileBody(
      contentBody: BlocProvider(
        create: (context) => sl<PackagesCubit>()..getPackages(),
        child: BlocListener<PackagesCubit, PackagesState>(
          listener: (context, state) {
            if (state is AssignPackageSuccess) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.response.message ?? 'تم الاشتراك بنجاح!',
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            } else if (state is AssignPackageFailure) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
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
                if (isLoadingFeatures) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: AppColors.beer,
                        ),
                      ),
                    ],
                  ),
                ] else if (errorMessage != null) ...[
                  Center(
                    child: Column(
                      children: [
                        Text(
                          errorMessage!,
                          style: AppTextStyles.font16BlackSemiBoldLamaSans
                              .copyWith(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(16),
                        ElevatedButton(
                          onPressed: _loadFeatures,
                          child: Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
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
                ],
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
                // Check isFeatured status from SharedPreferences
                if (isUserFeatured) ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: Text(
                        'أنت عضو مميز بالفعل',
                        style:
                            AppTextStyles.font16BlackSemiBoldLamaSans.copyWith(
                          color: AppColors.philippineBronze,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ] else ...[
                  BlocBuilder<PackagesCubit, PackagesState>(
                    builder: (context, packagesState) {
                      if (packagesState is GetPackagesSuccess) {
                        return CustomElevatedButton(
                          height: 66.h,
                          onPressed: () async {
                            if (packagesState.packages.data != null &&
                                packagesState.packages.data!.isNotEmpty) {
                              final result =
                                  await showPaymentMethodsBottomSheet(
                                context,
                                packages: packagesState.packages.data!,
                              );

                              if (result != null &&
                                  result["selectedPackage"] != null) {
                                final selected = result["selectedPackage"]
                                    as packages_model.Data;
                                await _handlePackageSelection(selected);
                              }
                            }
                          },
                          textButton: 'اشترك الان',
                          radius: 100,
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
