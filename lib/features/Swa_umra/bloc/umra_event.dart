part of 'umra_bloc.dart';

abstract class UmraEvent extends Equatable {
  const UmraEvent();

  @override
  List<Object> get props => [];
}

class TripUmraTypeEvent extends UmraEvent {}

class GetcityEvent extends UmraEvent {}

class GetcampainEvent extends UmraEvent {}

class GetPackageListEvent extends UmraEvent {
  String date, city;
  int typeid;
  int? campianID;

  int? reservationid;

  GetPackageListEvent(
      {required this.city,
      required this.date,
      required this.typeid,
      this.reservationid,
      this.campianID});
}

class GetSeatsEvent extends UmraEvent {
  int? tripId;

  GetSeatsEvent({this.tripId});
}

class WalletdetactionEvent extends UmraEvent {
  int paymentTypeID;
  int PaymentMethodID;
  WalletdetactionEvent(
      {required this.PaymentMethodID, required this.paymentTypeID});
}

class HoldseatEvent extends UmraEvent {
  int? seatId;
  int? tripId;

  HoldseatEvent({this.seatId, this.tripId});
}

class RemoveHoldSeatEvent extends UmraEvent {
  List? seatsId;
  int? tripId;

  RemoveHoldSeatEvent({this.seatsId, this.tripId});
}

class CheckpromcodeEvent extends UmraEvent {
  String? code;

  CheckpromcodeEvent({this.code});
}

class cardpaymentEvent extends UmraEvent {
  int paymentTypeID;
  int PaymentMethodID;
  String cardNumber;
  String cardExpiryYear;
  String cvv;
  String cardExpiryMonth;

  cardpaymentEvent(
      {required this.PaymentMethodID,
      required this.cardExpiryMonth,
      required this.cardExpiryYear,
      required this.cardNumber,
      required this.cvv,
      required this.paymentTypeID});
}

class cardEditReservationEvent extends UmraEvent {
  int paymentTypeID;
  int PaymentMethodID;
  String cardNumber;
  String cardExpiryYear;
  String cvv;
  String cardExpiryMonth;
  int? umrareservationid;

  cardEditReservationEvent(
      {required this.PaymentMethodID,
      required this.cardExpiryMonth,
      this.umrareservationid,
      required this.cardExpiryYear,
      required this.cardNumber,
      required this.cvv,
      required this.paymentTypeID});
}

class FawrypayEvent extends UmraEvent {
  int paymentTypeID;
  int PaymentMethodID;
  FawrypayEvent({required this.PaymentMethodID, required this.paymentTypeID});
}

class FawryEditEvent extends UmraEvent {
  int paymentTypeID;
  int? umrareservationid;

  int PaymentMethodID;
  FawryEditEvent(
      {required this.PaymentMethodID,
      required this.paymentTypeID,
      this.umrareservationid});
}

class ElectronicwalletEvent extends UmraEvent {
  int paymentTypeID;
  int PaymentMethodID;
  String phone;
  ElectronicwalletEvent(
      {required this.PaymentMethodID,
      required this.paymentTypeID,
      required this.phone});
}

class EditElectronicwalletEvent extends UmraEvent {
  int paymentTypeID;
  int PaymentMethodID;
  String phone;
  int? umrahReservationID;

  EditElectronicwalletEvent(
      {required this.PaymentMethodID,
      required this.paymentTypeID,
      this.umrahReservationID,
      required this.phone});
}

class Getpolicyevent extends UmraEvent {
  String type;

  Getpolicyevent({required this.type});
}

class GetCompainListEvent extends UmraEvent {}

class GetPageListEvent extends UmraEvent {}

class GetTransportationEvent extends UmraEvent {
  int tripUmrahID;
  int? reservationID;
  GetTransportationEvent({required this.tripUmrahID, this.reservationID});
}

class GetAccommodationEvent extends UmraEvent {
  int tripUmrahID;
  int? umrahReservationID;

  GetAccommodationEvent({required this.tripUmrahID, this.umrahReservationID});
}

class GetprogramsEvent extends UmraEvent {
  int tripUmrahID;
  int? umrahReservationID;

  GetprogramsEvent({required this.tripUmrahID, this.umrahReservationID});
}

class getpaymentstypeEvent extends UmraEvent {}

class GetbookedumraEvent extends UmraEvent {}

class CancelReservationEvent extends UmraEvent {
  int reservationID;
  CancelReservationEvent({required this.reservationID});
}

class EditReservationEvent extends UmraEvent {
  int reservationID;
  int? paymentid;
  int? paymentTypeID;
  int? paymentMethodID;
  EditReservationEvent(
      {required this.reservationID, this.paymentMethodID, this.paymentTypeID});
}
