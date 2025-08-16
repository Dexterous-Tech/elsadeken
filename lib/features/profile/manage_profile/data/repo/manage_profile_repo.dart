import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/manage_profile/data/data_source/manage_profile_data_source.dart';
import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';

abstract class ManageProfileRepoInterface {
  Future<Either<ApiErrorModel, MyProfileResponseModel>> getProfile();
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
}
