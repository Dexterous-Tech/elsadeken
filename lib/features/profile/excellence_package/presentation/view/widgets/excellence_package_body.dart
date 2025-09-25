import 'dart:developer';

import 'package:elsadeken/core/helper/app_images.dart';
import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/routes/app_routes.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_elevated_button.dart';
import 'package:elsadeken/features/profile/excellence_package/data/models/packages_model.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/view/widgets/excellence_package_item.dart';
import 'package:elsadeken/features/profile/widgets/custom_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

import '../../../../../../core/services/localization_service.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/font_weight_helper.dart';
import '../../../../payment_methods/presentation/view/payment_methods.dart';
import '../../../../widgets/profile_header.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/manager/packages_cubit/cubit/packages_cubit.dart';
import 'package:elsadeken/features/profile/excellence_package/presentation/manager/packages_cubit/cubit/packages_state.dart';

class ExcellencePackageBody extends StatefulWidget {
  ExcellencePackageBody({super.key});

  @override
  State<ExcellencePackageBody> createState() => _ExcellencePackageBodyState();
}

class _ExcellencePackageBodyState extends State<ExcellencePackageBody> {
  bool isUserFeatured = false;

  List<Map<String, String>> getItems(BuildContext context) {
    return [
      {
        'title': AppLocalizations.of(context)!.excellencePackageTitle,
        'subTitle': AppLocalizations.of(context)!.packageDescription,
      },
      {
        'title': AppLocalizations.of(context)!.enhanceProfile,
        'subTitle': AppLocalizations.of(context)!.enhanceProfileDescription,
      },
      {
        'title': AppLocalizations.of(context)!.changeUsername,
        'subTitle': AppLocalizations.of(context)!.changeUsernameDescription,
      },
      {
        'title': AppLocalizations.of(context)!.messageSettings,
        'subTitle': AppLocalizations.of(context)!.messageSettingsDescription,
      },
      {
        'title': AppLocalizations.of(context)!.invisibleMode,
        'subTitle': AppLocalizations.of(context)!.invisibleModeDescription,
      },
      {
        'title': AppLocalizations.of(context)!.premiumMembersList,
        'subTitle': AppLocalizations.of(context)!.premiumMembersListDescription,
      },
      {
        'title': AppLocalizations.of(context)!.locationVerification,
        'subTitle':
            AppLocalizations.of(context)!.locationVerificationDescription,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load isFeatured status from SharedPreferences
    isUserFeatured =
        await SharedPreferencesHelper.getBool(SharedPreferencesKey.isFeatured);

    setState(() {});
  }

  Future<void> _handlePackageSelection(Data selectedPackage) async {
    try {
      // Call API to assign package using PackagesCubit
      final packagesCubit = sl<PackagesCubit>();
      await packagesCubit.assignPackageToUser(selectedPackage.id.toString());

      // Update isFeatured status in SharedPreferences to true after successful subscription
      await SharedPreferencesHelper.setBool(
          SharedPreferencesKey.isFeatured, true);

      // Refresh the UI
      await _loadData();
    } catch (e) {
      log('Error assigning package: $e');
    }
  }

  Widget _buildPriceItem({
    required String price,
    required String name,
    required String month,
  }) {
    return Row(
      textDirection: LocalizationService.instance.textDirection,
      children: [
        Image.asset(
          AppImages.boldStar,
          width: 32.w,
          height: 32.h,
        ),
        Text(
          name,
          style: AppTextStyles.font19PhilippineBronzeRegularLamaSans
              .copyWith(fontSize: 17.sp),
          textDirection: TextDirection.rtl,
        ),
        Text(
          " $month ",
          style: AppTextStyles.font19PhilippineBronzeRegularLamaSans
              .copyWith(fontSize: 17.sp),
          textDirection: TextDirection.rtl,
        ),
        Text(
          " $price ",
          style: AppTextStyles.font19PhilippineBronzeRegularLamaSans
              .copyWith(fontSize: 17.sp),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext _context) {
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
                    state.response.message ??
                        AppLocalizations.of(context)!.registrationSuccessful,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: LocalizationService.instance.textDirection,
              children: [
                ProfileHeader(
                    title:
                        AppLocalizations.of(_context)!.excellencePackageTitle),
                verticalSpace(42),
                Center(
                  child: Text(
                    AppLocalizations.of(_context)!.benefits,
                    style: AppTextStyles.font22BistreSemiBoldLamaSans.copyWith(
                      color: AppColors.jet,
                      fontWeight: FontWeightHelper.medium,
                    ),
                    textDirection: LocalizationService.instance.textDirection,
                    textAlign: LocalizationService.instance.textAlignment,
                  ),
                ),
                verticalSpace(33),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: LocalizationService.instance.textDirection,
                  children: List.generate(getItems(_context).length, (item) {
                    final card = getItems(_context)[item];
                    return ExcellencePackageItem(
                      title: card['title']!,
                      subTitle: card['subTitle']!,
                    );
                  }),
                ),
                verticalSpace(32),
                GestureDetector(
                  onTap: () {
                    _context.pushNamed(AppRoutes.profileMyExcellenceScreen);
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.only(top: 10.5.h, bottom: 10.5.h, left: 8.w),
                    decoration: BoxDecoration(color: AppColors.lightWhite),
                    child: Row(
                      textDirection: LocalizationService.instance.textDirection,
                      children: [
                        Image.asset(AppImages.boldStar,
                            width: 32.w, height: 32.h),
                        SizedBox(width: 18),
                        Text(
                          AppLocalizations.of(_context)!.currentBenefits,
                          style: AppTextStyles
                              .font21PhilippineBronzeMediumLamaSans,
                          textDirection:
                              LocalizationService.instance.textDirection,
                          textAlign: LocalizationService.instance.textAlignment,
                        ),
                        Spacer(),
                        Transform.rotate(
                          angle:
                              LocalizationService.instance.isArabic ? 0 : 3.14,
                          child: Image.asset(
                            AppImages.leftArrow,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(32),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 25.h,
                    bottom: 40.h,
                    left: 8.w,
                    right: 8.w,
                  ),
                  decoration: BoxDecoration(color: AppColors.lightWhite),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: LocalizationService.instance.textDirection,
                    children: [
                      Center(
                        child: Text(
                          AppLocalizations.of(_context)!.prices,
                          style: AppTextStyles.font18JetMediumLamaSans.copyWith(
                            fontSize: 23.sp,
                          ),
                          textDirection:
                              LocalizationService.instance.textDirection,
                          textAlign: LocalizationService.instance.textAlignment,
                        ),
                      ),
                      verticalSpace(19),
                      BlocBuilder<PackagesCubit, PackagesState>(
                        buildWhen: (context, state) =>
                            state is GetPackagesLoading ||
                            state is GetPackagesSuccess ||
                            state is GetPackagesFailure,
                        builder: (context, state) {
                          if (state is GetPackagesLoading) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: AppColors.beer,
                            ));
                          } else if (state is GetPackagesSuccess) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textDirection:
                                  LocalizationService.instance.textDirection,
                              children: state.packages.data!
                                  .map(
                                    (package) => Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: _buildPriceItem(
                                        name: package.name ?? '',
                                        month:
                                            "${package.countMonths} ${AppLocalizations.of(context)!.months}",
                                        price:
                                            "${AppLocalizations.of(context)!.forText} ${package.price} ${AppLocalizations.of(context)!.currency}",
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          } else if (state is GetPackagesFailure) {
                            return Center(
                              child: Text(
                                AppLocalizations.of(context)!.failedToLoadData,
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      verticalSpace(32),
                      Center(
                        child: Text(
                          AppLocalizations.of(_context)!.paymentMethods,
                          style: AppTextStyles.font18JetMediumLamaSans.copyWith(
                            fontSize: 23.sp,
                          ),
                          textDirection:
                              LocalizationService.instance.textDirection,
                          textAlign: LocalizationService.instance.textAlignment,
                        ),
                      ),
                      verticalSpace(15),
                      // Check isFeatured status from SharedPreferences
                      if (isUserFeatured) ...[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(_context)!
                                  .youAreAlreadyPremium,
                              style: AppTextStyles.font16BlackSemiBoldLamaSans
                                  .copyWith(
                                color: AppColors.philippineBronze,
                              ),
                              textAlign: TextAlign.center,
                              textDirection:
                                  LocalizationService.instance.textDirection,
                            ),
                          ),
                        ),
                      ] else ...[
                        BlocBuilder<PackagesCubit, PackagesState>(
                          builder: (context, packagesState) {
                            if (packagesState is GetPackagesSuccess) {
                              return CustomElevatedButton(
                                height: 60,
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
                                      final selected =
                                          result["selectedPackage"] as Data;
                                      await _handlePackageSelection(selected);
                                    }
                                  }
                                },
                                textButton:
                                    AppLocalizations.of(context)!.subscribeNow,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
