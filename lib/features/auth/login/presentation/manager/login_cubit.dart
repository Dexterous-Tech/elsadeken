import 'dart:developer';

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

  final LoginRepo loginRepo;

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
        emit(LoginSuccess(loginResponseModel: loginResponseModel));
      },
    );
  }

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
}
