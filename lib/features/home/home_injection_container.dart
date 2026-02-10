import 'package:swa/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:swa/features/home/data/repositories/home_repository_impl.dart';
import 'package:swa/features/home/domain/repositories/home_repository.dart';
import 'package:swa/features/home/domain/use_cases/get_from_stations_list_data.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/main.dart';

Future<void> homeDependencyInjectionInit() async {
  //! Features

  // Blocs
  sl.registerFactory<HomeCubit>(() => HomeCubit(getFromStationsListDataUseCase: sl(), getToStationsListDataUseCase: sl()));

  // Use cases
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<GetFromStationsListDataUseCase>(() => GetFromStationsListDataUseCase(homeRepository: sl()));
  sl.registerLazySingleton<GetToStationsListDataUseCase>(() => GetToStationsListDataUseCase(homeRepository: sl()));

  // Repository
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
    networkInfo: sl(),
    homeRemoteDataSource: sl(),
  ));

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(apiConsumer: sl(),));

}