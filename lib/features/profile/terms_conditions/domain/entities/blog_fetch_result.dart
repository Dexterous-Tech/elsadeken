
import 'package:elsadeken/features/profile/terms_conditions/domain/entities/terms_conditions.dart';

class TermsFetchResult {
  final List<TermsAndConditions> terms;
  final int? httpStatusCode;
  final int? apiCode;

  const TermsFetchResult({
    required this.terms,
    this.httpStatusCode,
    this.apiCode,
  });
}


