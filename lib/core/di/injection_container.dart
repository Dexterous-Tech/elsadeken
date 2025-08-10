import 'package:elsadeken/features/auth/login/data/data_source/login_data_source.dart';
import 'package:elsadeken/features/auth/login/data/repo/login_repo.dart';
import 'package:elsadeken/features/auth/login/presentation/manager/login_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository.dart';
import 'package:elsadeken/features/search/logic/repository/search_repository_impl.dart';
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
  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchUseCase(sl()));

  // Cubit
  sl.registerFactory(() => SearchCubit(sl()));

  // login
  sl.registerLazySingleton<LoginDataSource>(() => LoginDataSource(sl()));
  sl.registerLazySingleton<LoginRepoInterface>(
      () => LoginRepoImplementation(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
}
