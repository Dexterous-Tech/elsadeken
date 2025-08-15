import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/auth/verification_email/data/models/verification_models.dart';
import 'package:elsadeken/features/auth/verification_email/data/repo/verification_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit(this.verificationRepo) : super(VerificationInitial());

  final VerificationRepoInterface verificationRepo;

  static VerificationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController otpController = TextEditingController();

  void verifyOtp(String email) async {
    emit(VerificationLoading());
    var response = await verificationRepo.verifyOtp(
      VerificationRequestBodyModel(
        otp: otpController.text,
        email: email,
      ),
    );

    response.fold(
      (error) {
        emit(VerificationFailure(error.displayMessage));
      },
      (verificationResponseModel) async{
        await SharedPreferencesHelper.setSecuredString(SharedPreferencesKey.verificationTokenKey, verificationResponseModel.data!.token);
        emit(VerificationSuccess(verificationResponseModel));
      },
    );
  }
}
