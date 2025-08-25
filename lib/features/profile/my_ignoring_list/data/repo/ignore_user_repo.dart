import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/data/data_source/ignore_user_data_source.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';

abstract class IgnoreUserRepoInterface {
  Future<Either<ApiErrorModel, UsersResponseModel>> ignoreUsers({int? page});
}

class IgnoreUserRepoImpl implements IgnoreUserRepoInterface {
  final IgnoreUserDataSource ignoreUserDataSource;

  IgnoreUserRepoImpl(this.ignoreUserDataSource);

  @override
  Future<Either<ApiErrorModel, UsersResponseModel>> ignoreUsers(
      {int? page}) async {
    try {
      var response = await ignoreUserDataSource.ignoreUsers(page: page);
      return Right(response);
    } catch (error) {
      log("error in ignore user $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
