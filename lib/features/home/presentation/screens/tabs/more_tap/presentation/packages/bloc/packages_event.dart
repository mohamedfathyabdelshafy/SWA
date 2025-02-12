part of 'packages_bloc.dart';

abstract class PackagesEvent extends Equatable {
  const PackagesEvent();

  @override
  List<Object> get props => [];
}

class AllpackagesEvent extends PackagesEvent {}

class stationfromEvent extends PackagesEvent {}

class stationtoEvent extends PackagesEvent {
  String stationid;
  stationtoEvent({required this.stationid});
}

class packagesEvent extends PackagesEvent {
  String stationfromid, stationtoid;
  packagesEvent({required this.stationfromid, required this.stationtoid});
}

class PromocodeEvent extends PackagesEvent {
  String? promocode, packageid;

  PromocodeEvent({this.promocode, this.packageid});
}

class PromocodReservationEvent extends PackagesEvent {
  String? promocode;
  int? custId;
  int? paymentTypeID;
  String? promocodeid;
  List<TripReservationList>? trips;
  PromocodReservationEvent(
      {this.promocode,
      this.custId,
      this.paymentTypeID,
      this.promocodeid,
      this.trips});
}

class GetactivepackageEvent extends PackagesEvent {}

class GetadsEvent extends PackagesEvent {}

class GetpopupadsEvent extends PackagesEvent {}

class packagecardpayment extends PackagesEvent {
  int? FromStationID, ToStationID, PaymentTypeID;
  String? PackageID, Amount, PaymentMethodID, PackagePriceID;
  String? cardNumber;
  String? cardExpiryYear;
  String? cvv;
  String? cardExpiryMonth;

  packagecardpayment({
    this.Amount,
    this.FromStationID,
    this.PackageID,
    this.PackagePriceID,
    this.PaymentMethodID,
    this.PaymentTypeID,
    this.ToStationID,
    this.cardExpiryMonth,
    this.cardExpiryYear,
    this.cardNumber,
    this.cvv,
  });
}

class packeydetcutpaymentevent extends PackagesEvent {
  int? FromStationID, ToStationID, PaymentTypeID, PaymentMethodID;
  String? PackageID, PromoCodeID, Amount, PackagePriceID;

  packeydetcutpaymentevent({
    this.Amount,
    this.FromStationID,
    this.PackageID,
    this.PaymentMethodID,
    this.PackagePriceID,
    this.PaymentTypeID,
    this.PromoCodeID,
    this.ToStationID,
  });
}

class packagefawryEvent extends PackagesEvent {
  int? FromStationID, ToStationID, PaymentTypeID, PaymentMethodID;
  String? PackageID, PromoCodeID, Amount, PackagePriceID;

  packagefawryEvent({
    this.Amount,
    this.FromStationID,
    this.PackageID,
    this.PaymentMethodID,
    this.PackagePriceID,
    this.PaymentTypeID,
    this.PromoCodeID,
    this.ToStationID,
  });
}

class PackageelectronicEvent extends PackagesEvent {
  int? FromStationID, ToStationID, PaymentTypeID, PaymentMethodID;
  String? PackageID, PromoCodeID, Amount, PackagePriceID, phone;

  PackageelectronicEvent(
      {this.Amount,
      this.FromStationID,
      this.PackageID,
      this.PaymentMethodID,
      this.PackagePriceID,
      this.PaymentTypeID,
      this.PromoCodeID,
      this.ToStationID,
      this.phone});
}

class checkversionevent extends PackagesEvent {}

class selectappevent extends PackagesEvent {}
