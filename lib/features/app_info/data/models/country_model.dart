import 'package:swa/features/app_info/domain/entities/country.dart';

class CountryModel extends Country {
  int countryId;
  String countryName;

  CountryModel({
    required this.countryId,
    required this.countryName,
  }) : super(countryId: countryId, countryName: countryName);

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        countryId: json["CountryID"],
        countryName: json["CountryName"],
      );

  Map<String, dynamic> toJson() => {
        "CountryID": countryId,
        "CountryName": countryName,
      };
}
