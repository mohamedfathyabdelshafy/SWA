import 'package:swa/features/sign_in/data/data_sources/login_local_data_source.dart';
import 'package:swa/features/sign_in/data/data_sources/login_remote_data_source.dart';
import 'package:swa/features/sign_in/data/repositories/login_repository_impl.dart';
import 'package:swa/features/sign_in/domain/repositories/login_repository.dart';
import 'package:swa/features/sign_in/domain/use_cases/login.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/main.dart';

Future<void> loginDependencyInjectionInit() async {
  //! Features

  // Blocs
  sl.registerFactory<LoginCubit>(() => LoginCubit(userLoginUseCase: sl(), ));

  // Use cases
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<UserLogin>(() => UserLogin(userRepository: sl()));


  // Repository
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(
    networkInfo: sl(),
    loginLocalDataSource: sl(),
    loginRemoteDataSource: sl(),
  ));

  // Data Sources
  sl.registerLazySingleton<LoginLocalDataSource>(() => LoginLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(apiConsumer: sl(),));

}