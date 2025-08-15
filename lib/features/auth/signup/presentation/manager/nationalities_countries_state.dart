part of 'nationalities_countries_cubit.dart';

@immutable
sealed class NationalitiesCountriesState {}

final class NationalitiesCountriesInitial extends NationalitiesCountriesState {}

final class NationalitiesLoading extends NationalitiesCountriesState {}

final class NationalitiesFailure extends NationalitiesCountriesState {
  final String error;

  NationalitiesFailure(this.error);
}

final class NationalitiesSuccess extends NationalitiesCountriesState {
  final List<NationalCountryResponseModel> nationalitiesList;

  NationalitiesSuccess(this.nationalitiesList);
}

final class CountriesLoading extends NationalitiesCountriesState {}

final class CountriesFailure extends NationalitiesCountriesState {
  final String error;

  CountriesFailure(this.error);
}

final class CountriesSuccess extends NationalitiesCountriesState {
  final List<NationalCountryResponseModel> countriesList;

  CountriesSuccess(this.countriesList);
}

final class CitiesLoading extends NationalitiesCountriesState {}

final class CitiesFailure extends NationalitiesCountriesState {
  final String error;

  CitiesFailure(this.error);
}

final class CitiesSuccess extends NationalitiesCountriesState {
  final List<CityResponseModels> citiesList;

  CitiesSuccess(this.citiesList);
}
