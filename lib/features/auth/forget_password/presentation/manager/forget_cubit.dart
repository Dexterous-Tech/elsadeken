import 'package:elsadeken/features/auth/forget_password/data/models/forget_models.dart';
import 'package:elsadeken/features/auth/forget_password/data/repo/forget_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forget_state.dart';

class ForgetCubit extends Cubit<ForgetState> {
  ForgetCubit(this.forgetRepo) : super(ForgetInitial());

  static ForgetCubit get(BuildContext context) => BlocProvider.of(context);

  final ForgetRepoInterface forgetRepo;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  void forgetPassword() async {
    emit(ForgetLoading());
    var response = await forgetRepo.forgetPassword(
      ForgetRequestBodyModel(
        email: emailController.text,
      ),
    );

    response.fold(
      (error) {
        emit(ForgetFailure(error.displayMessage));
      },
      (forgetResponseModel)  {
        emit(ForgetSuccess(forgetResponseModel: forgetResponseModel));
      },
    );
  }
}
