import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/status_code.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/utils/app_strings.dart';
import 'package:swa/core/utils/language.dart';

class HttpConsumer implements ApiConsumer {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  HttpConsumer({required this.client, required this.sharedPreferences});

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(
        Uri.parse(path),
        headers: {"APIKey": "546548dwfdfsd3f4sdfhgat52",
          "Accept-Language":LanguageClass.isEnglish?"en":"ar"

        },
        // headers: await _getToken()
      );
      return _handleResponseErrors(response);
    } on TimeoutException catch (error) {
      throw FetchDataException(error.toString());
    } on Exception catch (error) {
      throw NoInternetConnectionException(error.toString());
    }
  }

  @override
  Future post(String path,
      {dynamic body, Map<String, dynamic>? queryParameters}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "APIKey": "546548dwfdfsd3f4sdfhgat52",
      "Accept-Language":LanguageClass.isEnglish?"en":"ar"

    };

    //Map<String, dynamic>
    try {
      final response = await client.post(
        Uri.parse(path),
        body: body,
        headers: headers,
        // headers: await _getToken()
      );
      return _handleResponseErrors(response);
    } on TimeoutException catch (error) {
      throw FetchDataException(error.toString());
    } on Exception catch (error) {
      throw NoInternetConnectionException(error.toString());
    }
  }

  Future uploadMultiPart(String path, String imagePath,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      var results = http.MultipartRequest(
        'POST',
        Uri.parse(path),
      );
      body!.forEach((key, value) {
        results.fields[key] = value;
      });
      //create multipart using filepath, string or bytes
      var pic = await http.MultipartFile.fromPath('UploadedFile', imagePath);
      //add multipart to request
      results.files.add(pic);
      var response = await results.send();
      //Handling Errors
      final String respStr = await response.stream.bytesToString();
      switch (response.statusCode) {
        case StatusCode.ok:
          return response;
        case StatusCode.badRequest:
          throw BadRequestException(jsonDecode(respStr)['Message']);
        case StatusCode.unauthorized:
        case StatusCode.forbidden:
          throw UnauthorizedException(jsonDecode(respStr)['Message']);
        case StatusCode.notFound:
          throw NotFoundException(jsonDecode(respStr)['Message']);
        case StatusCode.conflict:
          throw ConflictException(jsonDecode(respStr)['Message']);
        case StatusCode.internalServerError:
          throw InternalServerErrorException(jsonDecode(respStr)['Message']);
      }
    } on TimeoutException catch (error) {
      throw FetchDataException(error.toString());
    } on Exception catch (error) {
      throw NoInternetConnectionException(error.toString());
    }
  }

  dynamic _handleResponseErrors(http.Response response) {
    String _message = '';
    if (response.statusCode != StatusCode.ok) {
      _message = (jsonDecode(response.body)['Message']).toString();
    }
    switch (response.statusCode) {
      case StatusCode.ok:
        return response;
      case StatusCode.badRequest:
        throw BadRequestException(_message);
      case StatusCode.unauthorized:
      case StatusCode.forbidden:
        throw UnauthorizedException(_message);
      case StatusCode.notFound:
        throw NotFoundException(_message);
      case StatusCode.conflict:
        throw ConflictException(_message);
      case StatusCode.internalServerError:
        throw InternalServerErrorException(_message);
    }
  }

  Future<dynamic> _getToken() async {
    // final jsonString = sharedPreferences.getString(AppStrings.cachedStudentLoginData);
    // String token = '';
    // if (jsonString != null && jsonString != '') {
    //   final cachedStudentData = await Future.value(StudentModel.fromJson(json.decode(jsonString)));
    //   token = 'Bearer ' + cachedStudentData.token;
    //   return {AppStrings.contentType: AppStrings.applicationJson, AppStrings.charset: AppStrings.utf, AppStrings.authorization: token};
    // }else {
    //   return <String, String>{};
    // }
  }

  @override
  Future put(String path, {body, Map<String, dynamic>? queryParameters})async {
    Map<String, String> headers = {
      "APIKey": "546548dwfdfsd3f4sdfhgat52",
    };

    //Map<String, dynamic>
    try {
      final response = await client.put(
        Uri.parse(path),
        body: body,
        headers: headers,
        // headers: await _getToken()
      );
      return _handleResponseErrors(response);
    } on TimeoutException catch (error) {
      throw FetchDataException(error.toString());
    } on Exception catch (error) {
      throw NoInternetConnectionException(error.toString());
    }
  }


}
