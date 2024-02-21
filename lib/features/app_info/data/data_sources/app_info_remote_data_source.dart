import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/features/app_info/data/models/city_model.dart';
import 'package:swa/features/app_info/data/models/country_model.dart';

abstract class AppInfoRemoteDataSource {
  Future<List<CountryModel>> getAvailableCountries();
  Future<List<CityModel>> getAvailableCountryCities(int countryId);
}

class AppInfoRemoteDataSourceImpl implements AppInfoRemoteDataSource {
  final ApiConsumer apiConsumer;
  AppInfoRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<CountryModel>> getAvailableCountries() async {
    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52'
    };
    var request = http.Request(
        'GET', Uri.parse('${EndPoints.baseUrl}Country/GetCountry'));

    request.headers.addAll(headers);

    print(' body ' + request.body);

    http.StreamedResponse response = await request.send();
    Map<String, dynamic> jsonResponse =
        jsonDecode(await response.stream.bytesToString());
    print(jsonResponse);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == "success") {
        return (jsonResponse["message"] as List)
            .map((e) => CountryModel.fromJson(e))
            .toList();
      }
    }
    throw ServerException(jsonResponse["message"]?.toString());
  }

  @override
  Future<List<CityModel>> getAvailableCountryCities(int countryId) async {
    var headers = {
      'Content-Type': 'application/json',
      'APIKey': '546548dwfdfsd3f4sdfhgat52'
    };
    var request = http.Request('GET',
        Uri.parse('${EndPoints.baseUrl}City/GetCity?countryID=$countryId'));

    request.headers.addAll(headers);

    print(' body ' + request.body);

    http.StreamedResponse response = await request.send();
    Map<String, dynamic> jsonResponse =
        jsonDecode(await response.stream.bytesToString());
    print(jsonResponse);

    if (response.statusCode == 200) {
      if (jsonResponse["status"] == "success") {
        return (jsonResponse["message"] as List)
            .map((e) => CityModel.fromJson(e))
            .toList();
      }
    }
    throw ServerException(jsonResponse["message"]?.toString());
  }
}
