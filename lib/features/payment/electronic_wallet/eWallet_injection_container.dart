import 'package:swa/features/payment/electronic_wallet/data/data_sources/ewallet_remote_data_source.dart';
import 'package:swa/features/payment/electronic_wallet/data/repositories/eWallet_repository_impl.dart';
import 'package:swa/features/payment/electronic_wallet/domain/repositories/eWallet_repository.dart';
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/cubit/eWallet_cubit.dart';
import 'package:swa/main.dart';

Future<void> eWalletDependencyInjectionInit() async {
  //! Features

  // Blocs
  sl.registerFactory<EWalletCubit>(() => EWalletCubit(eWalletUseCase: sl()));
  // Use cases
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<EWalletUseCase>(() => EWalletUseCase(eWalletPaymentRepository: sl()));


  // Repository
  //We use lazy we don't need to load the whole app
  sl.registerLazySingleton<EWalletPaymentRepository>(() => EWalletPaymentRepositoryImpl(
    networkInfo: sl(),
    eWalletRemoteDataSource: sl(),
  ));

  // Data Sources
  sl.registerLazySingleton<EWalletRemoteDataSource>(() => EWalletRemoteDataSourceImpl(apiConsumer: sl(),));

}