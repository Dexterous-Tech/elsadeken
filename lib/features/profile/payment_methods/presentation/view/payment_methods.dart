import 'package:elsadeken/core/helper/extensions.dart';
import 'package:elsadeken/core/services/localization_service.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/features/profile/excellence_package/data/models/packages_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/l10n/app_localizations.dart';

class PaymentMethodsBottomSheet extends StatefulWidget {
  final List<Data>? packages;

  const PaymentMethodsBottomSheet({
    super.key,
    this.packages,
  });

  @override
  State<PaymentMethodsBottomSheet> createState() =>
      _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  int? selectedOption;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 31.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: LocalizationService.instance.textDirection,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: widget.packages != null && widget.packages!.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: LocalizationService.instance.textDirection,
                    children: widget.packages!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final package = entry.value;

                      return GestureDetector(
                        onTap: isProcessing
                            ? null
                            : () async {
                                setState(() {
                                  selectedOption = index;
                                  isProcessing = true;
                                });

                                try {
                                  // Store context and localizations before async operations
                                  final currentContext = context;
                                  final localizations =
                                      AppLocalizations.of(currentContext)!;

                                  // TODO: Call API to assign package
                                  // For now, we'll simulate API call
                                  await Future.delayed(Duration(seconds: 2));

                                  // Update isFeatured status in SharedPreferences
                                  await SharedPreferencesHelper.setBool(
                                      SharedPreferencesKey.isFeatured, true);

                                  // Show success message
                                  if (mounted) {
                                    ScaffoldMessenger.of(currentContext)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          localizations
                                              .packageAddedSuccessfully,
                                          textDirection: LocalizationService
                                              .instance.textDirection,
                                          style: AppTextStyles
                                              .font16BlackSemiBoldLamaSans
                                              .copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: AppColors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }

                                  // Close bottom sheet and return selected package
                                  if (mounted) {
                                    Navigator.of(currentContext).pop({
                                      "selectedPackage": package,
                                    });
                                  }
                                } catch (e) {
                                  // Store context and localizations before async operations
                                  final currentContext = context;
                                  final localizations =
                                      AppLocalizations.of(currentContext)!;

                                  // Show error message
                                  if (mounted) {
                                    ScaffoldMessenger.of(currentContext)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          localizations.errorAddingPackage,
                                          textDirection: LocalizationService
                                              .instance.textDirection,
                                          style: AppTextStyles
                                              .font16BlackSemiBoldLamaSans
                                              .copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isProcessing = false;
                                    });
                                  }
                                }
                              },
                        child: Container(
                          color: selectedOption == index
                              ? AppColors.lightWhite
                              : Colors.transparent,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textDirection:
                                  LocalizationService.instance.textDirection,
                              children: [
                                verticalSpace(24),
                                if (isProcessing &&
                                    selectedOption == index) ...[
                                  CircularProgressIndicator(),
                                  verticalSpace(16),
                                ],
                                Text(
                                  '${package.name ?? ''} ${AppLocalizations.of(context)!.inMonths} ${package.countMonths ?? 0} ${AppLocalizations.of(context)!.months} - ${package.price ?? 0} ${AppLocalizations.of(context)!.priceInCurrency}',
                                  style: AppTextStyles
                                      .font18BabyBlueRegularLamaSans,
                                  textDirection: LocalizationService
                                      .instance.textDirection,
                                  textAlign: LocalizationService
                                      .instance.textAlignment,
                                ),
                                verticalSpace(24),
                                index == widget.packages!.length - 1
                                    ? SizedBox.shrink()
                                    : Container(
                                        width: double.infinity,
                                        height: 0.5,
                                        color: AppColors.grey,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: LocalizationService.instance.textDirection,
                    children: [
                      verticalSpace(24),
                      Text(
                        AppLocalizations.of(context)!.noPackagesAvailable,
                        style: AppTextStyles.font18BabyBlueRegularLamaSans,
                        textDirection:
                            LocalizationService.instance.textDirection,
                        textAlign: LocalizationService.instance.textAlignment,
                      ),
                      verticalSpace(24),
                    ],
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
                onTap: isProcessing
                    ? null
                    : () {
                        context.pop();
                      },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
                    fontWeight: FontWeightHelper.bold,
                    color: AppColors.vividRed,
                  ),
                  textDirection: LocalizationService.instance.textDirection,
                  textAlign: LocalizationService.instance.textAlignment,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>?> showPaymentMethodsBottomSheet(
  BuildContext context, {
  List<Data>? packages,
}) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PaymentMethodsBottomSheet(packages: packages),
  );
}
