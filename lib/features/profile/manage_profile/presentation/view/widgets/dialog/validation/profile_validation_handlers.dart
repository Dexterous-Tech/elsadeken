import 'package:elsadeken/features/profile/manage_profile/presentation/view/widgets/dialog/manage_profile_dialog.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({required this.isValid, this.errorMessage});
}

/// Base class for all validation handlers
abstract class ProfileValidationHandler {
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  );
}

/// Validation handler for login data
class LoginDataValidationHandler extends ProfileValidationHandler {
  @override
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) {
    final name =
        controllers[AppLocalizations.of(context)!.username]?.text ?? '';
    final email = controllers[AppLocalizations.of(context)!.email]?.text ?? '';
    final phone =
        controllers[AppLocalizations.of(context)!.phoneNumber]?.text ?? '';
    final password =
        controllers[AppLocalizations.of(context)!.passwordOptional]?.text ?? '';
    final passwordConfirmation =
        controllers[AppLocalizations.of(context)!.confirmPasswordOptional]
                ?.text ??
            '';

    // Validate name
    if (name.trim().length < 2) {
      return ValidationResult(
        isValid: false,
        errorMessage: AppLocalizations.of(context)!.usernameMinLength,
      );
    }

    if (name.trim().length > 50) {
      return ValidationResult(
        isValid: false,
        errorMessage: AppLocalizations.of(context)!.usernameMaxLength,
      );
    }

    // Validate email
    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email.trim())) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.pleaseEnterValidEmail,
        );
      }
    }

    // Validate phone
    if (phone.isNotEmpty) {
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanPhone.length < 8 || cleanPhone.length > 15) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.phoneNumberLength,
        );
      }
    }

    // Validate password if provided
    if (password.isNotEmpty) {
      if (passwordConfirmation.isEmpty) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.pleaseConfirmPassword,
        );
      }

      if (password != passwordConfirmation) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.passwordsDoNotMatch,
        );
      }

      if (password.length < 6) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.passwordMinLength,
        );
      }

      final hasNumber = RegExp(r'[0-9]').hasMatch(password);
      final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
      if (!hasNumber && !hasSymbol) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.passwordNumberOrSymbol,
        );
      }

      final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
      if (!hasUppercase || !hasLowercase) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.passwordCase,
        );
      }
    }

    return ValidationResult(isValid: true);
  }
}

/// Validation handler for job data
class JobDataValidationHandler extends ProfileValidationHandler {
  @override
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) {
    // Income is now a dropdown selection, so no specific validation needed
    // The dropdown selection itself ensures a valid income option is chosen
    // Any additional validation would be handled by the dropdown field requirements

    return ValidationResult(isValid: true);
  }
}

/// Validation handler for social status data
class SocialStatusValidationHandler extends ProfileValidationHandler {
  @override
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) {
    final ageStr = controllers[AppLocalizations.of(context)!.age]?.text ?? '';
    final childrenStr =
        controllers[AppLocalizations.of(context)!.numberOfChildren]?.text ?? '';

    // Validate age
    if (ageStr.isNotEmpty) {
      final age = int.tryParse(ageStr);
      if (age == null) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.pleaseEnterValidAge,
        );
      }
      if (age > 99 || age < 18) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.ageRange,
        );
      }
    }

    // Validate children number
    if (childrenStr.isNotEmpty) {
      final children = int.tryParse(childrenStr);
      if (children == null) {
        return ValidationResult(
          isValid: false,
          errorMessage:
              AppLocalizations.of(context)!.pleaseEnterValidChildrenCount,
        );
      }
      if (children > 99 || children < 0) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.childrenRange,
        );
      }
    }

    return ValidationResult(isValid: true);
  }
}

/// Validation handler for body info data
class BodyInfoValidationHandler extends ProfileValidationHandler {
  @override
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) {
    final weightStr =
        controllers[AppLocalizations.of(context)!.weight]?.text ?? '';
    final heightStr =
        controllers[AppLocalizations.of(context)!.height]?.text ?? '';

    // Validate weight
    if (weightStr.isNotEmpty) {
      final weight = int.tryParse(weightStr);
      if (weight == null) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.pleaseEnterValidWeight,
        );
      }
      if (weight > 300 || weight < 30) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.weightRange,
        );
      }
    }

    // Validate height
    if (heightStr.isNotEmpty) {
      final height = int.tryParse(heightStr);
      if (height == null) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.pleaseEnterValidHeight,
        );
      }
      if (height > 250 || height < 50) {
        return ValidationResult(
          isValid: false,
          errorMessage: AppLocalizations.of(context)!.heightRange,
        );
      }
    }

    return ValidationResult(isValid: true);
  }
}

/// Validation handler for national country data
class NationalCountryValidationHandler extends ProfileValidationHandler {
  final Map<String, List<dynamic>> dataLists;

  NationalCountryValidationHandler({required this.dataLists});

  @override
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) {
    final nationalityName =
        controllers[AppLocalizations.of(context)!.nationality]?.text ?? '';
    final countryName =
        controllers[AppLocalizations.of(context)!.country]?.text ?? '';
    final cityName =
        controllers[AppLocalizations.of(context)!.city]?.text ?? '';

    // Check if all required fields are selected
    if (nationalityName.isEmpty || countryName.isEmpty || cityName.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage:
            AppLocalizations.of(context)!.pleaseSelectAllRequiredFields,
      );
    }

    return ValidationResult(isValid: true);
  }
}

/// Validation handler for religious data
class ReligionValidationHandler extends ProfileValidationHandler {
  @override
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) {
    // Religious data doesn't require specific validation
    // All fields are optional dropdowns
    return ValidationResult(isValid: true);
  }
}

/// Validation handler for descriptions (about me and about partner)
class DescriptionsValidationHandler extends ProfileValidationHandler {
  @override
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) {
    // Descriptions are optional text fields
    // No specific validation required
    return ValidationResult(isValid: true);
  }
}

/// Validation handler for education data
class EducationValidationHandler extends ProfileValidationHandler {
  @override
  ValidationResult validate(
    Map<String, TextEditingController> controllers,
    BuildContext context,
  ) {
    // Education data validation can be added here if needed
    // For now, all fields are optional
    return ValidationResult(isValid: true);
  }
}

/// Factory class to get the appropriate validation handler
class ProfileValidationHandlerFactory {
  static ProfileValidationHandler getHandler(
      ManageProfileDialogType? dialogType,
      {Map<String, List<dynamic>>? dataLists}) {
    switch (dialogType) {
      case ManageProfileDialogType.loginData:
        return LoginDataValidationHandler();
      case ManageProfileDialogType.nationalCountry:
        return NationalCountryValidationHandler(dataLists: dataLists ?? {});
      case ManageProfileDialogType.job:
        return JobDataValidationHandler();
      case ManageProfileDialogType.socialStatus:
        return SocialStatusValidationHandler();
      case ManageProfileDialogType.bodyInfo:
        return BodyInfoValidationHandler();
      case ManageProfileDialogType.religion:
        return ReligionValidationHandler();
      case ManageProfileDialogType.descriptions:
        return DescriptionsValidationHandler();
      case ManageProfileDialogType.education:
        return EducationValidationHandler();
      case ManageProfileDialogType.personalInfo:
        return DescriptionsValidationHandler(); // Personal info uses descriptions validation
      default:
        return DescriptionsValidationHandler(); // Default fallback - no validation
    }
  }
}
