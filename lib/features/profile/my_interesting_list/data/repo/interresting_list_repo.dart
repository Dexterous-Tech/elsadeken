import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/fav_user_list.dart';
import 'package:elsadeken/features/profile/my_interesting_list/data/data_source/interesting_list_data_source.dart';


abstract class InterrestingListRepo {
  Future<Either<ApiErrorModel, FavUserListModel>> interestingList();
}

class InterestingRepoImpl implements InterrestingListRepo {
  final InterestingListDataSource interestingListDataSource;

  InterestingRepoImpl(this.interestingListDataSource);

  @override
  Future<Either<ApiErrorModel, FavUserListModel>> interestingList() async {
    try {
      var response = await interestingListDataSource.interestingList();
      return Right(response);
    } catch (error) {
      log("error in interesting list $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
