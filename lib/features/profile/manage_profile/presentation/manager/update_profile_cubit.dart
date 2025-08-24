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
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
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
}
