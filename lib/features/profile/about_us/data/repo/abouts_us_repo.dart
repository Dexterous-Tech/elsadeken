import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/profile/about_us/data/models/about_us_model.dart';
import 'package:elsadeken/features/profile/about_us/data/data_source/about_us_data_source.dart';

abstract class AboutsUsRepoInterface{

  Future<Either<ApiErrorModel , AboutUsResponseModel>>  aboutUs();
}

class AboutsUsRepoImpl implements AboutsUsRepoInterface{

  final AboutUsDataSource aboutUsDataSource;

  AboutsUsRepoImpl(this.aboutUsDataSource);

  @override
  Future<Either<ApiErrorModel, AboutUsResponseModel>> aboutUs() async {
   try{
     var response = await aboutUsDataSource.aboutUs();

     return Right(response);
   }catch(error){
     log("error in about us $error");
     if(error is ApiErrorModel){
       return Left(error);
     }
     return Left(ApiErrorHandler.handle(error));
   }
  }
}