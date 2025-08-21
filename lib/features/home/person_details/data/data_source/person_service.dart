import 'dart:convert';
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import '../models/person_model.dart';

class PersonService {
  static Future<PersonModel?> fetchPersonDetails(int id) async {
    try {
      print("Fetching person details for ID: $id");
      final apiService = await ApiServices.init();
      final response = await apiService.get(
        endpoint: ApiConstants.personDetails(id),
        requiresAuth: true,
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Data: ${response.data}");
      print("API Response Data Type: ${response.data.runtimeType}");

      if (response.statusCode == 200) {
        final jsonBody = response.data as Map<String, dynamic>;
        print("JSON Body: $jsonBody");
        print("JSON Body Keys: ${jsonBody.keys.toList()}");

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
          print("Person JSON: $personJson");
          print("Person JSON Keys: ${personJson.keys.toList()}");

          try {
            final person = PersonModel.fromJson(personJson);
            print("Successfully created PersonModel: ${person.name}");
            return person;
          } catch (parseError) {
            print("Error parsing PersonModel: $parseError");
            print("Person JSON that failed: $personJson");
            throw Exception("Failed to parse person data: $parseError");
          }
        } else {
          print("No person data found in response. Full response: ${jsonBody}");
          return null;
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.statusMessage}");
        print("Error Response: ${response.data}");
        throw Exception(
            "Failed to load person details: ${response.statusCode}");
      }
    } catch (e) {
      print("PersonService Error: $e");
      throw Exception("Failed to load person details: $e");
    }
  }
}
