import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';
import 'package:swa/select_payment2/data/repo/reservation_repo/reservation_repo.dart';

import '../../../../../main.dart';
import '../../../data/models/Reservation_response_MyWallet_model.dart';
import 'reservation_states_my_wallet.dart';

class ReservationCubit extends Cubit<ReservationStates> {
  ReservationCubit() : super(InitialReservationStates());

  ReservationRepo reservationRepo = ReservationRepo(apiConsumer: sl());
  Future<ReservationResponseMyWalletModel?> addReservationMyWallet({
    required int custId,
    required int paymentTypeID,
    required String promocodeid,
    required List<TripReservationList> trips,
  }) async {
    try {
      emit(LoadingMyWalletState());

      log(trips.toString());
      final res = await reservationRepo.addReservationMyWallet(
          custId: custId,
          paymentTypeID: paymentTypeID,
          promoid: promocodeid,
          trips: trips);
      if (res?.status == 'failed') {
        emit(ErrorMyWalletState(error: res!.message.toString()));
      } else if (res?.message != null) {
        emit(LoadedMyWalletState(reservationResponseMyWalletModel: res!));
      } else {
        emit(ErrorMyWalletState(error: res!.message.toString()));
      }
    } catch (e) {
      log(e.toString());

      emit(ErrorMyWalletState(error: e.toString()));
    }
  }

  Future<ReservationResponseMyWalletModel?> addReservationElectronicWallet({
    required int custId,
    required int paymentTypeID,
    required String promocodeid,
    required List<TripReservationList> trips,
    int? paymentMethodID,
    String? mobile,
  }) async {
    try {
      emit(LoadingElectronicWalletState());
      final res = await reservationRepo.addReservationElectronicWallet(
          custId: custId,
          paymentTypeID: paymentTypeID,
          mobile: mobile,
          paymentMethodID: paymentMethodID,
          promoid: promocodeid,
          trips: trips);
      if (res?.status == 'success') {
        emit(LoadedElectronicWalletState(
            reservationResponseElectronicModel: res!));
      } else if (res?.status == 'failed') {
        emit(ErrorElectronicWalletState(error: res!.errormessage.toString()));
      } else {
        emit(ErrorElectronicWalletState(
            error: res!.message!.statusDescription.toString()));
      }
    } catch (e) {
      emit(ErrorElectronicWalletState(error: e.toString()));
    }
  }

  Future<ReservationResponseMyWalletModel?> fawrycharge({
    required int customerid,
    required String amount,
  }) async {
    try {
      emit(LoadingElectronicWalletState());
      final res = await reservationRepo.chargefawrymeth(
        custId: customerid,
        amount: amount,
      );
      if (res?.status == 'failed') {
        emit(ErrorMyWalletState(error: res!.errormessage.toString()));
      } else if (res?.message != null) {
        emit(LoadedElectronicWalletState(
            reservationResponseElectronicModel: res!));
      } else {
        emit(ErrorElectronicWalletState(
            error: res!.message!.statusDescription.toString()));
      }
    } catch (e) {
      emit(ErrorElectronicWalletState(error: e.toString()));
    }
  }

  Future<ReservationResponseMyWalletModel?> addReservationFawry({
    required int custId,
    int? paymentMethodID,
    required int paymentTypeID,
  }) async {
    try {
      emit(LoadingElectronicWalletState());
      final res = await reservationRepo.addReservationFawry(
        promoid: Routes.PromoCodeID,
        trips: Routes.resrvedtrips,
        custId: custId,
        paymentTypeID: paymentTypeID,
        paymentMethodID: paymentMethodID,
      );
      if (res?.status == 'failed') {
        emit(ErrorMyWalletState(error: res!.errormessage.toString()));
      } else if (res?.message != null) {
        emit(LoadedElectronicWalletState(
            reservationResponseElectronicModel: res!));
      } else {
        emit(ErrorElectronicWalletState(
            error: res!.message!.statusDescription.toString()));
      }
    } catch (e) {
      emit(ErrorElectronicWalletState(error: e.toString()));
    }
  }

  Future<ReservationResponseCreditCard?> addReservationCreditCard({
    required int custId,
    int? paymentMethodID,
    required int paymentTypeID,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,
    required String promocodeid,
    required String curruncy,
    required double totalamount,
  }) async {
    try {
      emit(LoadingCreditCardState());
      final res = await reservationRepo.addReservationCreditCard(
          custId: custId,
          curruncy: curruncy,
          totalamount: totalamount,
          paymentTypeID: paymentTypeID,
          trips: Routes.resrvedtrips,
          paymentMethodID: paymentMethodID,
          promoid: promocodeid,
          cardExpiryMonth: cardExpiryMonth,
          cardExpiryYear: cardExpiryYear,
          cardNumber: cardNumber,
          cvv: cvv);
      if (res?.status == 'success') {
        emit(LoadedCreditCardState(reservationResponseCreditCard: res!));
      } else {
        emit(ErrorCreditCardState(error: res!.errormessage.toString()));
      }
    } catch (e) {
      emit(ErrorCreditCardState(error: e.toString()));
    }
  }

  Future<ReservationResponseCreditCard?> chargebycard({
    required int custId,
    required String amount,
    required String cardNumber,
    required String cardExpiryYear,
    required String cvv,
    required String cardExpiryMonth,
    required String curruncy,
  }) async {
    try {
      emit(LoadingCreditCardState());
      final res = await reservationRepo.chargeusingcard(
          custId: custId,
          curruncy: curruncy,
          amount: amount,
          cardExpiryMonth: cardExpiryMonth,
          cardExpiryYear: cardExpiryYear,
          cardNumber: cardNumber,
          cvv: cvv);
      if (res?.status == 'success') {
        emit(LoadedCreditCardState(reservationResponseCreditCard: res!));
      } else {
        emit(ErrorCreditCardState(error: res!.errormessage.toString()));
      }
    } catch (e) {
      emit(ErrorCreditCardState(error: e.toString()));
    }
  }
}
