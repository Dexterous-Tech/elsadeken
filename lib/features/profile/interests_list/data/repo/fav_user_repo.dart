import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/interests_list/data/data_source/fav_user_data_source.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';


abstract class FavUserRepoInterface {
  Future<Either<ApiErrorModel, UsersResponseModel>> favUsers();
}

class FavUserRepoImpl implements FavUserRepoInterface {
  final FavUserDataSource favUserDataSource;

  FavUserRepoImpl(this.favUserDataSource);

  @override
  Future<Either<ApiErrorModel, UsersResponseModel>> favUsers() async {
    try {
      var response = await favUserDataSource.favUsers();
      return Right(response);
    } catch (error) {
      log("error in fav user $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
