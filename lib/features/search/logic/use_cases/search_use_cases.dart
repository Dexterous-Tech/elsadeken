// File: lib/domain/use_cases/search_use_case.dart

import 'package:elsadeken/features/search/domain/entities/search_filter.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository.dart';

import '../../../profile/interests_list/data/models/users_response_model.dart';

class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase(this.repository);

  Future<UsersResponseModel> searchUsers(
    SearchFilter filter, {
    int page = 1,
  }) async {
    return await repository.searchUsers(filter, page: page);
  }

  Future<List<String>> getNationalities() async {
    return await repository.getNationalities();
  }

  Future<List<String>> getCountries() async {
    return await repository.getCountries();
  }

  Future<List<String>> getCities() async {
    return await repository.getCities();
  }
}
