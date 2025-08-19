import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/my_image/data/data_source/my_image_data_source.dart';
import 'package:elsadeken/features/profile/my_image/data/model/my_image_model.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

abstract class MyImageRepoInterface {
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> updateImage(
      MyImageModel myImageModel);
}

class MyImageRepoImp extends MyImageRepoInterface {
  final MyImageDataSource _myImageDataSource;

  MyImageRepoImp(this._myImageDataSource);

  @override
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> updateImage(
      MyImageModel myImageModel) async {
    try {
      final response = await _myImageDataSource.updateImage(myImageModel);

      return Right(response);
    } catch (e) {
      log("error in image $e");
      if (e is ApiErrorModel) {
        return Left(e);
      }
      return Left(ApiErrorHandler.handle(e));
    }
  }
}
