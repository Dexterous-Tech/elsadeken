import 'package:elsadeken/features/blog/data/datasources/blog_api.dart';
import 'package:elsadeken/features/blog/data/repository/blog_repo_impl.dart';
import 'package:elsadeken/features/blog/domain/repository/blog_repo.dart';
import 'package:elsadeken/features/blog/domain/use_cases/get_blog_posts.dart';
import 'package:elsadeken/features/blog/presentation/cubit/blog_cubit.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository_impl.dart';
import 'package:elsadeken/features/success_stories/data/datasources/success_story_api.dart';
import 'package:elsadeken/features/success_stories/data/repository/success_story_repo_impl.dart';
import 'package:elsadeken/features/success_stories/domain/repository/success_storie_repo.dart';
import 'package:elsadeken/features/success_stories/domain/use_cases/get_success_story.dart';
import 'package:elsadeken/features/success_stories/presentation/cubit/success_story_cubit.dart';
import 'package:get_it/get_it.dart';


import '../../features/search/logic/use_cases/search_use_cases.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchUseCase(sl()));

  // Cubit
  sl.registerFactory(() => SearchCubit(sl()));

  // blog
  sl.registerLazySingleton<BlogApi>(()=> BlogApi());
  sl.registerLazySingleton<GetBlogPosts>(()=> GetBlogPosts(sl()));
  sl.registerLazySingleton<BlogRepo>(()=> BlogRepoImpl(sl()));
  sl.registerFactory<BlogCubit>(()=> BlogCubit(sl()));


  // success stories
  sl.registerLazySingleton<SuccessStoryApi>(()=> SuccessStoryApi());
  sl.registerLazySingleton<GetSuccessStories>(()=> GetSuccessStories(sl()));
  sl.registerLazySingleton<SuccessStoryRepository>(()=> SuccessStoryRepositoryImpl());
  sl.registerFactory<SuccessStoryCubit>(()=> SuccessStoryCubit(sl()));

}
