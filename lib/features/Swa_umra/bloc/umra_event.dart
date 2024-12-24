part of 'umra_bloc.dart';

abstract class UmraEvent extends Equatable {
  const UmraEvent();

  @override
  List<Object> get props => [];
}

class TripUmraTypeEvent extends UmraEvent {}

class GetcityEvent extends UmraEvent {}

class GetcampainEvent extends UmraEvent {}

class GetcampaginsListEvent extends UmraEvent {
  String date, city;
  GetcampaginsListEvent({required this.city, required this.date});
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

class FawrypayEvent extends UmraEvent {
  int paymentTypeID;
  int PaymentMethodID;
  FawrypayEvent({required this.PaymentMethodID, required this.paymentTypeID});
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

class Getpolicyevent extends UmraEvent {}
