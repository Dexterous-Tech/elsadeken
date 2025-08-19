import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:elsadeken/core/networking/api_constants.dart';
import '../models/person_model.dart';

class PersonService {
  static Future<PersonModel?> fetchPersonDetails(int id) async {
    final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.personDetails(id)}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      
      final personJson = jsonBody['data'] as Map<String, dynamic>;
      return PersonModel.fromJson(personJson);
    } else {
      throw Exception("Failed to load person details");
    }
  }
}
