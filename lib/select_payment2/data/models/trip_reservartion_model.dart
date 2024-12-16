class TripReservationList {
  List? seatIds;
  int? tripId;
  String? fromStationId;
  String? toStationId;
  DateTime? tripDate;
  double? price;
  String? discount;
  int? lineId;
  int? serviceTypeId;
  int? busId;

  TripReservationList({
    this.seatIds,
    this.tripId,
    this.fromStationId,
    this.toStationId,
    this.tripDate,
    this.price,
    this.discount,
    this.lineId,
    this.serviceTypeId,
    this.busId,
  });

  factory TripReservationList.fromJson(Map<String, dynamic> json) =>
      TripReservationList(
        seatIds: List.from(json["SeatIds"].map((x) => x)),
        tripId: json["TripID"],
        fromStationId: json["FromStationID"],
        toStationId: json["ToStationID"],
        tripDate: DateTime.parse(json["TripDate"]),
        price: json["Price"]?.toDouble(),
        discount: json["Discount"],
        lineId: json["LineID"],
        serviceTypeId: json["ServiceTypeID"],
        busId: json["BusID"],
      );
}
