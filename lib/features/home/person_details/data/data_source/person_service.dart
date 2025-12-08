import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import '../models/person_model.dart';

class PersonService {
  static Future<PersonModel?> fetchPersonDetails(int id) async {
    try {
      final apiService = await ApiServices.init();
      final response = await apiService.get(
        endpoint: ApiConstants.personDetails(id),
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final jsonBody = response.data as Map<String, dynamic>;

        Map<String, dynamic>? personJson;

        // Try different possible response structures
        if (jsonBody['data'] != null) {
          personJson = jsonBody['data'] as Map<String, dynamic>;
        } else if (jsonBody['user'] != null) {
          personJson = jsonBody['user'] as Map<String, dynamic>;
        } else if (jsonBody['person'] != null) {
          personJson = jsonBody['person'] as Map<String, dynamic>;
        } else if (jsonBody.containsKey('id') && jsonBody.containsKey('name')) {
          // Direct person data
          personJson = jsonBody;
        }

        if (personJson != null) {
          try {
            final person = PersonModel.fromJson(personJson);
            return person;
          } catch (parseError) {
            throw Exception("Failed to parse person data: $parseError");
          }
        } else {
          return null;
        }
      } else {
        throw Exception(
          "Failed to load person details: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Failed to load person details: $e");
    }
  }
}
