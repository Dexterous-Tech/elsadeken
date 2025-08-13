import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../../core/networking/api_error_handler.dart';
import '../../../../../core/networking/api_error_model.dart';
import '../data_source/forget_data_source.dart';
import '../models/forget_models.dart';

abstract class ForgetRepoInterface {
  Future<Either<ApiErrorModel, ForgetResponseModel>> forgetPassword(
    ForgetRequestBodyModel forgetRequestBodyModel,
  );
}

class ForgetRepoImplementation implements ForgetRepoInterface {
  final ForgetDataSource _forgetDataSource;

  ForgetRepoImplementation(this._forgetDataSource);

  @override
  Future<Either<ApiErrorModel, ForgetResponseModel>> forgetPassword(
    ForgetRequestBodyModel forgetRequestBodyModel,
  ) async {
    try {
      var response =
          await _forgetDataSource.forgetPassword(forgetRequestBodyModel);
      return Right(response);
    } catch (error) {
      log("error in forget password $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      // Fallback (shouldn't normally happen)
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
