import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/data_source/profile_details_data_source.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/profile_details_action_response_model.dart';

abstract class ProfileDetailsRepoInterface {
  Future<Either<ApiErrorModel, ProfileDetailsActionResponseModel>> ignoreUser(
      String userId);
  Future<Either<ApiErrorModel, ProfileDetailsActionResponseModel>> likeUser(
      String userId);
}

class ProfileDetailsRepoImp extends ProfileDetailsRepoInterface {
  final ProfileDetailsDataSource profileDetailsDataSource;

  ProfileDetailsRepoImp(this.profileDetailsDataSource);
  @override
  Future<Either<ApiErrorModel, ProfileDetailsActionResponseModel>> ignoreUser(
      String userId) async {
    try {
      var response = await profileDetailsDataSource.ignoreUser(userId);
      return Right(response);
    } catch (error) {
      log("error in ignore user $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, ProfileDetailsActionResponseModel>> likeUser(
      String userId) async {
    try {
      var response = await profileDetailsDataSource.likeUser(userId);
      return Right(response);
    } catch (error) {
      log("error in like user $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
