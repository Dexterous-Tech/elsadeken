class SharedPreferencesKey {
  static const String apiTokenKey = 'API_TOKEN_KEY';
  static const String verificationTokenKey = 'VERIFICATION_TOKEN_KEY';
  static const String userDataKey = 'USER_DATA_KEY';
  static const String userImageKey = 'USER_IMAGE_KEY';
  static const String deviceToken = 'DEVICE_TOKEN';
  static const String isFeatured = 'IS_FEATURED';
  static const String isNotifable = 'IS_NOTIFABLE';
  static const String isBlocked = 'IS_BLOCKED';
  static const String gender = 'GENDER';
  static const String privacySetting = 'PRIVACY_SETTING';

  // App state management keys
  static const String isOnboardingCompleted = 'IS_ONBOARDING_COMPLETED';
  static const String isLoggedIn = 'IS_LOGGED_IN';

  // Cache keys for static data
  static const String nationalitiesCacheKey = 'NATIONALITIES_CACHE';
  static const String countriesCacheKey = 'COUNTRIES_CACHE';
  static const String nationalitiesCacheTimestampKey =
      'NATIONALITIES_CACHE_TIMESTAMP';
  static const String countriesCacheTimestampKey = 'COUNTRIES_CACHE_TIMESTAMP';

  // Signup form data keys
  static const String signupFormDataKey = 'SIGNUP_FORM_DATA';
  static const String signupCurrentStepKey = 'SIGNUP_CURRENT_STEP';
  static const String signupGenderKey = 'SIGNUP_GENDER';
  static const String signupTimestampKey = 'SIGNUP_TIMESTAMP';
  static const String isSingleKey = 'IS_SINGLE';
}
