import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/Swa_umra/models/City_umra_model.dart';
import 'package:swa/features/Swa_umra/models/Trip_umra_model.dart';
import 'package:swa/features/Swa_umra/models/campain_list_model.dart';
import 'package:swa/features/Swa_umra/models/campain_model.dart';
import 'package:swa/features/app_info/data/models/city_model.dart';
import 'package:swa/main.dart';

class UmraRepos {
  final ApiConsumer apiConsumer = sl();

  Future getTripUmraType() async {
    var response =
        await apiConsumer.get("${EndPoints.baseUrl}TripUmraType/GetList");

    log(" station from" + response.body);
    var decode = json.decode(response.body);
    TripUmramodel linesModel = TripUmramodel.fromJson(decode);
    return linesModel;
  }

  Future getcity() async {
    var response = await apiConsumer
        .get("${EndPoints.baseUrl}TripUmra/GetCityList?countryID=3");

    log(" station from" + response.body);
    var decode = json.decode(response.body);
    CityUmramodel linesModel = CityUmramodel.fromJson(decode);
    return linesModel;
  }

  Future getcampaint() async {
    var response =
        await apiConsumer.get("${EndPoints.baseUrl}TripUmra/GetCompainList");

    log(" campain " + response.body);
    var decode = json.decode(response.body);
    CampainModel linesModel = CampainModel.fromJson(decode);
    return linesModel;
  }

  Future getcampaginlist(
      {required String city,
      required String campainid,
      required String date}) async {
    var response = await apiConsumer.get(
        "${EndPoints.baseUrl}TripUmra/GetCompainList?cityID=$city&tripDate=$date&campainID=$campainid");

    log(" campain " + response.body);
    var decode = json.decode(response.body);
    Triplistmodel linesModel = Triplistmodel.fromJson(decode);
    return linesModel;
  }
}
