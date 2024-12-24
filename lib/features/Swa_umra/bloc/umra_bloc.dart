import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/features/Swa_umra/models/City_umra_model.dart';
import 'package:swa/features/Swa_umra/models/Trip_umra_model.dart';
import 'package:swa/features/Swa_umra/models/campain_list_model.dart';
import 'package:swa/features/Swa_umra/models/campain_model.dart';
import 'package:swa/features/Swa_umra/models/seats_model.dart';
import 'package:swa/features/Swa_umra/repository/Umra_repository.dart';
import 'package:swa/features/app_info/data/models/city_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/promocode_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/send_message_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Electronic_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_response_MyWallet_model.dart';
import 'package:swa/select_payment2/data/models/policyTicket_model.dart';

part 'umra_event.dart';
part 'umra_state.dart';

class UmraBloc extends Bloc<UmraEvent, UmraState> {
  UmraRepos umraRepos = UmraRepos();
  UmraBloc() : super(UmraState.init()) {
    on<TripUmraTypeEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getTripUmraType();

      emit(state.update(isloading: false, tripUmramodel: response));
    });

    on<GetcityEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getcity();
      emit(state.update(isloading: false, cityUmramodel: response));
    });

    on<GetcampainEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getcampaint();
      emit(state.update(isloading: false, campainModel: response));
    });

    on<GetcampaginsListEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response =
          await umraRepos.getcampaginlist(city: event.city, date: event.date);
      emit(state.update(isloading: false, triplistmodel: response));
    });

    on<GetSeatsEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getseats(tripid: event.tripId);
      emit(state.update(isloading: false, seatsmodel: response));
    });

    on<HoldseatEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response =
          await umraRepos.holdseat(tripid: event.tripId, seatId: event.seatId);
      emit(state.update(isloading: false, sendMessageModel: response));
    });

    on<RemoveHoldSeatEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.removeholdseats(
          tripid: event.tripId, seatId: event.seatsId!);
      emit(state.update(isloading: false, sendMessageModel: response));
    });
    on<CheckpromcodeEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.checkpromocode(code: event.code!);
      emit(state.update(isloading: false, promocodemodel: response));
    });

    on<WalletdetactionEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.addReservationMyWallet(
          paymentTypeID: event.paymentTypeID,
          PaymentMethodID: event.PaymentMethodID);
      emit(state.update(
          isloading: false, reservationResponseMyWalletModel: response));
    });

    on<cardpaymentEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.addReservationCardpay(
          paymentTypeID: event.paymentTypeID,
          PaymentMethodID: event.PaymentMethodID,
          cardExpiryMonth: event.cardExpiryMonth,
          cardExpiryYear: event.cardExpiryYear,
          cardNumber: event.cardNumber,
          cvv: event.cvv);
      emit(state.update(
          isloading: false, reservationResponseCreditCard: response));
    });

    on<FawrypayEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.fawrypayment(
        paymentTypeID: event.paymentTypeID,
        PaymentMethodID: event.PaymentMethodID,
      );
      emit(state.update(
          isloading: false, reservationResponseElectronicModel: response));
    });

    on<ElectronicwalletEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.ellectronicwallet(
          paymentTypeID: event.paymentTypeID,
          PaymentMethodID: event.PaymentMethodID,
          phone: event.phone);
      emit(state.update(
          isloading: false, reservationResponseElectronicModel: response));
    });

    on<Getpolicyevent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getpolicy();
      if (response is Policyticketmodel) {
        emit(state.update(isloading: false, policyticketmodel: response));
      }
    });
  }
}
