import 'package:elsadeken/features/auth/forget_password/data/data_source/forget_data_source.dart';
import 'package:elsadeken/features/auth/forget_password/data/repo/forget_repo.dart';
import 'package:elsadeken/features/auth/forget_password/presentation/manager/forget_cubit.dart';
import 'package:elsadeken/features/auth/login/data/data_source/login_data_source.dart';
import 'package:elsadeken/features/auth/login/data/repo/login_repo.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_cubit.dart';
import 'package:elsadeken/features/auth/new_password/data/data_source/reset_password_data_source.dart';
import 'package:elsadeken/features/auth/new_password/data/repo/reset_password_repo.dart';
import 'package:elsadeken/features/auth/new_password/presentation/manager/reset_password_cubit.dart';
import 'package:elsadeken/features/auth/signup/data/data_source/signup_data_source.dart';
import 'package:elsadeken/features/auth/signup/data/repo/signup_repo.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/sign_up_lists_cubit.dart';
import 'package:elsadeken/features/auth/signup/presentation/manager/signup_cubit.dart';
import 'package:elsadeken/features/auth/verification_email/data/data_source/verification_data_source.dart';
import 'package:elsadeken/features/auth/verification_email/data/repo/verification_repo.dart';
import 'package:elsadeken/features/auth/verification_email/presentation/manager/verification_cubit.dart';
import 'package:elsadeken/features/profile/about_us/data/data_source/about_us_data_source.dart';
import 'package:elsadeken/features/profile/about_us/data/repo/abouts_us_repo.dart';
import 'package:elsadeken/features/profile/about_us/presentation/manager/about_us_cubit.dart';
import 'package:elsadeken/features/profile/blog/data/datasources/blog_api.dart';
import 'package:elsadeken/features/profile/blog/data/repository/blog_repo_impl.dart';
import 'package:elsadeken/features/profile/blog/domain/repository/blog_repo.dart';
import 'package:elsadeken/features/profile/blog/domain/use_cases/get_blog_posts.dart';
import 'package:elsadeken/features/profile/blog/presentation/cubit/blog_cubit.dart';
import 'package:elsadeken/features/profile/success_stories/data/datasources/success_story_api.dart';
import 'package:elsadeken/features/profile/success_stories/data/repository/success_story_repo_impl.dart';
import 'package:elsadeken/features/profile/success_stories/domain/repository/success_storie_repo.dart';
import 'package:elsadeken/features/profile/success_stories/domain/use_cases/get_success_story.dart';
import 'package:elsadeken/features/profile/success_stories/presentation/cubit/success_story_cubit.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../features/search/logic/use_cases/search_use_cases.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../networking/api_services.dart';
import '../networking/dio_factory.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize Dio
  final dio = await DioFactory.getDio();

  // Register ApiServices as a singleton
  sl.registerSingleton<ApiServices>(ApiServices.internal(dio));
  // HTTP Client
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(
        baseUrl: 'https://elsadkeen.sharetrip-ksa.com/api',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      )));
  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchUseCase(sl()));

  // Cubit
  sl.registerFactory(() => SearchCubit(sl()));

  // blog
  sl.registerLazySingleton<BlogApi>(() => BlogApi(sl<Dio>()));
  sl.registerLazySingleton<BlogRepo>(() => BlogRepoImpl(sl()));
  sl.registerLazySingleton<GetBlogPosts>(() => GetBlogPosts(sl()));
  sl.registerFactory<BlogCubit>(() => BlogCubit(sl()));

  // success stories
  sl.registerLazySingleton<SuccessStoryApi>(() => SuccessStoryApi());
  sl.registerLazySingleton<GetSuccessStories>(() => GetSuccessStories(sl()));
  sl.registerLazySingleton<SuccessStoryRepository>(
      () => SuccessStoryRepositoryImpl());
  sl.registerFactory<SuccessStoryCubit>(() => SuccessStoryCubit(sl()));

  // login
  sl.registerLazySingleton<LoginDataSource>(() => LoginDataSource(sl()));
  sl.registerLazySingleton<LoginRepoInterface>(
      () => LoginRepoImplementation(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));

  //forget
  sl.registerLazySingleton<ForgetDataSource>(() => ForgetDataSource(sl()));
  sl.registerLazySingleton<ForgetRepoInterface>(
      () => ForgetRepoImplementation(sl()));
  sl.registerFactory<ForgetCubit>(() => ForgetCubit(sl()));

  //verification
  sl.registerLazySingleton<VerificationDataSource>(
      () => VerificationDataSource(sl()));
  sl.registerLazySingleton<VerificationRepoInterface>(
      () => VerificationRepoImplementation(sl()));
  sl.registerFactory<VerificationCubit>(() => VerificationCubit(sl()));

  //reset password
  sl.registerLazySingleton<ResetPasswordDataSource>(
      () => ResetPasswordDataSource(sl()));
  sl.registerLazySingleton<ResetPasswordRepoInterface>(
      () => ResetPasswordRepoImplementation(sl()));
  sl.registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(sl()));

  // signup
  sl.registerLazySingleton<SignupDataSource>(() => SignupDataSource(sl()));
  sl.registerLazySingleton<SignupRepoInterface>(
      () => SignupRepoImplementation(sl()));
  sl.registerFactory<SignupCubit>(() => SignupCubit(sl()));
  sl.registerFactory<SignUpListsCubit>(() => SignUpListsCubit(sl()));

  // about us
  sl.registerLazySingleton<AboutUsDataSource>(() => AboutUsDataSource(sl()));
  sl.registerLazySingleton<AboutsUsRepoInterface>(() => AboutsUsRepoImpl(sl()));
  sl.registerFactory<AboutUsCubit>(() => AboutUsCubit(sl()));
}
