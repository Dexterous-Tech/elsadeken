import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/data/repo/manage_profile_repo.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

part 'manage_profile_state.dart';

class ManageProfileCubit extends Cubit<ManageProfileState> {
  ManageProfileCubit(this.manageProfileRepoInterface)
      : super(ManageProfileInitial());

  final ManageProfileRepoInterface manageProfileRepoInterface;

  void getProfile() async {
    print('🔄 ManageProfileCubit: getProfile() called');
    emit(ManageProfileLoading());
    var response = await manageProfileRepoInterface.getProfile();
    response.fold((l) {
      emit(ManageProfileFailure(l.displayMessage));
    }, (r) async {
      // Delete existing gender value before saving new one
      await SharedPreferencesHelper.deleteSecuredString(
          SharedPreferencesKey.gender);

      // Save gender from profile response
      if (r.data?.gender != null) {
        await SharedPreferencesHelper.setSecuredString(
            SharedPreferencesKey.gender, r.data!.gender!);
      }

      // Delete existing isFeatured value before saving new one
      await SharedPreferencesHelper.deleteSecuredString(
          SharedPreferencesKey.isFeatured);

      // Save isFeatured from profile response (convert 1/0 to bool)
      if (r.data?.isFeatured != null) {
        bool isFeatured = r.data!.isFeatured == 1;
        await SharedPreferencesHelper.setBool(
            SharedPreferencesKey.isFeatured, isFeatured);
      }

      // Delete existing isNotifable value before saving new one
      await SharedPreferencesHelper.deleteSecuredString(
          SharedPreferencesKey.isNotifable);

      // Save isNotifable from profile response (convert 1/0 to bool)
      if (r.data?.isNotifable != null) {
        bool isNotifable = r.data!.isNotifable == 1;
        await SharedPreferencesHelper.setBool(
            SharedPreferencesKey.isNotifable, isNotifable);
      }

      // Delete existing isBlocked value before saving new one
      await SharedPreferencesHelper.deleteSecuredString(
          SharedPreferencesKey.isBlocked);

      // Save isBlocked from profile response (convert 1/0 to bool)
      if (r.data?.isBlocked != null) {
        bool isBlocked = r.data!.isBlocked == 1;
        await SharedPreferencesHelper.setBool(
            SharedPreferencesKey.isBlocked, isBlocked);
      }

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
