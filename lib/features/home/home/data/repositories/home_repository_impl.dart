// home_repository_impl.dart
import 'package:elsadeken/core/errors/exceptions.dart';
import 'package:elsadeken/features/home/home/data/data_source/home_remote_data_source.dart';
import 'package:elsadeken/features/home/home/domain/entities/match_user_entity.dart';
import 'package:elsadeken/features/home/home/domain/repositories/home_repostory.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MatchUserEntity>> getMatchesUsers(int page) async {
    try {
      final response = await remoteDataSource.getMatchesUsers(page);
      return response.toEntities();
    } catch (e) {
      throw ServerException(message: 'Failed to load matches');
    }
  }

  @override
  Future<void> likeUser(String userId) async {
    try {
      await remoteDataSource.likeUser(userId);
    } catch (e) {
      throw ServerException(message: 'Failed to like user');
    }
  }

  @override
  Future<void> ignoreUser(String userId) async {
    try {
      await remoteDataSource.ignoreUser(userId);
    } catch (e) {
      throw ServerException(message: 'Failed to ignore user');
    }
  }
}