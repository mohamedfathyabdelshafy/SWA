class ReservationDetailsModel {
  ReservationDetailsModel({
    required this.data,
    required this.status,
    required this.message,
    required this.balance,
    required this.object,
    required this.text,
    required this.isAuthorized,
    required this.obj,
  });

  final dynamic data;
  final String? status;
  final List<Transactions> message;
  final dynamic balance;
  final dynamic object;
  final dynamic text;
  final bool? isAuthorized;
  final dynamic obj;

  factory ReservationDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReservationDetailsModel(
      data: json["data"],
      status: json["status"],
      message:
          json["message"] == null ? [] : List<Transactions>.from(json["message"]!.map((x) => Transactions.fromJson(x))),
      balance: json["balance"],
      object: json["Object"],
      text: json["Text"],
      isAuthorized: json["isAuthorized"],
      obj: json["Obj"],
    );
  }
}

class Transactions {
  Transactions({
    required this.currencySymbole,
    required this.currencyName,
    required this.transactionId,
    required this.transactionTypeId,
    required this.reservationId,
    required this.transactionDate,
    required this.paymentMethodId,
    required this.balance,
    required this.reasonId,
    required this.notes,
    required this.isDeleted,
    required this.createdBy,
    required this.creationDate,
    required this.updatedBy,
    required this.updateDate,
    required this.creatorType,
    required this.officeId,
    required this.billSerial,
    required this.organizationId,
    required this.partnerId,
    required this.transactionType,
    required this.paymentMethod,
    required this.reason,
    required this.organizationName,
    required this.partnerName,
    required this.customerName,
    required this.customerPhone,
    required this.platNo,
    required this.tripType,
    required this.from,
    required this.to,
    required this.seatBusNo,
    required this.seatNumberReserved,
    required this.price,
    required this.seatNumberEmpty,
    required this.tripNumber,
    required this.tripId,
    required this.tripDat,
    required this.ticketNumber,
    required this.penalty,
    required this.lineId,
    required this.lineName,
    required this.isArabic,
  });

  final String? currencySymbole;
  final String? currencyName;
  final int? transactionId;
  final int? transactionTypeId;
  final int? reservationId;
  final DateTime? transactionDate;
  final int? paymentMethodId;
  final dynamic balance;
  final int? reasonId;
  final String? notes;
  final bool? isDeleted;
  final String? createdBy;
  final DateTime? creationDate;
  final String? updatedBy;
  final dynamic updateDate;
  final dynamic creatorType;
  final int? officeId;
  final String? billSerial;
  final dynamic organizationId;
  final dynamic partnerId;
  final String? transactionType;
  final String? paymentMethod;
  final String? reason;
  final String? organizationName;
  final String? partnerName;
  final String? customerName;
  final String? customerPhone;
  final String? platNo;
  final String? tripType;
  final String? from;
  final String? to;
  final int? seatBusNo;
  final int? seatNumberReserved;
  final dynamic price;
  final int? seatNumberEmpty;
  final int? tripNumber;
  final int? tripId;
  final DateTime? tripDat;
  final int? ticketNumber;
  final dynamic penalty;
  final int? lineId;
  final String? lineName;
  final bool? isArabic;

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      currencySymbole: json["CurrencySymbole"],
      currencyName: json["CurrencyName"],
      transactionId: json["TransactionId"],
      transactionTypeId: json["TransactionTypeId"],
      reservationId: json["ReservationId"],
      transactionDate: DateTime.tryParse(json["TransactionDate"] ?? ""),
      paymentMethodId: json["PaymentMethodId"],
      balance: json["Balance"],
      reasonId: json["ReasonId"],
      notes: json["Notes"],
      isDeleted: json["IsDeleted"],
      createdBy: json["CreatedBy"],
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      updatedBy: json["UpdatedBy"],
      updateDate: json["UpdateDate"],
      creatorType: json["CreatorType"],
      officeId: json["OfficeID"],
      billSerial: json["BillSerial"],
      organizationId: json["OrganizationID"],
      partnerId: json["PartnerID"],
      transactionType: json["TransactionType"],
      paymentMethod: json["PaymentMethod"],
      reason: json["Reason"],
      organizationName: json["OrganizationName"],
      partnerName: json["PartnerName"],
      customerName: json["CustomerName"],
      customerPhone: json["CustomerPhone"],
      platNo: json["PlatNo"],
      tripType: json["TripType"],
      from: json["From"],
      to: json["To"],
      seatBusNo: json["SeatBusNo"],
      seatNumberReserved: json["SeatNumberReserved"],
      price: json["Price"],
      seatNumberEmpty: json["SeatNumberEmpty"],
      tripNumber: json["TripNumber"],
      tripId: json["TripID"],
      tripDat: DateTime.tryParse(json["TripDat"] ?? ""),
      ticketNumber: json["TicketNumber"],
      penalty: json["Penalty"],
      lineId: json["LineID"],
      lineName: json["LineName"],
      isArabic: json["IsArabic"],
    );
  }
}
