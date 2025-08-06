import 'package:get_it/get_it.dart';

import '../../features/search/logic/repository/search_repository.dart';
import '../../features/search/logic/repository/search_repository_impl.dart';
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
}
