
import 'package:elsadeken/features/profile/terms_conditions/domain/entities/blog_fetch_result.dart';

abstract class TermsRepo {
  Future<TermsFetchResult> getTerms();
}
//Future<Either<Failure, BlogPost>> getBlogPost(String id);