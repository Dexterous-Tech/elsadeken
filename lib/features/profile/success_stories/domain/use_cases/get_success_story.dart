

import '../entities/success_storie.dart';
import '../repository/success_storie_repo.dart';

class GetSuccessStories {
  final SuccessStoryRepository repository;

  GetSuccessStories(this.repository);

  Future<List<SuccessStoryEntity>> call() {
    return repository.getStories();
  }
}

/*
class GetBlogPostUseCase {
  final BlogRepository repository;

  const GetBlogPostUseCase(this.repository);

  Future<Either<Failure, BlogPost>> call(String id) async {
    return await repository.getBlogPost(id);
  }
}*/