// home_repository.dart
import 'package:elsadeken/features/home/home/domain/entities/match_user_entity.dart';

abstract class HomeRepository {
  Future<List<MatchUserEntity>> getMatchesUsers(int page);
  Future<void> likeUser(String userId);
  Future<void> ignoreUser(String userId);
}