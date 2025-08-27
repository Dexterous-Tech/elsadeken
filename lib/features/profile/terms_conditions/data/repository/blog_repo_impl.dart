// lib/features/blog/data/repositories/success_story_repo_impl.dart

import 'package:elsadeken/features/profile/terms_conditions/domain/entities/blog_fetch_result.dart';
import 'package:elsadeken/features/profile/terms_conditions/domain/repository/terms_repo.dart';

import '../datasources/terms_api.dart';

class TermsRepoImpl implements TermsRepo {
  final TermsApi api;

  TermsRepoImpl(this.api);

  @override
  Future<TermsFetchResult> getTerms() async {
    return api.getTerms();
  }
}
