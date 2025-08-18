import 'package:elsadeken/features/profile/profile_details/data/models/profile_details_action_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/profile_details_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/repo/profile_details_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_details_state.dart';

class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  ProfileDetailsCubit(this.profileDetailsRepoInterface)
      : super(ProfileDetailsInitial());

  final ProfileDetailsRepoInterface profileDetailsRepoInterface;

  void likeUser(int userId) async {
    emit(LikeUserLoading());

    var response = await profileDetailsRepoInterface.likeUser(userId);

    response.fold((error) {
      emit(LikeUserFailure(error.displayMessage));
    }, (likeUserResponseModel) {
      emit(LikeUserSuccess(likeUserResponseModel));
    });
  }

  void ignoreUser(int userId) async {
    emit(IgnoreUserLoading());

    var response = await profileDetailsRepoInterface.ignoreUser(userId);

    response.fold((error) {
      emit(IgnoreUserFailure(error.displayMessage));
    }, (ignoreUserResponseModel) {
      emit(IgnoreUserSuccess(ignoreUserResponseModel));
    });
  }

  void getProfileDetails(int userId) async {
    emit(GetProfileDetailsLoading());

    var response = await profileDetailsRepoInterface.getProfileDetails(userId);

    response.fold((error) {
      emit(GetProfileDetailsFailure(error.displayMessage));
    }, (profileDetailsResponseModel) {
      emit(GetProfileDetailsSuccess(profileDetailsResponseModel));
    });
  }
}
