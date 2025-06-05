import 'package:swa/features/forgot_password/data/data_sources/forgot_password_remote_data_source.dart';
import 'package:swa/features/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:swa/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:swa/features/forgot_password/domain/repositories/submit_password_repository.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';
import 'package:swa/features/forgot_password/domain/use_cases/submit_password.dart';
import 'package:swa/features/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:swa/main.dart';

import 'data/repositories/submit_password_repository_impl.dart';

Future<void> forgotPasswordDependencyInjectionInit() async {
  //! Features

  // Blocs
  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(
      forgotPasswordUseCase: sl(), submitPasswordUseCase: sl()));

  // Use cases
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<ForgotPassword>(
      () => ForgotPassword(forgotPasswordRepository: sl()));

  sl.registerLazySingleton<SubmitPassword>(
      () => SubmitPassword(submitPasswordRepository: sl()));

  // Repository
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<ForgotPasswordRepository>(
      () => ForgotPasswordRepositoryImpl(
            networkInfo: sl(),
            forgotPasswordRemoteDataSource: sl(),
          ));

  sl.registerLazySingleton<SubmitPasswordRepository>(
      () => SubmitPasswordRepositoryImpl(
            networkInfo: sl(),
            forgotPasswordRemoteDataSource: sl(),
          ));
  // Data Sources
  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
      () => ForgotPasswordRemoteDataSourceImpl(
            apiConsumer: sl(),
          ));
}
