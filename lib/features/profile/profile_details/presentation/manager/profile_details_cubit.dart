import 'package:elsadeken/features/profile/profile_details/data/models/profile_details_action_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/repo/profile_details_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_details_state.dart';

class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  ProfileDetailsCubit(this.profileDetailsRepoInterface)
      : super(ProfileDetailsInitial());

  final ProfileDetailsRepoInterface profileDetailsRepoInterface;

  void likeUser(String userId) async {
    emit(LikeUserLoading());

    var response = await profileDetailsRepoInterface.likeUser(userId);

    response.fold((error) {
      emit(LikeUserFailure(error.displayMessage));
    }, (likeUserResponseModel) {
      emit(LikeUserSuccess(likeUserResponseModel));
    });
  }

  void ignoreUser(String userId) async {
    emit(IgnoreUserLoading());

    var response = await profileDetailsRepoInterface.ignoreUser(userId);

    response.fold((error) {
      emit(IgnoreUserFailure(error.displayMessage));
    }, (ignoreUserResponseModel) {
      emit(IgnoreUserSuccess(ignoreUserResponseModel));
    });
  }
}
