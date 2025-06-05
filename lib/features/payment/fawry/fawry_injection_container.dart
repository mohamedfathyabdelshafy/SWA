import 'package:swa/features/payment/fawry/data/data_sources/fawry_remote_data_source.dart';
import 'package:swa/features/payment/fawry/data/repositories/fawry_repository_impl.dart';
import 'package:swa/features/payment/fawry/domain/repositories/fawry_repository.dart';
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/fawry/presentation/cubit/fawry_cubit.dart';
import 'package:swa/main.dart';

Future<void> fawryDependencyInjectionInit() async {
  //! Features

  // Blocs
  sl.registerFactory<FawryCubit>(() => FawryCubit(fawryUseCase: sl()));

  // Use cases
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<FawryUseCase>(() => FawryUseCase(fawryPaymentRepository: sl()));


  // Repository
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<FawryPaymentRepository>(() => FawryPaymentRepositoryImpl(
    networkInfo: sl(),
    fawryRemoteDataSource: sl(),
  ));

  // Data Sources
  sl.registerLazySingleton<FawryRemoteDataSource>(() => FawryRemoteDataSourceImpl(apiConsumer: sl(),));

}