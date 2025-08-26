import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/manage_profile/data/data_source/manage_profile_data_source.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/update_profile_models.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

abstract class ManageProfileRepoInterface {
  Future<Either<ApiErrorModel, MyProfileResponseModel>> getProfile();
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> deleteAccount();
  Future<Either<ApiErrorModel, MyProfileResponseModel>> updateProfileLoginData(
      UpdateProfileLoginDataRequestModel updateProfileData);
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileLocationData(
          UpdateProfileLocationDataModel updateProfileData);
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileMarriageData(
          UpdateProfileMarriageDataModel updateProfileData);
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfilePhysicalData(
          UpdateProfilePhysicalDataModel updateProfileData);
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileReligiousData(
          UpdateProfileReligiousDataModel updateProfileData);
  Future<Either<ApiErrorModel, MyProfileResponseModel>> updateProfileWorkData(
      UpdateProfileWorkDataModel updateProfileData);
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileAboutMeData(UpdateProfileAboutMeDataModel updateProfileData);
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileAboutPartnerData(
          UpdateProfileAboutPartnerDataModel updateProfileData);
}

class ManageProfileRepoImp implements ManageProfileRepoInterface {
  final ManageProfileDataSource manageProfileDataSource;

  ManageProfileRepoImp(this.manageProfileDataSource);
  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>> getProfile() async {
    try {
      var response = await manageProfileDataSource.getProfile();
      return Right(response);
    } catch (error) {
      log("error in get profile $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, ProfileActionResponseModel>>
      deleteAccount() async {
    try {
      var response = await manageProfileDataSource.deleteAccount();
      return Right(response);
    } catch (error) {
      log("error in delete profile $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>> updateProfileLoginData(
      UpdateProfileLoginDataRequestModel updateProfileData) async {
    try {
      var response = await manageProfileDataSource
          .updateProfileLoginData(updateProfileData);
      return Right(response);
    } catch (error) {
      log("error in update profile login data $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileLocationData(
          UpdateProfileLocationDataModel updateProfileData) async {
    try {
      var response = await manageProfileDataSource
          .updateProfileLocationData(updateProfileData);
      return Right(response);
    } catch (error) {
      log("error in update profile location data $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileMarriageData(
          UpdateProfileMarriageDataModel updateProfileData) async {
    try {
      var response = await manageProfileDataSource
          .updateProfileMarriageData(updateProfileData);
      return Right(response);
    } catch (error) {
      log("error in update profile marriage data $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfilePhysicalData(
          UpdateProfilePhysicalDataModel updateProfileData) async {
    try {
      var response = await manageProfileDataSource
          .updateProfilePhysicalData(updateProfileData);
      return Right(response);
    } catch (error) {
      log("error in update profile physical data $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileReligiousData(
          UpdateProfileReligiousDataModel updateProfileData) async {
    try {
      var response = await manageProfileDataSource
          .updateProfileReligiousData(updateProfileData);
      return Right(response);
    } catch (error) {
      log("error in update profile religious data $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>> updateProfileWorkData(
      UpdateProfileWorkDataModel updateProfileData) async {
    try {
      var response = await manageProfileDataSource
          .updateProfileWorkData(updateProfileData);
      return Right(response);
    } catch (error) {
      log("error in update profile work data $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileAboutMeData(
          UpdateProfileAboutMeDataModel updateProfileData) async {
    try {
      var response = await manageProfileDataSource
          .updateProfileAboutMeData(updateProfileData);
      return Right(response);
    } catch (error) {
      log("error in update profile about me data $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, MyProfileResponseModel>>
      updateProfileAboutPartnerData(
          UpdateProfileAboutPartnerDataModel updateProfileData) async {
    try {
      var response = await manageProfileDataSource
          .updateProfileAboutPartnerData(updateProfileData);
      return Right(response);
    } catch (error) {
      log("error in update profile about partner data $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
