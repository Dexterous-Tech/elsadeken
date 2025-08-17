// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class NationalityService {
//   static const String baseUrl = "https://elsadkeen.sharetrip-ksa.com/api/";

//   Future<List<String>> fetchNationalities() async {
//     final response = await http.get(Uri.parse("${baseUrl}user/list/nationalities"));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // لو الـ API بيرجع بالشكل: {"data": ["مصري", "سعودي", ...]}
//       return List<String>.from(data['data']);
//     } else {
//       throw Exception("فشل تحميل الجنسيات: ${response.statusCode}");
//     }
//   }
// }
