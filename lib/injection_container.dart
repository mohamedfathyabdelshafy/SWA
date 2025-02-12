import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/http_consumer.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/main.dart';

Future<void> dependencyInjectionInit() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() =>
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker.instance));
  sl.registerLazySingleton<ApiConsumer>(
      () => HttpConsumer(client: sl(), sharedPreferences: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
  sl.registerLazySingleton(() => http.Client());
}
