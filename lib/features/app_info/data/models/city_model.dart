
import 'package:swa/features/app_info/domain/entities/city.dart';

class CityModel extends City{
  int cityId;
  String cityName;

  CityModel({
    required this.cityId,
    required this.cityName,
  }):super(cityId:cityId,cityName:cityName);

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    cityId: json["CityID"],
    cityName: json["CityName"],
  );

  Map<String, dynamic> toJson() => {
    "CityID": cityId,
    "CityName": cityName,
  };
}
