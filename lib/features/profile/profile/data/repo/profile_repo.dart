import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/profile/data/data_source/profile_data_source.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

abstract class ProfileRepoInterface {
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> logout();
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> deleteImage();
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> toggleNotify();
}

class ProfileRepoImp implements ProfileRepoInterface {
  final ProfileDataSource _profileDataSource;

  ProfileRepoImp(this._profileDataSource);
  @override
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> logout() async {
    try {
      var response = await _profileDataSource.logout();

      return Right(response);
    } catch (error) {
      log("error in logout $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, ProfileActionResponseModel>>
      deleteImage() async {
    try {
      var response = await _profileDataSource.deleteImage();

      return Right(response);
    } catch (error) {
      log("error in delete image $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, ProfileActionResponseModel>>
      toggleNotify() async {
    try {
      var response = await _profileDataSource.toggleNotify();

      return Right(response);
    } catch (error) {
      log("error in notify $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
