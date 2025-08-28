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

  static Future<void> deleteSharedPreferKeys() async{
     await flutterSecureStorage.delete(key: SharedPreferencesKey.apiTokenKey);
     await flutterSecureStorage.delete(key: SharedPreferencesKey.verificationTokenKey);
  }

  // Cache helper methods for static data
  
  /// Cache data with timestamp for expiration checking
  static Future<void> cacheData(String dataKey, String timestampKey, dynamic data) async {
    try {
      final jsonData = jsonEncode(data);
      await setSecuredString(dataKey, jsonData);
      await setSecuredString(timestampKey, DateTime.now().millisecondsSinceEpoch.toString());
      debugPrint('Cached data for key: $dataKey');
    } catch (e) {
      debugPrint('Error caching data for key $dataKey: $e');
    }
  }

  /// Retrieve cached data if it's still valid
  static Future<dynamic> getCachedData(String dataKey, String timestampKey, {Duration maxAge = const Duration(hours: 24)}) async {
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
      debugPrint('Retrieved cached data for key: $dataKey (age: ${cacheAge}ms)');
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
      await deleteSecuredString(SharedPreferencesKey.nationalitiesCacheTimestampKey);
      await deleteSecuredString(SharedPreferencesKey.countriesCacheTimestampKey);
      debugPrint('Cleared all caches');
    } catch (e) {
      debugPrint('Error clearing all caches: $e');
    }
  }
}
