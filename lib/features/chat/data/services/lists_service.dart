import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import '../models/nationality_model.dart';
import '../models/country_model.dart';
import '../models/api_response_model.dart';

class ListsService {
  final ApiServices _apiServices;

  ListsService(this._apiServices);

  /// Fetch list of nationalities with caching
  Future<ApiResponseModel<List<NationalityModel>>> getNationalities() async {
    try {
      print('[ListsService] Getting nationalities...');
      
      // Try to get from cache first
      final cachedData = await SharedPreferencesHelper.getCachedData(
        SharedPreferencesKey.nationalitiesCacheKey,
        SharedPreferencesKey.nationalitiesCacheTimestampKey,
        maxAge: const Duration(hours: 24), // Cache for 24 hours
      );
      
      if (cachedData != null) {
        print('[ListsService] Using cached nationalities data');
        final nationalitiesList = (cachedData as List)
            .map((item) => NationalityModel.fromJson(item as Map<String, dynamic>))
            .toList();
        
        return ApiResponseModel<List<NationalityModel>>(
          data: nationalitiesList,
          message: 'Success (Cached)',
          type: 'success',
          status: 200,
          showToast: false,
        );
      }
      
      print('[ListsService] Cache miss, fetching from API...');
      
      // Fetch from API if cache miss or expired
      final response = await _apiServices.get<List<dynamic>>(
        endpoint: ApiConstants.getNationalities,
      );

      print('[ListsService] Get nationalities response: ${response.data}');
      print('[ListsService] Get nationalities response type: ${response.data.runtimeType}');
      
      // The API returns a list directly, so we need to handle it differently
      if (response.data is List) {
        final nationalitiesList = (response.data as List)
            .map((item) => NationalityModel.fromJson(item as Map<String, dynamic>))
            .toList();
        
        print('[ListsService] Parsed ${nationalitiesList.length} nationalities');
        
        // Cache the raw API response for future use
        await SharedPreferencesHelper.cacheData(
          SharedPreferencesKey.nationalitiesCacheKey,
          SharedPreferencesKey.nationalitiesCacheTimestampKey,
          response.data,
        );
        
        // Create a response model with the parsed data
        return ApiResponseModel<List<NationalityModel>>(
          data: nationalitiesList,
          message: 'Success',
          type: 'success',
          status: 200,
          showToast: false,
        );
      } else {
        throw Exception('Expected list response but got: ${response.data.runtimeType}');
      }
    } catch (e) {
      print('[ListsService] Get nationalities failed: $e');
      rethrow;
    }
  }

  /// Fetch list of countries with caching
  Future<ApiResponseModel<List<CountryModel>>> getCountries() async {
    try {
      print('[ListsService] Getting countries...');
      
      // Try to get from cache first
      final cachedData = await SharedPreferencesHelper.getCachedData(
        SharedPreferencesKey.countriesCacheKey,
        SharedPreferencesKey.countriesCacheTimestampKey,
        maxAge: const Duration(hours: 24), // Cache for 24 hours
      );
      
      if (cachedData != null) {
        print('[ListsService] Using cached countries data');
        final countriesList = (cachedData as List)
            .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
            .toList();
        
        return ApiResponseModel<List<CountryModel>>(
          data: countriesList,
          message: 'Success (Cached)',
          type: 'success',
          status: 200,
          showToast: false,
        );
      }
      
      print('[ListsService] Cache miss, fetching from API...');
      
      // Fetch from API if cache miss or expired
      final response = await _apiServices.get<List<dynamic>>(
        endpoint: ApiConstants.getCountries,
      );

      print('[ListsService] Get countries response: ${response.data}');
      print('[ListsService] Get countries response type: ${response.data.runtimeType}');
      
      // The API returns a list directly, so we need to handle it differently
      if (response.data is List) {
        final countriesList = (response.data as List)
            .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
            .toList();
        
        print('[ListsService] Parsed ${countriesList.length} countries');
        
        // Cache the raw API response for future use
        await SharedPreferencesHelper.cacheData(
          SharedPreferencesKey.countriesCacheKey,
          SharedPreferencesKey.countriesCacheTimestampKey,
          response.data,
        );
        
        // Create a response model with the parsed data
        return ApiResponseModel<List<CountryModel>>(
          data: countriesList,
          message: 'Success',
          type: 'success',
          status: 200,
          showToast: false,
        );
      } else {
        throw Exception('Expected list response but got: ${response.data.runtimeType}');
      }
    } catch (e) {
      print('[ListsService] Get countries failed: $e');
      rethrow;
    }
  }

  /// Clear all cached lists data
  Future<void> clearCache() async {
    try {
      await SharedPreferencesHelper.clearAllCaches();
      print('[ListsService] Cleared all caches');
    } catch (e) {
      print('[ListsService] Error clearing cache: $e');
    }
  }

  /// Force refresh data by clearing cache and fetching from API
  Future<void> forceRefresh() async {
    try {
      await clearCache();
      print('[ListsService] Force refresh completed');
    } catch (e) {
      print('[ListsService] Error during force refresh: $e');
    }
  }
}
