// home_remote_data_source.dart
import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/home/home/data/models/matches_response_model.dart';

// home_remote_data_source.dart
abstract class HomeRemoteDataSource {
  Future<MatchesResponseModel> getMatchesUsers(int page);
  Future<void> likeUser(int userId);
  Future<void> ignoreUser(int userId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiServices _apiService;

  HomeRemoteDataSourceImpl(this._apiService);

  @override
  Future<MatchesResponseModel> getMatchesUsers(int page) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.matchesUsers,
      queryParameters: {'page': page},
      requiresAuth: true,
    );
    return MatchesResponseModel.fromJson(response.data);
  }

  @override
  Future<void> likeUser(int userId) async {
    await _apiService.post(
      endpoint: ApiConstants.likeUser(userId),
      requestBody: {},
      requiresAuth: true,
    );
  }

  @override
  Future<void> ignoreUser(int userId) async {
    await _apiService.post(
      endpoint: ApiConstants.ignoreUser(userId),
      requestBody: {},
      requiresAuth: true,
    );
  }
}