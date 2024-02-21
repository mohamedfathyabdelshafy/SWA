import 'package:swa/features/app_info/data/data_sources/app_info_remote_data_source.dart';
import 'package:swa/features/app_info/data/repositories/app_info_repo_impl.dart';
import 'package:swa/features/app_info/domain/repositories/app_info_repository.dart';
import 'package:swa/features/app_info/domain/use_cases/get_available_countries_usecase.dart';
import 'package:swa/features/app_info/domain/use_cases/get_country_cities_usecase.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_country_cities_cubit/get_available_country_cities_cubit.dart';
import 'package:swa/main.dart';

Future<void> appInfoDependencyInjectionContainerInit() async {
  //! Features
  // Blocs
  sl.registerFactory<GetAvailableCountriesCubit>(
      () => GetAvailableCountriesCubit(getAvailableCountriesUseCase: sl()));
  sl.registerFactory<GetAvailableCountryCitiesCubit>(() =>
      GetAvailableCountryCitiesCubit(getAvailableCountryCitiesUseCase: sl()));
  // Use cases
  sl.registerLazySingleton<GetAvailableCountriesUseCase>(
      () => GetAvailableCountriesUseCase(repository: sl()));

  sl.registerLazySingleton<GetAvailableCountryCitiesUseCase>(
      () => GetAvailableCountryCitiesUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AppInfoRepository>(
      () => AppInfoRepoImpl(remoteDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<AppInfoRemoteDataSource>(
      () => AppInfoRemoteDataSourceImpl(apiConsumer: sl()));
}
