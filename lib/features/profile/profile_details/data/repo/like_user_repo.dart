import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/data_source/like_user_data_source.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/like_user_model.dart';


abstract class LikeUserRepoInterface {
  Future<Either<ApiErrorModel, LikeUserResponseModel>> likeUser(String userId);
}

class LikeUserRepoImpl implements LikeUserRepoInterface {
  final LikeUserDataSource likeUserDataSource;

  LikeUserRepoImpl(this.likeUserDataSource);

  @override
  Future<Either<ApiErrorModel, LikeUserResponseModel>> likeUser(String userId) async {
    try {
      var response = await likeUserDataSource.likeUser(userId);
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
