import 'package:swa/features/sign_up/data/data_sources/register_remote_data_source.dart';
import 'package:swa/features/sign_up/data/repositories/register_repository_impl.dart';
import 'package:swa/features/sign_up/domain/repositories/register_repository.dart';
import 'package:swa/features/sign_up/domain/use_cases/register.dart';
import 'package:swa/features/sign_up/presentation/cubit/register_cubit.dart';
import 'package:swa/main.dart';

Future<void> registerDependencyInjectionInit() async {
  //! Features

  // Blocs
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(registerUserUseCase: sl(), ));

  // Use cases
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<RegisterUser>(() => RegisterUser(registerRepository: sl()));


  // Repository
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<RegisterRepository>(() => RegisterRepositoryImpl(
    networkInfo: sl(),
    registerRemoteDataSource: sl(),
  ));

  // Data Sources
  sl.registerLazySingleton<RegisterRemoteDataSource>(() => RegisterRemoteDataSourceImpl(apiConsumer: sl(),));

}