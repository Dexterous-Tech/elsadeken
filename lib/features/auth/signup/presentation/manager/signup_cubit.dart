import 'dart:developer';

import 'package:elsadeken/core/networking/dio_factory.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:elsadeken/features/auth/signup/data/models/signup_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/signup_form_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/signup_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.signupRepo) : super(SignupInitial());

  static SignupCubit get(BuildContext context) => BlocProvider.of(context);

  final SignupRepoInterface signupRepo;

  // Flag to track if signup was successful (to avoid duplicate signup calls)
  bool _isSignupSuccessful = false;

  // Form keys
  GlobalKey<FormState> personalInfoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordsFormKey = GlobalKey<FormState>();
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
  TextEditingController beardController = TextEditingController();
  TextEditingController educationalQualificationController =
      TextEditingController();
  TextEditingController financialSituationController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController healthConditionController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController lifePartnerController = TextEditingController();

  // Getter for signup success status
  bool get isSignupSuccessful => _isSignupSuccessful;

  // Initialize the cubit and load saved data if exists
  Future<void> initialize(String gender) async {
    // Set the gender
    genderController.text = gender;
    await SharedPreferencesHelper.saveSignupGender(gender);

    // Load saved form data if exists
    await loadSavedFormData();
  }

  // Save current form data to shared preferences
  Future<void> saveFormData() async {
    try {
      final formData = SignupFormDataModel(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        countryCode: countryCodeController.text,
        gender: genderController.text,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
        nationalId: nationalIdController.text,
        countryId: countryIdController.text,
        cityId: cityIdController.text,
        maritalStatus: maritalStatusController.text,
        typeOfMarriage: typeOfMarriageController.text,
        age: ageController.text,
        childrenNumber: childrenNumberController.text,
        weight: weightController.text,
        height: heightController.text,
        skinColor: skinColorController.text,
        physique: physiqueController.text,
        religiousCommitment: religiousCommitmentController.text,
        prayer: prayerController.text,
        smoking: smokingController.text,
        hijab: hijabController.text,
        beard: beardController.text,
        educationalQualification: educationalQualificationController.text,
        financialSituation: financialSituationController.text,
        job: jobController.text,
        income: incomeController.text,
        healthCondition: healthConditionController.text,
        aboutMe: aboutMeController.text,
        lifePartner: lifePartnerController.text,
      );

      await SharedPreferencesHelper.saveSignupFormData(formData.toJson());
      log('Form data saved successfully');
    } catch (e) {
      log('Error saving form data: $e');
    }
  }

  // Load saved form data from shared preferences
  Future<void> loadSavedFormData() async {
    try {
      final savedData = await SharedPreferencesHelper.loadSignupFormData();
      if (savedData != null) {
        final formData = SignupFormDataModel.fromJson(savedData);

        // Load data into controllers
        nameController.text = formData.name ?? '';
        emailController.text = formData.email ?? '';
        phoneController.text = formData.phone ?? '';
        countryCodeController.text = formData.countryCode ?? '';
        genderController.text = formData.gender ?? '';
        passwordController.text = formData.password ?? '';
        passwordConfirmationController.text =
            formData.passwordConfirmation ?? '';
        nationalIdController.text = formData.nationalId ?? '';
        countryIdController.text = formData.countryId ?? '';
        cityIdController.text = formData.cityId ?? '';
        maritalStatusController.text = formData.maritalStatus ?? '';
        typeOfMarriageController.text = formData.typeOfMarriage ?? '';
        ageController.text = formData.age ?? '';
        childrenNumberController.text = formData.childrenNumber ?? '';
        weightController.text = formData.weight ?? '';
        heightController.text = formData.height ?? '';
        skinColorController.text = formData.skinColor ?? '';
        physiqueController.text = formData.physique ?? '';
        religiousCommitmentController.text = formData.religiousCommitment ?? '';
        prayerController.text = formData.prayer ?? '';
        smokingController.text = formData.smoking ?? '';
        hijabController.text = formData.hijab ?? '';
        beardController.text = formData.beard ?? '';
        educationalQualificationController.text =
            formData.educationalQualification ?? '';
        financialSituationController.text = formData.financialSituation ?? '';
        jobController.text = formData.job ?? '';
        incomeController.text = formData.income ?? '';
        healthConditionController.text = formData.healthCondition ?? '';
        aboutMeController.text = formData.aboutMe ?? '';
        lifePartnerController.text = formData.lifePartner ?? '';

        log('Form data loaded successfully');
      }
    } catch (e) {
      log('Error loading form data: $e');
    }
  }

  // Clear all saved signup data
  Future<void> clearSignupData() async {
    await SharedPreferencesHelper.clearSignupData();
    // Also clear the token to force user to login after signup
    await SharedPreferencesHelper.deleteSecuredString(
      SharedPreferencesKey.apiTokenKey,
    );
    // Don't reset the signup success flag - we need it for caching logic
    // _isSignupSuccessful = false;
    log('Signup data and token cleared successfully');
  }

  // Check if there's recent signup data
  Future<bool> hasRecentSignupData() async {
    return await SharedPreferencesHelper.hasRecentSignupData();
  }

  // Get current step from shared preferences
  Future<int> getCurrentStep() async {
    return await SharedPreferencesHelper.loadSignupCurrentStep();
  }

  // Save current step to shared preferences
  Future<void> saveCurrentStep(int step) async {
    await SharedPreferencesHelper.saveSignupCurrentStep(step);
  }

  // Get saved gender
  Future<String> getSavedGender() async {
    return await SharedPreferencesHelper.loadSignupGender();
  }

  // Check if signup was already successful
  Future<bool> isSignupAlreadySuccessful() async {
    // Only check the in-memory flag since we clear the token after signup completion
    // This ensures user must go through login after signup
    return _isSignupSuccessful;
  }

  // Get the appropriate starting step based on signup status
  Future<int> getAppropriateStartingStep() async {
    final isSignupSuccessful = await isSignupAlreadySuccessful();
    if (isSignupSuccessful) {
      // If signup was successful, start from step 3 (national)
      return 2; // 0-indexed, so step 3 is index 2
    } else {
      // If signup was not successful, start from step 1 (personal info)
      return 0;
    }
  }

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
        // Don't mark user as logged in yet - only after complete registration
        // await SharedPreferencesHelper.setIsLoggedIn(true);
        _isSignupSuccessful = true; // Set the flag to true
        emit(SignupSuccess(signupResponseModel: signupResponseModel));
      },
    );
  }

  Future<void> registerInformation() async {
    emit(RegisterInformationLoading());

    // Add safety checks for required fields
    if (nationalIdController.text.isEmpty ||
        countryIdController.text.isEmpty ||
        cityIdController.text.isEmpty ||
        maritalStatusController.text.isEmpty ||
        typeOfMarriageController.text.isEmpty ||
        ageController.text.isEmpty ||
        childrenNumberController.text.isEmpty ||
        weightController.text.isEmpty ||
        heightController.text.isEmpty ||
        skinColorController.text.isEmpty ||
        physiqueController.text.isEmpty ||
        religiousCommitmentController.text.isEmpty ||
        prayerController.text.isEmpty ||
        smokingController.text.isEmpty ||
        educationalQualificationController.text.isEmpty ||
        financialSituationController.text.isEmpty ||
        jobController.text.isEmpty ||
        incomeController.text.isEmpty ||
        healthConditionController.text.isEmpty ||
        aboutMeController.text.isEmpty ||
        lifePartnerController.text.isEmpty) {
      emit(RegisterInformationFailure("جميع الحقول مطلوبة"));
      return;
    }

    // Conditional validation for beard and hijab based on gender
    bool isMale =
        genderController.text == 'male' || genderController.text == 'ذكر';
    bool isFemale =
        genderController.text == 'female' || genderController.text == 'أنثى';

    if (isMale && beardController.text.isEmpty) {
      emit(RegisterInformationFailure("الرجاء اختيار حالة اللحية"));
      return;
    }

    if (isFemale && hijabController.text.isEmpty) {
      emit(RegisterInformationFailure("الرجاء اختيار حالة الحجاب"));
      return;
    }

    var response = await signupRepo.registerInformation(
      RegisterInformationRequestModel(
        nationalId: int.parse(nationalIdController.text),
        countryId: int.parse(countryIdController.text),
        cityId: int.parse(cityIdController.text),
        maritalStatus: maritalStatusController.text,
        typeOfMarriage: typeOfMarriageController.text,
        age: int.parse(ageController.text),
        childrenNumber: int.parse(childrenNumberController.text),
        weight: int.parse(weightController.text),
        height: int.parse(heightController.text),
        skinColor: int.parse(skinColorController.text),
        physique: int.parse(physiqueController.text),
        religiousCommitment: religiousCommitmentController.text,
        prayer: prayerController.text,
        smoking: int.parse(smokingController.text),
        hijab: hijabController.text.isNotEmpty ? hijabController.text : null,
        beard: beardController.text.isNotEmpty ? beardController.text : null,
        educationalQualification:
            int.parse(educationalQualificationController.text),
        financialSituation: int.parse(financialSituationController.text),
        job: jobController.text,
        income: int.parse(incomeController.text),
        healthCondition: int.parse(healthConditionController.text),
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
        // Don't mark user as logged in after signup - they must login first
        // await SharedPreferencesHelper.setIsLoggedIn(true);
        // Clear signup data after successful registration
        await clearSignupData();
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
    beardController.dispose();
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
