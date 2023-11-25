class ReservationRequestModel {
  ReservationRequestModel({
      this.seatIdsOneTrip, 
      this.seatIdsRoundTrip, 
      this.custId, 
      this.oneTripID, 
      this.roundTripID, 
      this.paymentMethodID, 
      this.paymentTypeID, 
      this.cardPaymentModel, 
      this.ewalletModel, 
      this.refNoModel,});


  List<int>? seatIdsOneTrip;
  List<int>? seatIdsRoundTrip;
  int? custId;
  String? oneTripID;
  String? roundTripID;
  int? paymentMethodID;
  int? paymentTypeID;
  CardPaymentModel? cardPaymentModel;
  EwalletModel? ewalletModel;
  RefNoModel? refNoModel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SeatIdsOneTrip'] = seatIdsOneTrip;
    map['SeatIdsRoundTrip'] = seatIdsRoundTrip;
    map['CustId'] = custId;
    map['OneTripID'] = oneTripID;
    map['RoundTripID'] = roundTripID;
    map['PaymentMethodID'] = paymentMethodID;
    map['PaymentTypeID'] = paymentTypeID;
    if (cardPaymentModel != null) {
      map['cardPaymentModel'] = cardPaymentModel?.toJson();
    }
    if (ewalletModel != null) {
      map['EwalletModel'] = ewalletModel?.toJson();
    }
    if (refNoModel != null) {
      map['RefNoModel'] = refNoModel?.toJson();
    }
    return map;
  }

}

class RefNoModel {
  RefNoModel({
      this.customerId, 
      this.amount,});

  int? customerId;
  double? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustomerId'] = customerId;
    map['Amount'] = amount;
    return map;
  }

}

class EwalletModel {
  EwalletModel({
      this.customerId, 
      this.amount, 
      this.mobile,});

  int? customerId;
  double? amount;
  String? mobile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustomerId'] = customerId;
    map['amount'] = amount;
    map['Mobile'] = mobile;
    return map;
  }

}

class CardPaymentModel {
  CardPaymentModel({
      this.customerId, 
      this.amount, 
      this.cardNumber, 
      this.cardExpiryYear, 
      this.cardExpiryMonth, 
      this.cvv,});


  int? customerId;
  double? amount;
  String? cardNumber;
  String? cardExpiryYear;
  String? cardExpiryMonth;
  String? cvv;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustomerId'] = customerId;
    map['amount'] = amount;
    map['cardNumber'] = cardNumber;
    map['cardExpiryYear'] = cardExpiryYear;
    map['cardExpiryMonth'] = cardExpiryMonth;
    map['cvv'] = cvv;
    return map;
  }

}