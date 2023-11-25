import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/repo/reservation_repo/reservation_repo.dart';

import '../../../../../main.dart';
import '../../../data/models/Reservation_response_MyWallet_model.dart';
import 'reservation_states_my_wallet.dart';

class ReservationCubit extends Cubit<ReservationStates>{
  ReservationCubit():super(InitialReservationStates());

ReservationRepo reservationRepo = ReservationRepo(apiConsumer: sl());
Future<ReservationResponseMyWalletModel?>addReservationMyWallet({
  required List<dynamic> seatIdsOneTrip,
  List<dynamic>? seatIdsRoundTrip,
  required int custId,
  required String oneTripID,
  String? roundTripID,
  required int paymentTypeID,
  required String amount,
  required String tripDateGo,
  String? tripDateBack,
  required String fromStationID,
  required String toStationId
})async {
  try{
    emit(LoadingMyWalletState());
    final res = await reservationRepo.addReservationMyWallet(
      toStationId:toStationId ,
       custId: custId,
      oneTripID: oneTripID,
      paymentTypeID: paymentTypeID,
      seatIdsOneTrip: seatIdsOneTrip,
      amount: amount,
      roundTripID: roundTripID,
      seatIdsRoundTrip: seatIdsRoundTrip,
      fromStationID:fromStationID,
      tripDateGo:tripDateGo,
      tripDateBack: tripDateBack

    );
    if(res?.message != null){
      emit(LoadedMyWalletState(reservationResponseMyWalletModel: res!));
    }else{
      emit(ErrorMyWalletState(error: res!.message.toString()));
    }
  }catch (e){
    emit(ErrorMyWalletState(error: e.toString()));
  }
}


  Future<ReservationResponseMyWalletModel?>addReservationElectronicWallet({
    required List<dynamic> seatIdsOneTrip,
    List<dynamic>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    int? paymentMethodID,
    required int paymentTypeID,
    required String amount,
    String? mobile,
    required String tripDateGo,
    String? tripDateBack,
    required String fromStationID,
    required String toStationId
  })async {
    try{
      emit(LoadingElectronicWalletState());
      final res = await reservationRepo.addReservationElectronicWallet(
          toStationId:toStationId ,
          custId: custId,
          oneTripID: oneTripID,
          paymentTypeID: paymentTypeID,
          seatIdsOneTrip: seatIdsOneTrip,
          amount: amount,
          roundTripID: roundTripID,
          seatIdsRoundTrip: seatIdsRoundTrip,
          fromStationID:fromStationID,
          tripDateGo:tripDateGo,
          tripDateBack: tripDateBack,
          mobile: mobile,
        paymentMethodID: paymentMethodID,

      );
      if(res?.message != null){
        emit(LoadedElectronicWalletState(reservationResponseElectronicModel: res!));
      }else{
        emit(ErrorElectronicWalletState(error: res!.message!.statusDescription.toString()));
      }
    }catch (e){
      emit(ErrorElectronicWalletState(error: e.toString()));
    }
  }
  Future<ReservationResponseMyWalletModel?>addReservationFawry({
    required List<dynamic> seatIdsOneTrip,
    List<dynamic>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    int? paymentMethodID,
    required int paymentTypeID,
    required String amount,
    String? mobile,
    required String tripDateGo,
    String? tripDateBack,
    required String fromStationID,
    required String toStationId
  })async {
    try{
      emit(LoadingElectronicWalletState());
      final res = await reservationRepo.addReservationFawry(
        toStationId:toStationId ,
        custId: custId,
        oneTripID: oneTripID,
        paymentTypeID: paymentTypeID,
        seatIdsOneTrip: seatIdsOneTrip,
        amount: amount,
        roundTripID: roundTripID,
        seatIdsRoundTrip: seatIdsRoundTrip,
        fromStationID:fromStationID,
        tripDateGo:tripDateGo,
        tripDateBack: tripDateBack,
        paymentMethodID: paymentMethodID,

      );
      if(res?.message != null){
        emit(LoadedElectronicWalletState(reservationResponseElectronicModel: res!));
      }else{
        emit(ErrorElectronicWalletState(error: res!.message!.statusDescription.toString()));
      }
    }catch (e){
      emit(ErrorElectronicWalletState(error: e.toString()));
    }
  }
  Future<ReservationResponseCreditCard?>addReservationCreditCard({
    required List<dynamic> seatIdsOneTrip,
    List<dynamic>? seatIdsRoundTrip,
    required int custId,
    required String oneTripID,
    String? roundTripID,
    int? paymentMethodID,
    required int paymentTypeID,
    required String amount,
    required String tripDateGo,
    String? tripDateBack,
    required String fromStationID,
    required String toStationId,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,

  })async {
    try{
      emit(LoadingCreditCardState());
      final res = await reservationRepo.addReservationCreditCard(
        toStationId:toStationId ,
        custId: custId,
        oneTripID: oneTripID,
        paymentTypeID: paymentTypeID,
        seatIdsOneTrip: seatIdsOneTrip,
        amount: amount,
        roundTripID: roundTripID,
        seatIdsRoundTrip: seatIdsRoundTrip,
        fromStationID:fromStationID,
        tripDateGo:tripDateGo,
        tripDateBack: tripDateBack,
        paymentMethodID: paymentMethodID,
        cardExpiryMonth: cardExpiryMonth,
        cardExpiryYear: cardExpiryYear,
        cardNumber: cardNumber,
        cvv: cvv

      );
      if(res?.message!.statusCode ==200){
        emit(LoadedCreditCardState(reservationResponseCreditCard: res!));
      }else{
        emit(ErrorCreditCardState(error: res!.message!.statusDescription.toString()));
      }
    }catch (e){
      emit(ErrorCreditCardState(error: e.toString()));
    }
  }

}