import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/localization_service.dart';
import '../helper/localization_helper.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocalizationService.instance,
      builder: (context, child) {
        final localizationService = LocalizationService.instance;
        final isArabic = localizationService.isArabic;

        return Container(
          padding: const EdgeInsets.symmetric( vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/images/icons/globe.png',width: 44.w, height: 44.h),
              SizedBox(width: 16.w,),
              Text(
                LocalizationHelper.getLocalizedText('اللغة', 'Language'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(8),
                  color: AppColors.lavenderBlush,

                ),
                child: Row(
                  children: [
                    _buildLanguageOption(
                      context,
                      'ع',
                      'AR',
                      'ar',
                      isArabic,
                      localizationService,
                    ),
                    const SizedBox(width: 4),
                    _buildLanguageOption(
                      context,
                      'EN',
                      'EN',
                      'en',
                      !isArabic,
                      localizationService,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String arabicText,
    String englishText,
    String languageCode,
    bool isSelected,
    LocalizationService localizationService,
  ) {
    return GestureDetector(
      onTap: () async {
        await localizationService.changeLocale(languageCode);
        // Show snackbar after language change
        if (context.mounted) {
          localizationService.showLanguageChangeSnackBar(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.philippineBronze : AppColors.lavenderBlush,
          borderRadius: BorderRadius.circular(15),

        ),
        child: Text(
          LocalizationHelper.getLocalizedText(arabicText, englishText),
          style: TextStyle(
            color: isSelected ? Colors.orangeAccent : Colors.orangeAccent,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
