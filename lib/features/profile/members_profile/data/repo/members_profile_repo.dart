import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/members_profile/data/data_source/members_profile_data_source.dart';
import 'package:elsadeken/features/profile/members_profile/data/model/members_profile_response_model.dart';

abstract class MembersProfileRepoInterface {
  Future<Either<ApiErrorModel, MembersProfileResponseModel>> getMembersProfile(
      int countryId);
}

class MembersProfileRepoImp implements MembersProfileRepoInterface {
  final MembersProfileDataSource membersProfileDataSource;

  MembersProfileRepoImp(this.membersProfileDataSource);

  @override
  Future<Either<ApiErrorModel, MembersProfileResponseModel>> getMembersProfile(
      int countryId) async {
    try {
      var response =
          await membersProfileDataSource.getMembersProfile(countryId);
      return Right(response);
    } catch (error) {
      log("error in get members profile $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
