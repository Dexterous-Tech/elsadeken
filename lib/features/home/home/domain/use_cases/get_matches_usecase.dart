// get_matches_usecase.dart
import 'package:elsadeken/features/home/home/domain/entities/match_user_entity.dart';
import 'package:elsadeken/features/home/home/domain/repositories/home_repostory.dart';

class GetMatchesUseCase {
  final HomeRepository repository;

  GetMatchesUseCase(this.repository);

  Future<List<MatchUserEntity>> call(int page) async {
    return await repository.getMatchesUsers(page);
  }
}

// like_user_usecase.dart
class LikeUserUseCase {
  final HomeRepository repository;

  LikeUserUseCase(this.repository);

  Future<void> call(int userId) async {
    await repository.likeUser(userId);
  }
}

// ignore_user_usecase.dart
class IgnoreUserUseCase {
  final HomeRepository repository;

  IgnoreUserUseCase(this.repository);

  Future<void> call(int userId) async {
    await repository.ignoreUser(userId);
  }
}