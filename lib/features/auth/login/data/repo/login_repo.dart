import 'package:dartz/dartz.dart';
import '../../../../../core/networking/api_error_handler.dart';
import '../../../../../core/networking/api_error_model.dart';
import '../data_source/login_data_source.dart';
import '../models/login_models.dart';
abstract class LoginRepoInterface{
   Future<Either<ApiErrorModel, LoginResponseModel>> login(LoginRequestBodyModel loginRequestBodyModel,);
}

class LoginRepoImplementation  implements LoginRepoInterface{
  final LoginDataSource _loginDataSource;

  LoginRepoImplementation(this._loginDataSource);

  @override
  Future<Either<ApiErrorModel, LoginResponseModel>> login(
      LoginRequestBodyModel loginRequestBodyModel,
      ) async {
    try {
      var response = await _loginDataSource.login(loginRequestBodyModel);
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
