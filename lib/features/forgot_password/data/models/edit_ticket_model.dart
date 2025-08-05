class EditticketModel {
  EditticketModel({
    this.sealListId,
    this.customerId,
    this.reservationId,
    this.totalPrice,
    this.seatPrice,
    this.countryId,
    this.dateTypeId,
    this.toCurrency,
  });

  List<int>? sealListId;
  int? customerId;
  int? reservationId;
  dynamic totalPrice;
  dynamic seatPrice;
  String? countryId;
  int? dateTypeId;
  String? toCurrency;

  EditticketModel.fromJson(Map<String, dynamic> json) {
    sealListId = json["SealListID"] == null ? [] : List<int>.from(json["SealListID"]!.map((x) => x));
    customerId = json["customerID"];
    reservationId = json["reservationID"];
    totalPrice = json["totalPrice"];
    seatPrice = json["seatPrice"];
    countryId = json["countryID"];
    dateTypeId = json["dateTypeID"];
    toCurrency = json["toCurrency"];
  }
}
