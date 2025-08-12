import 'package:bloc/bloc.dart';
import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/data/repo/signup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'nationalities_countries_state.dart';

class NationalitiesCountriesCubit extends Cubit<NationalitiesCountriesState> {
  NationalitiesCountriesCubit(this.signupRepoInterface)
      : super(NationalitiesCountriesInitial());

  final SignupRepoInterface signupRepoInterface;

  static NationalitiesCountriesCubit get(context) => BlocProvider.of(context);

  void getNationalities() async {
    emit(NationalitiesLoading());

    var response = await signupRepoInterface.getNationalities();

    response.fold((error) {
      emit(NationalitiesFailure(error.displayMessage));
    }, (nationalitiesList) {
      emit(NationalitiesSuccess(nationalitiesList));
    });
  }

  void getCountries() async {
    emit(CountriesLoading());

    var response = await signupRepoInterface.getCountries();

    response.fold((error) {
      emit(CountriesFailure(error.displayMessage));
    }, (countriesList) {
      emit(CountriesSuccess(countriesList));
    });
  }

  void getCites(String id) async {
    emit(CitiesLoading());

    var response = await signupRepoInterface.getCites(id);

    response.fold((error) {
      emit(CitiesFailure(error.displayMessage));
    }, (citiesList) {
      emit(CitiesSuccess(citiesList));
    });
  }
}
