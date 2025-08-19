// home_repository.dart
import 'package:elsadeken/features/home/home/domain/entities/match_user_entity.dart';

abstract class HomeRepository {
  Future<List<MatchUserEntity>> getMatchesUsers(int page);
  Future<void> likeUser(int userId);
  Future<void> ignoreUser(int userId);
}