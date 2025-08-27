import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/my_excellence/data/data_source/features_data_source.dart';
import 'package:elsadeken/features/profile/my_excellence/data/models/features_model.dart';

abstract class FeaturesRepoInterface {
  Future<Either<ApiErrorModel, FeaturesModel>> getFeatures();
}

class FeaturesRepoImpl extends FeaturesRepoInterface {
  final FeaturesDataSource featuresDataSource;

  FeaturesRepoImpl(this.featuresDataSource);
  @override
  Future<Either<ApiErrorModel, FeaturesModel>> getFeatures() async {
    try {
      var response = await featuresDataSource.getFeatures();
      return Right(response);
    } catch (error) {
      log("error in get features $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
