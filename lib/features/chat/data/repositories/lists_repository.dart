import '../services/lists_service.dart';
import '../models/nationality_model.dart';
import '../models/country_model.dart';
import '../models/api_response_model.dart';

class ListsRepository {
  final ListsService _service;

  ListsRepository(this._service);

  /// Get list of nationalities
  Future<ApiResponseModel<List<NationalityModel>>> getNationalities() async {
    return await _service.getNationalities();
  }

  /// Get list of countries
  Future<ApiResponseModel<List<CountryModel>>> getCountries() async {
    return await _service.getCountries();
  }
}










