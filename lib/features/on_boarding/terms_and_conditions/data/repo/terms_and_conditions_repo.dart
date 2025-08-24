import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/data/models/terms_and_conditions_model.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/data/data_source/terms_and_conditions_data_source.dart';

abstract class TermsAndConditionsRepoInterface{

  Future<Either<ApiErrorModel , TermsAndConditionsResponseModel>>  getTermsAndConditions();
}

class TermsAndConditionsRepoImpl implements TermsAndConditionsRepoInterface{

  final TermsAndConditionsDataSource termsAndConditionsDataSource;

  TermsAndConditionsRepoImpl(this.termsAndConditionsDataSource);

  @override
  Future<Either<ApiErrorModel, TermsAndConditionsResponseModel>> getTermsAndConditions() async {
   try{
     var response = await termsAndConditionsDataSource.getTermsAndConditions();

     return Right(response);
   }catch(error){
     log("error in terms and conditions $error");
     if(error is ApiErrorModel){
       return Left(error);
     }
     return Left(ApiErrorHandler.handle(error));
   }
  }
}
