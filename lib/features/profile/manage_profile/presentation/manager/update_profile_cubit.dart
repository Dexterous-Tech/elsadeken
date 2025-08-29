import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/update_profile_models.dart';
import 'package:elsadeken/features/profile/manage_profile/data/repo/manage_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(this.manageProfileRepoInterface)
      : super(UpdateProfileInitial());

  final ManageProfileRepoInterface manageProfileRepoInterface;

  void updateProfileLoginData({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
  }) async {
    emit(UpdateProfileLoginDataLoading());

    var response = await manageProfileRepoInterface.updateProfileLoginData(
        UpdateProfileLoginDataRequestModel(
            name: name,
            email: email,
            phone: phone,
            password: password,
            passwordConfirmation: passwordConfirmation));

    response.fold(
        (error) => emit(UpdateProfileLoginDataFailure(error.displayMessage)),
        (responseModel) => emit(UpdateProfileLoginDataSuccess(responseModel)));
  }

  void updateProfileLocationData({
    required int nationalityId,
    required int countryId,
    required int cityId,
  }) async {
    emit(UpdateProfileLocationDataLoading());

    var response = await manageProfileRepoInterface.updateProfileLocationData(
        UpdateProfileLocationDataModel(
            nationalityId: nationalityId,
            countryId: countryId,
            cityId: cityId));

    response.fold(
        (error) => emit(UpdateProfileLocationDataFailure(error.displayMessage)),
        (responseModel) =>
            emit(UpdateProfileLocationDataSuccess(responseModel)));
  }

  void updateProfileMarriageData({
    String? maritalStatus,
    String? typeOfMarriage,
    int? childrenNumber,
    int? age,
  }) async {
    emit(UpdateProfileMarriageDataLoading());

    var response = await manageProfileRepoInterface.updateProfileMarriageData(
        UpdateProfileMarriageDataModel(
            maritalStatus: maritalStatus,
            typeOfMarriage: typeOfMarriage,
            childrenNumber: childrenNumber,
            age: age));

    response.fold(
        (error) => emit(UpdateProfileMarriageDataFailure(error.displayMessage)),
        (responseModel) =>
            emit(UpdateProfileMarriageDataSuccess(responseModel)));
  }

  void updateProfilePhysicalData({
    int? weight,
    int? height,
    int? skinColorId,
    int? physiqueId,
  }) async {
    emit(UpdateProfilePhysicalDataLoading());

    var response = await manageProfileRepoInterface.updateProfilePhysicalData(
        UpdateProfilePhysicalDataModel(
            weight: weight,
            height: height,
            skinColorId: skinColorId,
            physiqueId: physiqueId));

    response.fold(
        (error) => emit(UpdateProfilePhysicalDataFailure(error.displayMessage)),
        (responseModel) =>
            emit(UpdateProfilePhysicalDataSuccess(responseModel)));
  }

  void updateProfileReligiousData({
    String? religiousCommitment,
    String? prayer,
    int? smoking,
    String? hijab,
    String? beard,
  }) async {
    emit(UpdateProfileReligiousDataLoading());

    var response = await manageProfileRepoInterface.updateProfileReligiousData(
        UpdateProfileReligiousDataModel(
            religiousCommitment: religiousCommitment,
            prayer: prayer,
            smoking: smoking,
            hijab: hijab,
            beard: beard));

    response.fold(
        (error) =>
            emit(UpdateProfileReligiousDataFailure(error.displayMessage)),
        (responseModel) =>
            emit(UpdateProfileReligiousDataSuccess(responseModel)));
  }

  void updateProfileWorkData({
    String? qualificationId,
    int? income,
    String? job,
    String? healthConditionId,
    String? financialSituationId,
  }) async {
    emit(UpdateProfileWorkDataLoading());

    var response = await manageProfileRepoInterface.updateProfileWorkData(
        UpdateProfileWorkDataModel(
            qualificationId: qualificationId,
            income: income,
            job: job,
            healthConditionId: healthConditionId,
            financialSituationId: financialSituationId));

    response.fold(
        (error) => emit(UpdateProfileWorkDataFailure(error.displayMessage)),
        (responseModel) => emit(UpdateProfileWorkDataSuccess(responseModel)));
  }

  void updateProfileAboutMeData({
    String? aboutMe,
  }) async {
    emit(UpdateProfileAboutMeDataLoading());

    var response = await manageProfileRepoInterface.updateProfileAboutMeData(
        UpdateProfileAboutMeDataModel(aboutMe: aboutMe));

    response.fold(
        (error) => emit(UpdateProfileAboutMeDataFailure(error.displayMessage)),
        (responseModel) =>
            emit(UpdateProfileAboutMeDataSuccess(responseModel)));
  }

  void updateProfileAboutPartnerData({
    String? lifePartner,
  }) async {
    emit(UpdateProfileAboutPartnerDataLoading());

    var response =
        await manageProfileRepoInterface.updateProfileAboutPartnerData(
            UpdateProfileAboutPartnerDataModel(lifePartner: lifePartner));

    response.fold(
        (error) =>
            emit(UpdateProfileAboutPartnerDataFailure(error.displayMessage)),
        (responseModel) =>
            emit(UpdateProfileAboutPartnerDataSuccess(responseModel)));
  }
}
