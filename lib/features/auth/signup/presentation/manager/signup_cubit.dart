import 'dart:developer';

import 'package:elsadeken/core/networking/dio_factory.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/auth/signup/data/models/signup_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/signup_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.signupRepo) : super(SignupInitial());

  static SignupCubit get(BuildContext context) => BlocProvider.of(context);

  final SignupRepoInterface signupRepo;

  // Form keys
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> registerInformationFormKey = GlobalKey<FormState>();

  // Signup form controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  // Register information controllers
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController countryIdController = TextEditingController();
  TextEditingController cityIdController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController typeOfMarriageController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController childrenNumberController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController skinColorController = TextEditingController();
  TextEditingController physiqueController = TextEditingController();
  TextEditingController religiousCommitmentController = TextEditingController();
  TextEditingController prayerController = TextEditingController();
  TextEditingController smokingController = TextEditingController();
  TextEditingController hijabController = TextEditingController();
  TextEditingController educationalQualificationController =
      TextEditingController();
  TextEditingController financialSituationController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController healthConditionController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController lifePartnerController = TextEditingController();

  void signup() async {
    emit(SignupLoading());
    var response = await signupRepo.signup(
      SignupRequestBodyModel(
        name: nameController.text,
        email: emailController.text,
        gender: genderController.text,
        countryCode: countryCodeController.text,
        phone: phoneController.text,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      ),
    );

    response.fold(
      (error) {
        emit(SignupFailure(error.displayMessage));
      },
      (signupResponseModel) async {
        await saveUserToken(signupResponseModel.data!.token);
        emit(SignupSuccess(signupResponseModel: signupResponseModel));
      },
    );
  }

  void registerInformation() async {
    emit(RegisterInformationLoading());
    var response = await signupRepo.registerInformation(
      RegisterInformationRequestModel(
        nationalId: int.parse(nationalIdController.text),
        countryId: int.parse(countryIdController.text),
        cityId: int.parse(cityIdController.text),
        maritalStatus: maritalStatusController.text,
        typeOfMarriage: typeOfMarriageController.text,
        age: int.parse(ageController.text),
        childrenNumber: childrenNumberController.text,
        weight: int.parse(weightController.text),
        height: int.parse(heightController.text),
        skinColor: skinColorController.text,
        physique: physiqueController.text,
        religiousCommitment: religiousCommitmentController.text,
        prayer: prayerController.text,
        smoking: smokingController.text,
        hijab: hijabController.text,
        educationalQualification: educationalQualificationController.text,
        financialSituation: financialSituationController.text,
        job: jobController.text,
        income: incomeController.text,
        healthCondition: healthConditionController.text,
        aboutMe: aboutMeController.text,
        lifePartner: lifePartnerController.text,
      ),
    );

    response.fold(
      (error) {
        emit(RegisterInformationFailure(error.displayMessage));
      },
      (registerInformationResponseModel) async {
        log("Register information completed successfully");
        emit(RegisterInformationSuccess(
            registerInformationResponseModel:
                registerInformationResponseModel));
      },
    );
  }

  @override
  Future<void> close() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    countryCodeController.dispose();
    genderController.dispose();
    nationalIdController.dispose();
    countryIdController.dispose();
    cityIdController.dispose();
    maritalStatusController.dispose();
    typeOfMarriageController.dispose();
    ageController.dispose();
    childrenNumberController.dispose();
    weightController.dispose();
    heightController.dispose();
    skinColorController.dispose();
    physiqueController.dispose();
    religiousCommitmentController.dispose();
    prayerController.dispose();
    smokingController.dispose();
    hijabController.dispose();
    educationalQualificationController.dispose();
    financialSituationController.dispose();
    jobController.dispose();
    incomeController.dispose();
    healthConditionController.dispose();
    aboutMeController.dispose();
    lifePartnerController.dispose();
    return super.close();
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
