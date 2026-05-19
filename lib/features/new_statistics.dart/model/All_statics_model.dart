class AllStaticsModel {
  AllStaticsModel({
    this.data,
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.isAuthorized,
    this.obj,
  });

  dynamic data;
  String? status;
  Statisticdata? message;
  dynamic balance;
  dynamic object;
  dynamic text;
  bool? isAuthorized;
  dynamic obj;

  factory AllStaticsModel.fromJson(Map<String, dynamic> json) {
    return AllStaticsModel(
      data: json["data"],
      status: json["status"],
      message: json["message"] == null ? null : Statisticdata.fromJson(json["message"]),
      balance: json["balance"],
      object: json["Object"],
      text: json["Text"],
      isAuthorized: json["isAuthorized"],
      obj: json["Obj"],
    );
  }
}

class Statisticdata {
  Statisticdata({
    this.summary,
    this.payments,
    this.reservations,
    this.penalties,
    this.fees,
    this.rewards,
    this.refunds,
    this.monthlyStats,
    this.topRoutes,
  });

  Summary? summary;
  List<Payment>? payments;
  List<Reservation>? reservations;
  List<Penalty>? penalties;
  List<Fee>? fees;
  List<Reward>? rewards;
  List<Refund>? refunds;
  List<MonthlyStat>? monthlyStats;
  List<TopRoute>? topRoutes;

  factory Statisticdata.fromJson(Map<String, dynamic> json) {
    return Statisticdata(
      summary: json["Summary"] == null ? null : Summary.fromJson(json["Summary"]),
      payments: json["Payments"] == null ? [] : List<Payment>.from(json["Payments"]!.map((x) => Payment.fromJson(x))),
      reservations: json["Reservations"] == null
          ? []
          : List<Reservation>.from(json["Reservations"]!.map((x) => Reservation.fromJson(x))),
      penalties:
          json["Penalties"] == null ? [] : List<Penalty>.from(json["Penalties"]!.map((x) => Penalty.fromJson(x))),
      fees: json["Fees"] == null ? [] : List<Fee>.from(json["Fees"]!.map((x) => Fee.fromJson(x))),
      rewards: json["Rewards"] == null ? [] : List<Reward>.from(json["Rewards"]!.map((x) => Reward.fromJson(x))),
      refunds: json["Refunds"] == null ? [] : List<Refund>.from(json["Refunds"]!.map((x) => Refund.fromJson(x))),
      monthlyStats: json["MonthlyStats"] == null
          ? []
          : List<MonthlyStat>.from(json["MonthlyStats"]!.map((x) => MonthlyStat.fromJson(x))),
      topRoutes:
          json["TopRoutes"] == null ? [] : List<TopRoute>.from(json["TopRoutes"]!.map((x) => TopRoute.fromJson(x))),
    );
  }
}

class Refund {
  Refund({
    this.paymentToCustomerId,
    this.amount,
    this.paymentDate,
    this.paymentMethodId,
  });

  int? paymentToCustomerId;
  dynamic amount;
  DateTime? paymentDate;
  int? paymentMethodId;

  factory Refund.fromJson(Map<String, dynamic> json) {
    return Refund(
      paymentToCustomerId: json["PaymentToCustomerID"],
      amount: json["Amount"],
      paymentDate: DateTime.tryParse(json["PaymentDate"] ?? ""),
      paymentMethodId: json["PaymentMethodID"],
    );
  }
}

class MonthlyStat {
  MonthlyStat({
    this.monthNumber,
    this.monthName,
    this.reservationCount,
    this.reservationTotal,
  });

  int? monthNumber;
  String? monthName;
  int? reservationCount;
  dynamic reservationTotal;

  factory MonthlyStat.fromJson(Map<String, dynamic> json) {
    return MonthlyStat(
      monthNumber: json["MonthNumber"],
      monthName: json["MonthName"],
      reservationCount: json["ReservationCount"],
      reservationTotal: json["ReservationTotal"],
    );
  }
}

class Payment {
  Payment({
    this.fawryPaymentId,
    this.amount,
    this.paymentMethod,
    this.creationDate,
    this.statusId,
    this.description,
  });

  int? fawryPaymentId;
  dynamic amount;
  String? paymentMethod;
  String? description;

  DateTime? creationDate;
  int? statusId;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      fawryPaymentId: json["FawryPaymentID"],
      amount: json["Amount"],
      description: json["Description"],
      paymentMethod: json["PaymentMethod"],
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      statusId: json["StatusID"],
    );
  }
}

class Penalty {
  Penalty({
    this.lineNameAr,
    this.lineNameEn,
    this.transactionId,
    this.penalty,
    this.transactionDate,
    this.reservationId,
  });
  String? lineNameAr;
  String? lineNameEn;
  int? transactionId;
  dynamic penalty;
  DateTime? transactionDate;
  int? reservationId;

  factory Penalty.fromJson(Map<String, dynamic> json) {
    return Penalty(
      transactionId: json["TransactionId"],
      penalty: json["Penalty"],
      lineNameAr: json["LineNameAr"],
      lineNameEn: json["LineNameEn"],
      transactionDate: DateTime.tryParse(json["TransactionDate"] ?? ""),
      reservationId: json["ReservationID"],
    );
  }
}

class Reservation {
  Reservation({
    this.reservationId,
    this.price,
    this.seatNo,
    this.ticketNumber,
    this.fromStation,
    this.toStation,
    this.tripDate,
    this.creationDate,
    this.status,
  });

  int? reservationId;
  dynamic price;
  int? seatNo;
  int? ticketNumber;
  String? fromStation;
  String? toStation;
  DateTime? tripDate;
  DateTime? creationDate;
  int? status;

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json["ReservationID"],
      price: json["Price"],
      seatNo: json["SeatNo"],
      ticketNumber: json["TicketNumber"],
      fromStation: json["FromStation"],
      toStation: json["ToStation"],
      tripDate: DateTime.tryParse(json["TripDate"] ?? ""),
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      status: json["Status"],
    );
  }
}

class Reward {
  Reward({
    this.rewardsCustomerId,
    this.amount,
    this.creationDate,
    this.rewardsId,
    this.nameAr,
    this.nameEn,
  });

  int? rewardsCustomerId;
  dynamic amount;
  DateTime? creationDate;
  int? rewardsId;
  String? nameAr;
  String? nameEn;

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      rewardsCustomerId: json["RewardsCustomerID"],
      amount: json["Amount"],
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      rewardsId: json["RewardsID"],
      nameAr: json["NameAr"],
      nameEn: json["NameEn"],
    );
  }
}

class Summary {
  Summary({
    this.totalPayment,
    this.totalReservationCount,
    this.totalReservationPrice,
    this.totalPenalty,
    this.totalReward,
    this.totalFees,
    this.totalRefund,
  });

  dynamic totalPayment;
  dynamic totalReservationCount;
  dynamic totalReservationPrice;
  dynamic totalPenalty;
  dynamic totalReward;
  dynamic totalFees;
  dynamic totalRefund;

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalPayment: json["TotalPayment"],
      totalReservationCount: json["TotalReservationCount"],
      totalReservationPrice: json["TotalReservationPrice"],
      totalPenalty: json["TotalPenalty"],
      totalReward: json["TotalReward"],
      totalFees: json["TotalFees"],
      totalRefund: json["TotalRefund"],
    );
  }
}

class TopRoute {
  TopRoute({
    this.routeName,
    this.tripCount,
    this.totalPrice,
  });

  String? routeName;
  int? tripCount;
  dynamic totalPrice;

  factory TopRoute.fromJson(Map<String, dynamic> json) {
    return TopRoute(
      routeName: json["RouteName"],
      tripCount: json["TripCount"],
      totalPrice: json["TotalPrice"],
    );
  }
}

class Fee {
  Fee({
    this.transactionId,
    this.feeAmount,
    this.transactionDate,
  });

  int? transactionId;
  dynamic feeAmount;
  DateTime? transactionDate;

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      transactionId: json["TransactionId"],
      feeAmount: json["FeeAmount"],
      transactionDate: DateTime.tryParse(json["TransactionDate"] ?? ""),
    );
  }
}
