import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_classes_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';

class MoreRepo{
  final ApiConsumer apiConsumer;
  MoreRepo(this.apiConsumer);

  Future<AboutUsResponse?> getAboutUs()async{

    final res = await apiConsumer.get(
      EndPoints.aboutUs
    );
    log("AboutUsResbonse"+res.body);
    var decode = json.decode(res.body);
    AboutUsResponse aboutUsResponse = AboutUsResponse.fromJson(decode);
    return aboutUsResponse;
  }

  Future<StationsModel?> getStations()async{

    final res = await apiConsumer.get(
        EndPoints.stations
    );
    log("AboutUsResbonse"+res.body);
    var decode = json.decode(res.body);
    StationsModel stationsModel = StationsModel.fromJson(decode);
    return stationsModel;
  }

  Future<BusClassesModel?> getBusClasses()async{

    final res = await apiConsumer.get(
        EndPoints.busClass
    );
    log("BusClassResbonse"+res.body);
    var decode = json.decode(res.body);
    BusClassesModel busClassesModel = BusClassesModel.fromJson(decode);
    return busClassesModel;
  }


  Future<LinesModel?> getLines()async{

    final res = await apiConsumer.get(
        EndPoints.lines
    );
    log("Lines/LinesResbonse"+res.body);
    var decode = json.decode(res.body);
    LinesModel linesModel = LinesModel.fromJson(decode);
    return linesModel;
  }
}