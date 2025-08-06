import '../repository/search_repository.dart';
import '../../domain/entities/search_filter.dart';

class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase(this.repository);

  Future<List<String>> call(SearchFilter filter) async {
    return await repository.performSearch(filter);
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
