import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/excellence_package/data/data_source/packages_data_source.dart';
import 'package:elsadeken/features/profile/excellence_package/data/models/packages_model.dart';

abstract class PackagesRepoInterface {
  Future<Either<ApiErrorModel, PackagesModel>> getPackages();
  Future<Either<ApiErrorModel, PackagesModel>> assignPackageToUser(String id);

}

class PackagesRepoImpl extends PackagesRepoInterface {
  final PackagesDataSource packagesDataSource;

  PackagesRepoImpl(this.packagesDataSource);
  @override
  Future<Either<ApiErrorModel, PackagesModel>> getPackages() async {
    try {
      var response = await packagesDataSource.getPackages();
      return Right(response);
    } catch (error) {
      log("error in get packages $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, PackagesModel>> assignPackageToUser(String id) async {
    try {
      var response = await packagesDataSource.assignPackageToUser(id);
      return Right(response);
    } catch (error) {
      log("error in assign package to user $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
