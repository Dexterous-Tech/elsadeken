import 'package:dartz/dartz.dart';
import '../../../../../core/networking/api_error_handler.dart';
import '../../../../../core/networking/api_error_model.dart';
import '../data_source/verification_data_source.dart';
import '../models/verification_models.dart';

abstract class VerificationRepoInterface {
  Future<Either<ApiErrorModel, VerificationResponseModel>> verifyOtp(
    VerificationRequestBodyModel verificationRequestBodyModel,
  );
}

class VerificationRepoImplementation implements VerificationRepoInterface {
  final VerificationDataSource _verificationDataSource;

  VerificationRepoImplementation(this._verificationDataSource);

  @override
  Future<Either<ApiErrorModel, VerificationResponseModel>> verifyOtp(
    VerificationRequestBodyModel verificationRequestBodyModel,
  ) async {
    try {
      var response =
          await _verificationDataSource.verifyOtp(verificationRequestBodyModel);
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
