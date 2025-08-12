import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/signup_models.dart';

class SignupDataSource {
  final ApiServices _apiServices;

  SignupDataSource(this._apiServices);

  Future<List<NationalCountryResponseModel>> getNationalities() async {
    var response =
        await _apiServices.get(endpoint: ApiConstants.listNationalities);

    List<dynamic> jsonList = response.data;

    List<NationalCountryResponseModel> nationalities = jsonList
        .map((json) => NationalCountryResponseModel.fromJson(json))
        .toList();
    return nationalities;
  }

  Future<List<NationalCountryResponseModel>> getCountries() async {
    var response = await _apiServices.get(endpoint: ApiConstants.listCountries);

    List<dynamic> jsonList = response.data;

    List<NationalCountryResponseModel> countries = jsonList
        .map((json) => NationalCountryResponseModel.fromJson(json))
        .toList();
    return countries;
  }

  Future<List<CityResponseModels>> getCities(String id) async {
    var response =
        await _apiServices.get(endpoint: ApiConstants.listCities(id));

    List<dynamic> jsonList = response.data;

    List<CityResponseModels> cities =
        jsonList.map((json) => CityResponseModels.fromJson(json)).toList();
    return cities;
  }

  Future<SignupResponseModel> signup(
      SignupRequestBodyModel signupRequestBody) async {
    var response = await _apiServices.post(
        endpoint: ApiConstants.signup,
        requestBody: signupRequestBody.toFormData());

    return SignupResponseModel.fromJson(response.data);
  }

  Future<RegisterInformationResponseModel> registerInformation(
      RegisterInformationRequestModel registerRequestModel) async {
    var response = await _apiServices.post(
        endpoint: ApiConstants.registerInformation,
        requestBody: registerRequestModel.toFormData());

    return RegisterInformationResponseModel.fromJson(response.data);
  }
}
