import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/networking/dio_factory.dart';
import '../../../../../core/shared/shared_preferences_helper.dart';
import '../../../../../core/shared/shared_preferences_key.dart';
import '../../data/models/login_models.dart';
import '../../data/repo/login_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginRepo) : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  final LoginRepoInterface loginRepo;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    emit(LoginLoading());
    var response = await loginRepo.login(
      LoginRequestBodyModel(
        email: emailController.text,
        password: passwordController.text,
      ),
    );

    response.fold(
      (error) {
        emit(LoginFailure(error.displayMessage));
      },
      (loginResponseModel) async {
        await saveUserToken(loginResponseModel.data!.token);
        log("save token ");

        // After successful login, save FCM token silently
        await saveFcmTokenSilently();

        emit(LoginSuccess(loginResponseModel: loginResponseModel));
      },
    );
  }

  Future<void> saveFcmTokenSilently() async {
    try {
      await saveTokeFromFirebase();
      String token = await SharedPreferencesHelper.getSecuredString(
          SharedPreferencesKey.deviceToken);
      var response = await loginRepo.updateFcm(token);

      response.fold(
        (error) {
          log("FCM token save failed: ${error.displayMessage}");
          // Don't emit error state to avoid showing error to user
        },
        (fcmResponseModel) async {
          log("FCM token saved successfully");
          // Don't emit success state to avoid showing success to user
        },
      );
    } catch (e) {
      log("Error saving FCM token: $e");
      // Don't emit error state to avoid showing error to user
    }
  }

  // void updateFcm() async {
  //   emit(FcmLoading());
  //
  //   await saveTokeFromFirebase();
  //   String token = await SharedPreferencesHelper.getSecuredString(
  //       SharedPreferencesKey.deviceToken);
  //   var response = await loginRepo.updateFcm(token);
  //
  //   response.fold(
  //     (error) {
  //       emit(FcmFailure(error.displayMessage));
  //     },
  //     (fcmResponseModel) async {
  //       log("save fcm token ");
  //       emit(FcmSuccess(fcmResponseModel));
  //     },
  //   );
  // }

  Future<void> saveUserToken(String token) async {
    // Clear previous data
    await Future.wait([
      SharedPreferencesHelper.deleteSecuredString(
        SharedPreferencesKey.apiTokenKey,
      ),
    ]);
    await SharedPreferencesHelper.setSecuredString(
      SharedPreferencesKey.apiTokenKey,
      token,
    );
    await DioFactory.setTokenIntoHeaderAfterLogin(token);
  }

  Future<void> saveTokeFromFirebase() async {
    await SharedPreferencesHelper.deleteSecuredString(
        SharedPreferencesKey.deviceToken);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    await SharedPreferencesHelper.setSecuredString(
        SharedPreferencesKey.deviceToken, token!);
  }
}
