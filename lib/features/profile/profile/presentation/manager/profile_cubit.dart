import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/features/profile/profile/data/models/profile_action_model.dart';
import 'package:elsadeken/features/profile/profile/data/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileRepoInterface) : super(ProfileInitial());

  final ProfileRepoInterface profileRepoInterface;

  static ProfileCubit get(context) => BlocProvider.of(context);

  void logout() async {
    emit(LogoutLoading());

    var response = await profileRepoInterface.logout();

    response.fold((error) {
      emit(LogoutFailure(error.displayMessage));
    }, (logoutResponseModel) async {
      // Clear all app state data
      await SharedPreferencesHelper.clearAllAppState();
      await SharedPreferencesHelper.deleteUserImage();
      // await DioFactory.resetDio();
      emit(LogoutSuccess(logoutResponseModel));
    });
  }

  void deleteImage() async {
    print('🚀 ProfileCubit: deleteImage() called');
    emit(DeleteImageLoading());

    var response = await profileRepoInterface.deleteImage();

    response.fold((error) {
      print('❌ ProfileCubit: deleteImage failed - ${error.displayMessage}');
      emit(DeleteImageFailure(error.displayMessage));
    }, (deleteImageResponseModel) async {
      print(
          '✅ ProfileCubit: deleteImage success - ${deleteImageResponseModel.message}');
      // await DioFactory.resetDio();
      emit(DeleteImageSuccess(deleteImageResponseModel));
    });
  }
}
