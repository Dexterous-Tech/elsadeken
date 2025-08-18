import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';
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
      // await DioFactory.resetDio();
      emit(LogoutSuccess(logoutResponseModel));
    });
  }
}
