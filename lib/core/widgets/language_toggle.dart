import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocalizationHelper.getLocalizedText('اللغة', 'Lang'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              _buildLanguageOption(
                context,
                'عربي',
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
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          LocalizationHelper.getLocalizedText(arabicText, englishText),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
