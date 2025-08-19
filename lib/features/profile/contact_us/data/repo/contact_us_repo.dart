import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/contact_us/data/data_source/contact_us_data_source.dart';
import 'package:elsadeken/features/profile/contact_us/data/models/Contact_us_model.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

abstract class ContactUsRepoInterface {
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> contactUs(
    ContactUsModel contactUsModel,
  );
}

class ContactUsRepoImplementation implements ContactUsRepoInterface {
  final ContactUsDataSource _contactUsDataSource;

  ContactUsRepoImplementation(this._contactUsDataSource);

  @override
  Future<Either<ApiErrorModel, ProfileActionResponseModel>> contactUs(
    ContactUsModel contactUsModel,
  ) async {
    try {
      var response = await _contactUsDataSource.contactUs(contactUsModel);
      return Right(response);
    } catch (error) {
      log("error in contact us $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
