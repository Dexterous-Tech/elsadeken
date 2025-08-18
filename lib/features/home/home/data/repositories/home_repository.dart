// import 'package:dio/dio.dart';
// import 'package:elsadeken/core/networking/api_constants.dart';
// import 'package:elsadeken/core/networking/api_services.dart';
// import 'package:elsadeken/features/home/home/data/models/user_model.dart';


// class HomeRepository {
//   final ApiServices _apiServices;

//   HomeRepository(this._apiServices);

//   Future<MatchesResponse> getMatchesUsers({int page = 1}) async {
//     try {
//       final response = await _apiServices.get(
//         endpoint: ApiConstants.matchesUsers,
//         queryParameters: {'page': page},
//         requiresAuth: true,
//       );
//       return MatchesResponse.fromJson(response.data);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> likeUser(String userId) async {
//     try {
//       await _apiServices.post(
//         endpoint: ApiConstants.likeUser(userId),
//         requestBody: {},
//         requiresAuth: true,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> ignoreUser(String userId) async {
//     try {
//       await _apiServices.post(
//         endpoint: ApiConstants.ignoreUser(userId),
//         requestBody: {},
//         requiresAuth: true,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
// }