import 'package:bloc/bloc.dart';
import 'package:elsadeken/core/networking/dio_factory.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/data/repo/manage_profile_repo.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';
import 'package:meta/meta.dart';

part 'manage_profile_state.dart';

class ManageProfileCubit extends Cubit<ManageProfileState> {
  ManageProfileCubit(this.manageProfileRepoInterface)
      : super(ManageProfileInitial());

  final ManageProfileRepoInterface manageProfileRepoInterface;

  void getProfile() async {
    emit(ManageProfileLoading());
    var response = await manageProfileRepoInterface.getProfile();
    response.fold((l) {
      emit(ManageProfileFailure(l.displayMessage));
    }, (r) {
      emit(ManageProfileSuccess(r));
    });
  }

  void deleteProfile() async {
    emit(DeleteProfileLoading());
    var response = await manageProfileRepoInterface.deleteAccount();
    response.fold((l) {
      emit(DeleteProfileFailure(l.displayMessage));
    }, (deleteProfile) async {
      await SharedPreferencesHelper.deleteSharedPreferKeys();
      // await DioFactory.resetDio();
      emit(DeleteProfileSuccess(deleteProfile));
    });
  }
}
