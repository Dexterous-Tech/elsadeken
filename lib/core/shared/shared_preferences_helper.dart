import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  SharedPreferencesHelper._();

  static final flutterSecureStorage = FlutterSecureStorage();

  /// Saves a [value] with a [key] in the FlutterSecureStorage.
  static Future<void> setSecuredString(String key, String value) async {
    debugPrint(
      "FlutterSecureStorage : setSecuredString with key : $key and value : $value",
    );
    await flutterSecureStorage.write(key: key, value: value);
  }

  /// Gets an String value from FlutterSecureStorage with given [key].
  static Future<String> getSecuredString(String key) async {
    debugPrint('FlutterSecureStorage : getSecuredString with key : $key');
    return await flutterSecureStorage.read(key: key) ?? '';
  }

  static Future<void> deleteSecuredString(String key) async {
    debugPrint("FlutterSecureStorage : deleteSecuredString with key : $key");
    await flutterSecureStorage.delete(key: key);
  }

  static Future<void> deleteSharedPreferKeys() async {
    await flutterSecureStorage.delete(key: SharedPreferencesKey.apiTokenKey);
    await flutterSecureStorage.delete(
        key: SharedPreferencesKey.verificationTokenKey);
    await flutterSecureStorage.delete(key: SharedPreferencesKey.isFeatured);
    await flutterSecureStorage.delete(key: SharedPreferencesKey.isNotifable);
    await flutterSecureStorage.delete(key: SharedPreferencesKey.isBlocked);
    await flutterSecureStorage.delete(key: SharedPreferencesKey.gender);
    await flutterSecureStorage.delete(key: SharedPreferencesKey.privacySetting);
    await flutterSecureStorage.delete(key: SharedPreferencesKey.deviceToken);
    await flutterSecureStorage.delete(key: SharedPreferencesKey.userDataKey);
  }

  /// Clear all app state data (for logout)
  static Future<void> clearAllAppState() async {
    await deleteSharedPreferKeys();
    await flutterSecureStorage.delete(key: SharedPreferencesKey.isLoggedIn);
    await flutterSecureStorage.delete(
        key: SharedPreferencesKey.isOnboardingCompleted);
  }

  /// Saves a boolean [value] with a [key] in the FlutterSecureStorage.
  static Future<void> setBool(String key, bool value) async {
    debugPrint(
      "FlutterSecureStorage : setBool with key : $key and value : $value",
    );
    await flutterSecureStorage.write(key: key, value: value.toString());
  }

  /// Gets a boolean value from FlutterSecureStorage with given [key].
  static Future<bool> getBool(String key) async {
    debugPrint('FlutterSecureStorage : getBool with key : $key');
    final value = await flutterSecureStorage.read(key: key);
    return value == 'true';
  }

  /// Gets the isFeatured value from FlutterSecureStorage.
  static Future<bool> getIsFeatured() async {
    return await getBool(SharedPreferencesKey.isFeatured);
  }

  /// Sets the isFeatured value in FlutterSecureStorage.
  static Future<void> setIsFeatured(bool value) async {
    await setBool(SharedPreferencesKey.isFeatured, value);
  }

  /// Gets the isOnboardingCompleted value from FlutterSecureStorage.
  static Future<bool> getIsOnboardingCompleted() async {
    return await getBool(SharedPreferencesKey.isOnboardingCompleted);
  }

  /// Sets the isOnboardingCompleted value in FlutterSecureStorage.
  static Future<void> setIsOnboardingCompleted(bool value) async {
    await setBool(SharedPreferencesKey.isOnboardingCompleted, value);
  }

  /// Gets the isLoggedIn value from FlutterSecureStorage.
  static Future<bool> getIsLoggedIn() async {
    return await getBool(SharedPreferencesKey.isLoggedIn);
  }

  /// Sets the isLoggedIn value in FlutterSecureStorage.
  static Future<void> setIsLoggedIn(bool value) async {
    await setBool(SharedPreferencesKey.isLoggedIn, value);
  }

  // Signup form data methods

  /// Save signup form data to shared preferences
  static Future<void> saveSignupFormData(Map<String, dynamic> formData) async {
    try {
      final jsonData = jsonEncode(formData);
      await setSecuredString(SharedPreferencesKey.signupFormDataKey, jsonData);
      await setSecuredString(
        SharedPreferencesKey.signupTimestampKey,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );
      debugPrint('Signup form data saved successfully');
    } catch (e) {
      debugPrint('Error saving signup form data: $e');
    }
  }

  /// Load signup form data from shared preferences
  static Future<Map<String, dynamic>?> loadSignupFormData() async {
    try {
      final jsonData =
          await getSecuredString(SharedPreferencesKey.signupFormDataKey);
      if (jsonData.isEmpty) return null;

      final decodedData = jsonDecode(jsonData);
      debugPrint('Signup form data loaded successfully');
      return decodedData;
    } catch (e) {
      debugPrint('Error loading signup form data: $e');
      return null;
    }
  }

  /// Save current signup step
  static Future<void> saveSignupCurrentStep(int step) async {
    await setSecuredString(
        SharedPreferencesKey.signupCurrentStepKey, step.toString());
  }

  /// Load current signup step
  static Future<int> loadSignupCurrentStep() async {
    final stepStr =
        await getSecuredString(SharedPreferencesKey.signupCurrentStepKey);
    return int.tryParse(stepStr) ?? 0;
  }

  /// Save signup gender
  static Future<void> saveSignupGender(String gender) async {
    await setSecuredString(SharedPreferencesKey.signupGenderKey, gender);
  }

  /// Load signup gender
  static Future<String> loadSignupGender() async {
    return await getSecuredString(SharedPreferencesKey.signupGenderKey);
  }

  /// Check if signup data exists and is recent (within 24 hours)
  static Future<bool> hasRecentSignupData(
      {Duration maxAge = const Duration(hours: 24)}) async {
    try {
      final timestampStr =
          await getSecuredString(SharedPreferencesKey.signupTimestampKey);
      if (timestampStr.isEmpty) return false;

      final timestamp = int.tryParse(timestampStr);
      if (timestamp == null) return false;

      final dataAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      return dataAge <= maxAge.inMilliseconds;
    } catch (e) {
      debugPrint('Error checking signup data age: $e');
      return false;
    }
  }

  /// Clear all signup data
  static Future<void> clearSignupData() async {
    try {
      await deleteSecuredString(SharedPreferencesKey.signupFormDataKey);
      await deleteSecuredString(SharedPreferencesKey.signupCurrentStepKey);
      await deleteSecuredString(SharedPreferencesKey.signupGenderKey);
      await deleteSecuredString(SharedPreferencesKey.signupTimestampKey);
      debugPrint('Signup data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing signup data: $e');
    }
  }

  // Cache helper methods for static data

  /// Cache data with timestamp for expiration checking
  static Future<void> cacheData(
      String dataKey, String timestampKey, dynamic data) async {
    try {
      final jsonData = jsonEncode(data);
      await setSecuredString(dataKey, jsonData);
      await setSecuredString(
          timestampKey, DateTime.now().millisecondsSinceEpoch.toString());
      debugPrint('Cached data for key: $dataKey');
    } catch (e) {
      debugPrint('Error caching data for key $dataKey: $e');
    }
  }

  /// Retrieve cached data if it's still valid
  static Future<dynamic> getCachedData(String dataKey, String timestampKey,
      {Duration maxAge = const Duration(hours: 24)}) async {
    try {
      final timestampStr = await getSecuredString(timestampKey);
      if (timestampStr.isEmpty) return null;

      final timestamp = int.tryParse(timestampStr);
      if (timestamp == null) return null;

      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (cacheAge > maxAge.inMilliseconds) {
        debugPrint('Cache expired for key: $dataKey (age: ${cacheAge}ms)');
        return null;
      }

      final cachedData = await getSecuredString(dataKey);
      if (cachedData.isEmpty) return null;

      final decodedData = jsonDecode(cachedData);
      debugPrint(
          'Retrieved cached data for key: $dataKey (age: ${cacheAge}ms)');
      return decodedData;
    } catch (e) {
      debugPrint('Error retrieving cached data for key $dataKey: $e');
      return null;
    }
  }

  /// Clear specific cache
  static Future<void> clearCache(String dataKey, String timestampKey) async {
    try {
      await deleteSecuredString(dataKey);
      await deleteSecuredString(timestampKey);
      debugPrint('Cleared cache for key: $dataKey');
    } catch (e) {
      debugPrint('Error clearing cache for key $dataKey: $e');
    }
  }

  /// Clear all caches
  static Future<void> clearAllCaches() async {
    try {
      await deleteSecuredString(SharedPreferencesKey.nationalitiesCacheKey);
      await deleteSecuredString(SharedPreferencesKey.countriesCacheKey);
      await deleteSecuredString(
          SharedPreferencesKey.nationalitiesCacheTimestampKey);
      await deleteSecuredString(
          SharedPreferencesKey.countriesCacheTimestampKey);
      debugPrint('Cleared all caches');
    } catch (e) {
      debugPrint('Error clearing all caches: $e');
    }
  }
}
