import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/auth/signup/data/data_source/signup_data_source.dart';
import 'package:elsadeken/features/auth/signup/data/models/cities_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/national_country_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/auth/signup/data/models/signup_models.dart';

abstract class SignupRepoInterface {
  Future<Either<ApiErrorModel, List<NationalCountryResponseModel>>>
      getNationalities();
  Future<Either<ApiErrorModel, List<NationalCountryResponseModel>>>
      getCountries();
  Future<Either<ApiErrorModel, List<CityResponseModels>>> getCites(String id);
  Future<Either<ApiErrorModel, List<GeneralInfoResponseModels>>> getGeneralInfo(
      String endpoint);
  Future<Either<ApiErrorModel, SignupResponseModel>> signup(
      SignupRequestBodyModel signupRequestBody);
  Future<Either<ApiErrorModel, RegisterInformationResponseModel>>
      registerInformation(RegisterInformationRequestModel registerRequestModel);
}

class SignupRepoImplementation implements SignupRepoInterface {
  final SignupDataSource _signupDataSource;

  SignupRepoImplementation(this._signupDataSource);
  @override
  Future<Either<ApiErrorModel, List<CityResponseModels>>> getCites(
      String id) async {
    try {
      var response = await _signupDataSource.getCities(id);
      return Right(response);
    } catch (error) {
      log("error in cities $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<NationalCountryResponseModel>>>
      getCountries() async {
    try {
      var response = await _signupDataSource.getCountries();
      return Right(response);
    } catch (error) {
      log("error in countries $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      // Fallback (shouldn't normally happen)
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<NationalCountryResponseModel>>>
      getNationalities() async {
    try {
      var response = await _signupDataSource.getNationalities();
      return Right(response);
    } catch (error) {
      log("error in nationalities $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      // Fallback (shouldn't normally happen)
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, SignupResponseModel>> signup(
      SignupRequestBodyModel signupRequestBody) async {
    try {
      var response = await _signupDataSource.signup(signupRequestBody);
      return Right(response);
    } catch (error) {
      log("error in signup $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      // Fallback (shouldn't normally happen)
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, RegisterInformationResponseModel>>
      registerInformation(
          RegisterInformationRequestModel registerRequestModel) async {
    try {
      var response =
          await _signupDataSource.registerInformation(registerRequestModel);
      return Right(response);
    } catch (error) {
      log("error in register information $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      // Fallback (shouldn't normally happen)
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<GeneralInfoResponseModels>>> getGeneralInfo(
      String endpoint) async {
    try {
      var response = await _signupDataSource.getGeneralInfo(endpoint);
      return Right(response);
    } catch (error) {
      log("error in general info $endpoint $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
