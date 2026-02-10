import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/http_consumer.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/core/utils/phone_number_validator_srrvice.dart';
import 'package:swa/features/payment/select_payment/presentation/data/remote/payment_methods_rds.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/reusable_payment/data/repo/payment_methods_repo.dart';
import 'package:swa/main.dart';

Future<void> dependencyInjectionInit() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
      connectionChecker: InternetConnectionChecker.createInstance()));
  sl.registerLazySingleton<ApiConsumer>(
      () => HttpConsumer(client: sl(), sharedPreferences: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<PhoneNumberValidatorService>(
      () => PhoneNumberValidatorServiceImp());

  // ! Payment Methods
  sl.registerSingleton<PaymentMethodsRDS>(
      PaymentMethodsRDSImpl(apiConsumer: sl<ApiConsumer>()));

  sl.registerSingleton<PaymentMethodsRepo>(
      PaymentMethodsRepoImpl(paymentMethodsRDS: sl<PaymentMethodsRDS>()));
  sl.registerSingleton<MyWalletRepo>(MyWalletRepo(sl<ApiConsumer>()));
}
