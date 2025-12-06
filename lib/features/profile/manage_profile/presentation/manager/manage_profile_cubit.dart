import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/data/repo/manage_profile_repo.dart';
import 'package:elsadeken/features/profile/profile/data/models/profile_action_model.dart';
import 'dart:convert';
import 'dart:io';

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
      await SharedPreferencesHelper.deleteSecuredString(
          SharedPreferencesKey.userDataKey);
      if (r.data != null) {
        final userJson = jsonEncode(r.data!.toJson());
        await SharedPreferencesHelper.setSecuredString(
            SharedPreferencesKey.userDataKey, userJson);
      }

      if (r.data?.isBlocked != null) {
        bool isBlocked = r.data!.isBlocked == 1;
        await SharedPreferencesHelper.setBool(
            SharedPreferencesKey.isBlocked, isBlocked);

        // If user is blocked, delete shared preferences and close app
        if (isBlocked) {
          await _handleBlockedUser();
        }
      }

      await SharedPreferencesHelper.deleteUserImage();

      final imageUrl = r.data?.image ?? '';
      if (imageUrl.isNotEmpty) {
        await SharedPreferencesHelper.saveUserImage(imageUrl);
      }

      emit(ManageProfileSuccess(r));
    });
  }

  TextEditingController passwordController = TextEditingController();

  /// Reset the cubit to initial state
  void resetState() {
    emit(ManageProfileInitial());
  }

  void deleteProfile() async {
    emit(DeleteProfileLoading());
    var response =
        await manageProfileRepoInterface.deleteAccount(passwordController.text);
    response.fold((l) {
      emit(DeleteProfileFailure(l.displayMessage));
    }, (deleteProfile) async {
      await SharedPreferencesHelper.clearAllAppState();
      // await DioFactory.resetDio();
      emit(DeleteProfileSuccess(deleteProfile));
    });
  }

  /// Handles blocked users by deleting shared preferences and closing the app
  Future<void> _handleBlockedUser() async {
    try {
      // Delete all shared preferences including token
      await SharedPreferencesHelper.clearAllAppState();

      // Close the app
      exit(0);
    } catch (e) {
      print('Error handling blocked user: $e');
      // Force exit even if there's an error
      exit(0);
    }
  }
}
