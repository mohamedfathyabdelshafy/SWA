import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';
import 'package:swa/select_payment2/data/repo/reservation_repo/reservation_repo.dart';
import '../../../../../main.dart';
import '../../../data/models/Reservation_response_MyWallet_model.dart';
import 'reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Electronic_model.dart'; // Import this to use it below

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
          custId: custId, paymentTypeID: paymentTypeID, promoid: promocodeid, trips: trips);

      if (res != null) {
        switch (res.status) {
          case 'success':
            emit(LoadedMyWalletState(reservationResponseMyWalletModel: res));
            break;
          case 'failed':
            emit(ErrorMyWalletState(error: res.message.toString())); // Assuming message carries error for failed
            break;
          case 'confirmation':
            emit(ConfirmationMyWalletState(message: res.message.toString()));
            break;
          case 'warning':
            emit(WarningMyWalletState(message: res.message.toString()));
            break;
          case 'image':
            emit(ImageMyWalletState(message: res.message.toString()));
            break;
          case 'imagewithgift':
            emit(ImageWithGiftMyWalletState(message: res.message.toString()));
            break;
          default:
            emit(ErrorMyWalletState(error: res.message.toString())); // Default error handling
        }
      } else {
        emit(ErrorMyWalletState(error: "Unknown error occurred."));
      }
      return res;
    } catch (e) {
      log(e.toString());
      emit(ErrorMyWalletState(error: e.toString()));
      return null;
    }
  }

  Future<ReservationResponseElectronicModel?> addReservationElectronicWallet({
    required int custId,
    int? paymentMethodID,
    required int paymentTypeID,
    String? mobile,
    required String promocodeid,
    required List<TripReservationList> trips,
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

      if (res != null) {
        switch (res.status) {
          case 'success':
            emit(LoadedElectronicWalletState(reservationResponseElectronicModel: res));
            break;
          case 'failed':
            print("A77778888");
            emit(ErrorElectronicWalletState(error: res.errormessage.toString()));
            break;
          case 'confirmation':
            emit(ConfirmationElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'warning':
            emit(WarningElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'image':
            emit(ImageElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'imagewithgift':
            emit(ImageWithGiftElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          default:
            emit(ErrorElectronicWalletState(error: res.message?.statusDescription ?? "Unknown status"));
        }
      } else {
        emit(ErrorElectronicWalletState(error: "Unknown error occurred."));
      }
      return res;
    } catch (e) {
      emit(ErrorElectronicWalletState(error: e.toString()));
      return null;
    }
  }

  Future<ReservationResponseElectronicModel?> fawrycharge({
    required int customerid,
    required String amount,
  }) async {
    try {
      emit(LoadingElectronicWalletState());
      final res = await reservationRepo.chargefawrymeth(
        custId: customerid,
        amount: amount,
      );
      if (res != null) {
        // Assuming fawrycharge also returns status field
        switch (res.status) {
          case 'success':
            emit(LoadedElectronicWalletState(reservationResponseElectronicModel: res));
            break;
          case 'failed':
            emit(ErrorMyWalletState(error: res.errormessage.toString()));
            break;
          case 'confirmation':
            emit(ConfirmationElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'warning':
            emit(WarningElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'image':
            emit(ImageElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'imagewithgift':
            emit(ImageWithGiftElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          default:
            emit(ErrorElectronicWalletState(error: res.message?.statusDescription ?? "Unknown status"));
        }
      } else {
        emit(ErrorElectronicWalletState(error: "Unknown error occurred."));
      }
      return res;
    } catch (e) {
      emit(ErrorElectronicWalletState(error: e.toString()));
      return null;
    }
  }

  Future<ReservationResponseElectronicModel?> addReservationFawry({
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
      if (res != null) {
        switch (res.status) {
          case 'success':
            emit(LoadedElectronicWalletState(reservationResponseElectronicModel: res));
            break;
          case 'failed':
            emit(ErrorMyWalletState(error: res.errormessage.toString()));
            break;
          case 'confirmation':
            emit(ConfirmationElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'warning':
            emit(WarningElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'image':
            emit(ImageElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          case 'imagewithgift':
            emit(ImageWithGiftElectronicWalletState(message: res.message?.statusDescription ?? ""));
            break;
          default:
            emit(ErrorElectronicWalletState(error: res.message?.statusDescription ?? "Unknown status"));
        }
      } else {
        emit(ErrorElectronicWalletState(error: "Unknown error occurred."));
      }
      return res;
    } catch (e) {
      emit(ErrorElectronicWalletState(error: e.toString()));
      return null;
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
      if (res != null) {
        switch (res.status) {
          case 'success':
            emit(LoadedCreditCardState(reservationResponseCreditCard: res));
            break;
          case 'failed':
            emit(ErrorCreditCardState(error: res.errormessage.toString()));
            break;
          case 'confirmation':
            emit(ConfirmationCreditCardState(
                message:
                    res.errormessage ?? res.message?.statusDescription ?? "")); // Use errormessage or statusDescription
            break;
          case 'warning':
            emit(WarningCreditCardState(message: res.errormessage ?? res.message?.statusDescription ?? ""));
            break;
          case 'image':
            emit(ImageCreditCardState(message: res.errormessage ?? res.message?.statusDescription ?? ""));
            break;
          case 'imagewithgift':
            emit(ImageWithGiftCreditCardState(message: res.errormessage ?? res.message?.statusDescription ?? ""));
            break;
          default:
            emit(ErrorCreditCardState(error: res.errormessage ?? res.message?.statusDescription ?? "Unknown status"));
        }
      } else {
        emit(ErrorCreditCardState(error: "Unknown error occurred."));
      }
      return res;
    } catch (e) {
      emit(ErrorCreditCardState(error: e.toString()));
      return null;
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

      if (res != null) {
        switch (res.status) {
          case 'success':
            emit(LoadedCreditCardState(reservationResponseCreditCard: res));
            break;
          case 'failed':
            emit(ErrorCreditCardState(error: res.errormessage.toString()));
            break;
          case 'confirmation':
            emit(ConfirmationCreditCardState(message: res.errormessage ?? res.message?.statusDescription ?? ""));
            break;
          case 'warning':
            emit(WarningCreditCardState(message: res.errormessage ?? res.message?.statusDescription ?? ""));
            break;
          case 'image':
            emit(ImageCreditCardState(message: res.errormessage ?? res.message?.statusDescription ?? ""));
            break;
          case 'imagewithgift':
            emit(ImageWithGiftCreditCardState(message: res.errormessage ?? res.message?.statusDescription ?? ""));
            break;
          default:
            emit(ErrorCreditCardState(error: res.errormessage ?? res.message?.statusDescription ?? "Unknown status"));
        }
      } else {
        emit(ErrorCreditCardState(error: "Unknown error occurred."));
      }
      return res;
    } catch (e) {
      emit(ErrorCreditCardState(error: e.toString()));
      return null;
    }
  }
}
