
import 'package:elsadeken/features/profile/terms_conditions/domain/entities/terms_conditions.dart';
import 'package:elsadeken/features/profile/terms_conditions/domain/repository/terms_repo.dart';

import '../../domain/entities/blog_fetch_result.dart';
import '../models/terms_model.dart';
import '../../../../../core/networking/api_services.dart';
import 'package:flutter/foundation.dart';

class TermsApi implements TermsRepo {
  final ApiServices _apiServices;

  TermsApi(this._apiServices);

  @override
  Future<TermsFetchResult> getTerms() async {
    try {
      final response = await _apiServices.get(endpoint: '/user/terms-conditions');
      debugPrint('GET /user/terms-conditions -> HTTP ${response.statusCode}');

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final decoded = response.data as Map<String, dynamic>;
        debugPrint('Full API response: $decoded');
        
        if (decoded.containsKey('code')) {
          debugPrint('API payload code: ${decoded['code']}');
        }
        
        // Handle both single object and list responses
        List<dynamic> data;
        if (decoded['data'] is List) {
          data = decoded['data'] as List<dynamic>;
          debugPrint('Data is a List with ${data.length} items');
        } else if (decoded['data'] is Map<String, dynamic>) {
          // If it's a single object, wrap it in a list
          data = [decoded['data']];
          debugPrint('Data is a single Map, wrapped in list');
        } else if (decoded.containsKey('data') && decoded['data'] == null) {
          // Handle case where data field exists but is null
          data = [];
          debugPrint('Data field is null');
        } else {
          // Fallback: check if the response itself is the data
          if (decoded.containsKey('id') || decoded.containsKey('description')) {
            // This might be a single terms object
            data = [decoded];
            debugPrint('Response itself appears to be a terms object');
          } else {
            data = [];
            debugPrint('Data is neither List nor Map: ${decoded['data']?.runtimeType}');
          }
        }
        
        debugPrint('Terms data type: ${decoded['data'].runtimeType}');
        debugPrint('Terms data length: ${data.length}');
        
        if (data.isEmpty) {
          debugPrint('No terms data received from API');
          return TermsFetchResult(
            terms: const <TermsAndConditions>[],
            httpStatusCode: response.statusCode,
            apiCode: decoded['code'] is int ? decoded['code'] as int : null,
          );
        }
        
        try {
          final terms = data
              .map((item) => TermsModel.fromJson(item as Map<String, dynamic>))
              .toList();
              
          debugPrint('Parsed ${terms.length} terms successfully');
          return TermsFetchResult(
            terms: terms,
            httpStatusCode: response.statusCode,
            apiCode: decoded['code'] is int ? decoded['code'] as int : null,
          );
        } catch (parseError) {
          debugPrint('Error parsing terms data: $parseError');
          debugPrint('Data that caused parsing error: $data');
          rethrow;
        }
      } else {
        debugPrint('API request failed with status: ${response.statusCode}');
        return TermsFetchResult(
          terms: const <TermsAndConditions>[],
          httpStatusCode: response.statusCode,
          apiCode: null,
        );
      }
    } catch (e) {
      debugPrint('Error in getTerms: $e');
      rethrow;
    }
  }

}
