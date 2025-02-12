import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/features/Swa_umra/models/City_umra_model.dart';
import 'package:swa/features/Swa_umra/models/Transportaion_list_model.dart';
import 'package:swa/features/Swa_umra/models/Trip_umra_model.dart';
import 'package:swa/features/Swa_umra/models/Umra_tickets_model.dart';
import 'package:swa/features/Swa_umra/models/accomidation_model.dart';
import 'package:swa/features/Swa_umra/models/campainlistmodel.dart';
import 'package:swa/features/Swa_umra/models/packages_list_model.dart';
import 'package:swa/features/Swa_umra/models/campain_model.dart';
import 'package:swa/features/Swa_umra/models/page_model.dart';
import 'package:swa/features/Swa_umra/models/payment_type_model.dart';
import 'package:swa/features/Swa_umra/models/programs_model.dart';
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

    on<GetPackageListEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getpackageslist(
          city: event.city,
          umrahReservationID: event.reservationid,
          date: event.date,
          typeid: event.typeid,
          campainid: event.campianID!);
      emit(state.update(isloading: false, packagesModel: response));
    });

    on<GetCompainListEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.Getcampainlist();
      emit(state.update(isloading: false, campainlistmodel: response));
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

    on<EditReservationEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.Edditreservation(
          paymentMethodID: event.paymentMethodID,
          paymentTypeID: event.paymentTypeID,
          resrvationid: event.reservationID,
          paymentid: event.paymentid);
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

    on<cardEditReservationEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.editreservationcard(
          umrareservationid: event.umrareservationid!,
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

    on<FawryEditEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.fawryEdit(
        umrahReservationID: event.umrareservationid!,
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

    on<EditElectronicwalletEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.Editellectronicwallet(
          paymentTypeID: event.paymentTypeID,
          umrareservationid: event.umrahReservationID!,
          PaymentMethodID: event.PaymentMethodID,
          phone: event.phone);
      emit(state.update(
          isloading: false, reservationResponseElectronicModel: response));
    });

    on<Getpolicyevent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getpolicy(type: event.type);
      if (response is Policyticketmodel) {
        emit(state.update(isloading: false, policyticketmodel: response));
      }
    });

    on<CancelReservationEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response =
          await umraRepos.cancelumraTicket(reservationID: event.reservationID);
      if (response is SendMessageModel) {
        emit(state.update(isloading: false, cancelrespnce: response));
      }
    });

    on<GetPageListEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.GetPageList();
      if (response is Pagelistmodel) {
        emit(state.update(isloading: false, pagelistmodel: response));
      }
    });

    on<GetTransportationEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getTransportation(
          tripUmrahID: event.tripUmrahID, reservationID: event.reservationID);
      if (response is TransportationListModel) {
        emit(state.update(isloading: false, transportationListModel: response));
      }
    });

    on<GetAccommodationEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getAccomidation(
          tripUmrahID: event.tripUmrahID,
          umrahReservationID: event.umrahReservationID);
      if (response is AccomidationModel) {
        emit(state.update(isloading: false, accomidationModel: response));
      }
    });

    on<GetprogramsEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getPrograms(
          tripUmrahID: event.tripUmrahID,
          umrahReservationID: event.umrahReservationID);
      if (response is ProgramsModel) {
        emit(state.update(isloading: false, programsModel: response));
      }
    });

    on<getpaymentstypeEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getpayments();
      if (response is Paymenttypemodel) {
        emit(state.update(isloading: false, paymenttypemodel: response));
      }
    });

    on<GetbookedumraEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getbookedumraticket();
      if (response is UmraTicketsModel) {
        emit(state.update(isloading: false, umraTicketsModel: response));
      }
    });
  }
}
