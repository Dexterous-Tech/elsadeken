
import 'package:elsadeken/features/profile/terms_conditions/domain/entities/blog_fetch_result.dart';
import 'package:elsadeken/features/profile/terms_conditions/domain/entities/terms_conditions.dart';

abstract class TermsState {}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsLoaded extends TermsState {
  final List<TermsAndConditions> terms;
  final int? httpStatusCode;
  final int? apiCode;

  TermsLoaded(TermsFetchResult result)
      : terms = result.terms,
        httpStatusCode = result.httpStatusCode,
        apiCode = result.apiCode;
}

class TermsError extends TermsState {
  final String message;
  TermsError(this.message);
}
