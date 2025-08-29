
import 'package:elsadeken/features/profile/terms_conditions/domain/entities/blog_fetch_result.dart';
import 'package:elsadeken/features/profile/terms_conditions/domain/repository/terms_repo.dart';

class GetBlogPosts {
  final TermsRepo repo;

  GetBlogPosts(this.repo);

  Future<TermsFetchResult> call() => repo.getTerms();
}
/*
class GetBlogPostUseCase {
  final BlogRepository repository;

  const GetBlogPostUseCase(this.repository);

  Future<Either<Failure, BlogPost>> call(String id) async {
    return await repository.getBlogPost(id);
  }
}*/