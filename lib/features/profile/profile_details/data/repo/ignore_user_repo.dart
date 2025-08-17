import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/data_source/ignore_user_data_source.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/like_user_model.dart';


abstract class IgnoreUserRepo {
  Future<Either<ApiErrorModel, LikeUserResponseModel>> ignoreUser(String userId);
}

class IgnoreUserRepoImpl implements IgnoreUserRepo {
  final IgnoreUserDataSource ignoreUserDataSource;

  IgnoreUserRepoImpl(this.ignoreUserDataSource);

  @override
  Future<Either<ApiErrorModel, LikeUserResponseModel>> ignoreUser(String userId) async {
    try {
      var response = await ignoreUserDataSource.ignoreUser(userId);
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
