import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/features/profile/terms_conditions/data/data_source/terms_conditions_data_source.dart';

import '../../../../../core/networking/api_error_handler.dart';
import '../../../../../core/networking/api_error_model.dart';
import '../../../about_us/data/models/about_us_model.dart';

abstract class TermsConditionsRepoInterface {
  Future<Either<ApiErrorModel, AboutUsResponseModel>> termsConditions();
}

class TermsConditionsRepoImpl implements TermsConditionsRepoInterface {
  final TermsConditionsDataSource termsConditionsDataSource;

  TermsConditionsRepoImpl(this.termsConditionsDataSource);

  @override
  Future<Either<ApiErrorModel, AboutUsResponseModel>> termsConditions() async {
    try {
      var response = await termsConditionsDataSource.termsConditions();

      return Right(response);
    } catch (error) {
      log("error in  terms conditions $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
