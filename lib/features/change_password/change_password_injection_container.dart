import 'package:swa/features/change_password/data/data_sources/new_password_remote_data_source.dart';
import 'package:swa/features/change_password/data/repositories/new_password_repository_impl.dart';
import 'package:swa/features/change_password/domain/repositories/new_password_repository.dart';
import 'package:swa/features/change_password/domain/use_cases/new_password.dart';
import 'package:swa/features/change_password/presentation/cubit/new_password_cubit.dart';
import 'package:swa/features/forgot_password/data/data_sources/forgot_password_remote_data_source.dart';
import 'package:swa/features/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:swa/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';
import 'package:swa/features/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:swa/main.dart';

Future<void> changePasswordDependencyInjectionInit() async {
  //! Features

  // Blocs
  sl.registerFactory<NewPasswordCubit>(() => NewPasswordCubit(newPasswordUseCase: sl()));

  // Use cases
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<NewPassword>(() => NewPassword(newPasswordRepository: sl()));


  // Repository
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<NewPasswordRepository>(() => NewPasswordRepositoryImpl(
    networkInfo: sl(),
    newPasswordRemoteDataSource: sl(),
  ));

  // Data Sources
  sl.registerLazySingleton<NewPasswordRemoteDataSource>(() => NewPasswordRemoteDataSourceImpl(apiConsumer: sl(),));

}