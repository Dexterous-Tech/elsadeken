import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/data/repo/signup_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_lists_state.dart';

class SignUpListsCubit extends Cubit<SignUpListsState> {
  SignUpListsCubit(this.signupRepoInterface) : super(SignUpListsStateInitial());

  final SignupRepoInterface signupRepoInterface;

  static SignUpListsCubit get(context) => BlocProvider.of(context);

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

  void getSkinColors() async {
    emit(SkinColorsLoading());

    var response =
        await signupRepoInterface.getGeneralInfo(ApiConstants.skinColors);

    response.fold((error) {
      emit(SkinColorsFailure(error.displayMessage));
    }, (skinColorsList) {
      emit(SkinColorsSuccess(skinColorsList));
    });
  }

  void getPhysiques() async {
    emit(PhysiquesLoading());

    var response =
        await signupRepoInterface.getGeneralInfo(ApiConstants.physiques);

    response.fold((error) {
      emit(PhysiquesFailure(error.displayMessage));
    }, (skinColorsList) {
      emit(PhysiquesSuccess(skinColorsList));
    });
  }

  void getQualification() async {
    emit(QualificationsLoading());

    var response =
        await signupRepoInterface.getGeneralInfo(ApiConstants.qualifications);

    response.fold((error) {
      emit(QualificationsFailure(error.displayMessage));
    }, (qualificationsList) {
      emit(QualificationsSuccess(qualificationsList));
    });
  }

  void getFinancialSituations() async {
    emit(FinancialSituationsLoading());

    var response = await signupRepoInterface
        .getGeneralInfo(ApiConstants.financialSituations);

    response.fold((error) {
      emit(FinancialSituationsFailure(error.displayMessage));
    }, (financialSituationList) {
      emit(FinancialSituationsSuccess(financialSituationList));
    });
  }

  void getHealthConditions() async {
    emit(HealthConditionsLoading());

    var response =
        await signupRepoInterface.getGeneralInfo(ApiConstants.healthConditions);

    response.fold((error) {
      emit(HealthConditionsFailure(error.displayMessage));
    }, (healthConditionsList) {
      emit(HealthConditionsSuccess(healthConditionsList));
    });
  }
}
