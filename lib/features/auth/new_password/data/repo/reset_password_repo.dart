import 'package:dartz/dartz.dart';
import '../../../../../core/networking/api_error_handler.dart';
import '../../../../../core/networking/api_error_model.dart';
import '../data_source/reset_password_data_source.dart';
import '../models/reset_password_models.dart';

abstract class ResetPasswordRepoInterface {
  Future<Either<ApiErrorModel, ResetPasswordResponseModel>> resetPassword(
      ResetPasswordRequestBodyModel resetPasswordRequestBodyModel,
  );
}

class ResetPasswordRepoImplementation implements ResetPasswordRepoInterface {
  final ResetPasswordDataSource _resetPasswordDataSource;

  ResetPasswordRepoImplementation(this._resetPasswordDataSource);

  @override
  Future<Either<ApiErrorModel, ResetPasswordResponseModel>> resetPassword(
    ResetPasswordRequestBodyModel resetPasswordRequestBodyModel,
  ) async {
    try {
      var response =
          await _resetPasswordDataSource.resetPassword(resetPasswordRequestBodyModel);
      return Right(response);
    } catch (error) {
      // Error is already parsed by ApiServices, so we just need to cast it
      if (error is ApiErrorModel) {
        return Left(error);
      }
      // Fallback (shouldn't normally happen)
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
