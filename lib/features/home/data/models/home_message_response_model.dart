import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/home/data/models/cities_stations_model.dart';
import 'package:swa/features/home/domain/entities/cities_stations.dart';
import 'package:swa/features/home/domain/entities/home_message_response.dart';

class HomeMessageResponseModel extends HomeMessageResponse {
  const HomeMessageResponseModel({
     required String? message,
     required String? status,
     required List<CitiesStations>? citiesStations,
     required dynamic balance,
     required dynamic object,
     required dynamic obj,
  }) : super(status: status, message: message, citiesStations: citiesStations, balance: balance, object: object, obj: obj);

  factory HomeMessageResponseModel.fromJson(Map<String, dynamic> json) => HomeMessageResponseModel(
    status : json['status'],
    message : (json['status'] == 'failed') ?  json['message'] : null,
    citiesStations : (json['message'] != null && json['status'] != 'failed') ? (json['message'] as List).map((dynamic e) => CitiesStationsModel.fromJson(e as Map<String,dynamic>)).toList() : null,
    balance : json['balance'],
    object : json['Object'],
    obj : json['Obj'],
  );

  Map<String, dynamic> toJson() => {
    'status' : status,
    'balance' : balance,
    'Object' : object,
    'Obj' : obj,
  };

}