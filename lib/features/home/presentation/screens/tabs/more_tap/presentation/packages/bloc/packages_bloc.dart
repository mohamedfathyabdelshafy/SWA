import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/features/home/data/models/Ads_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/ActivePackage_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/Ads_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/packages_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/promocode_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/station_from_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Credit_Card.dart';
import 'package:swa/select_payment2/data/models/Reservation_Response_Electronic_model.dart';
import 'package:swa/select_payment2/data/models/Reservation_response_MyWallet_model.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';

part 'packages_event.dart';
part 'packages_state.dart';

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  PackagesBloc() : super(PackagesState.init()) {
    on<PackagesEvent>((event, emit) async {
      // TODO: implement event handler

      if (event is stationfromEvent) {
        emit(state.update(isloading: true));

        StationfromModel stationfromModel =
            await _packagesRespo.getstationfrom();

        emit(
            state.update(isloading: false, stationfromModel: stationfromModel));
      } else if (event is stationtoEvent) {
        emit(state.update(isloading: true));

        StationfromModel stationfromModel =
            await _packagesRespo.getstationto(stationid: event.stationid);

        emit(
            state.update(isloading: false, stationfromModel: stationfromModel));
      } else if (event is packagesEvent) {
        emit(state.update(isloading: true));

        Packagemodel stationfromModel = await _packagesRespo.getpackages(
            stationtoid: event.stationtoid, stationfromid: event.stationfromid);

        emit(state.update(isloading: false, packagemodel: stationfromModel));
      } else if (event is GetactivepackageEvent) {
        emit(state.update(isloading: true));

        ActivePackagemodel activePackagemodel =
            await _packagesRespo.getactivepackages();

        emit(state.update(
            isloading: false, activePackagemodel: activePackagemodel));
      } else if (event is GetadsEvent) {
        emit(state.update(isloading: true));

        AdsModel activePackagemodel = await _packagesRespo.getads();

        emit(state.update(isloading: false, adsModel: activePackagemodel));
      } else if (event is GetpopupadsEvent) {
        emit(state.update(isloading: true));

        AdvModel advModel = await _packagesRespo.getadsfunc();

        emit(state.update(isloading: false, advModel: advModel));
      } else if (event is PromocodeEvent) {
        emit(state.update(isloading: true));

        Promocodemodel stationfromModel = await _packagesRespo.promocode(
            code: event.promocode!, packageid: event.packageid);

        emit(state.update(isloading: false, promocodemodel: stationfromModel));
      } else if (event is PromocodReservationEvent) {
        emit(state.update(isloading: true));

        Promocodemodel stationfromModel =
            await _packagesRespo.promocodeRecervation(
                code: event.promocode!,
                custId: event.custId!,
                paymentTypeID: event.paymentTypeID!,
                promoid: event.promocodeid!,
                trips: event.trips!);

        emit(state.update(isloading: false, promocodemodel: stationfromModel));
      } else if (event is packagecardpayment) {
        emit(state.update(isloading: true));

        ReservationResponseCreditCard res =
            await _packagesRespo.packagespaycard(
          amount: double.parse(event.Amount!),
          cardExpiryMonth: event.cardExpiryMonth!,
          cardExpiryYear: event.cardExpiryYear!,
          cardNumber: event.cardNumber!,
          cvv: event.cvv!,
          fromStationID: event.FromStationID.toString(),
          packageid: event.PackageID!,
          paymentTypeID: event.PaymentTypeID!,
          toStationId: event.ToStationID.toString(),
          paymentMethodID: event.PaymentMethodID,
        );

        emit(
            state.update(isloading: false, reservationResponseCreditCard: res));
      } else if (event is packagefawryEvent) {
        emit(state.update(isloading: true));

        ReservationResponseElectronicModel res = await _packagesRespo.fawrypay(
          amount: double.parse(event.Amount!),
          paymentMethodID: event.PaymentMethodID.toString(),
          fromStationID: event.FromStationID.toString(),
          packageid: event.PackageID!,
          paymentTypeID: event.PaymentTypeID!,
          toStationId: event.ToStationID.toString(),
        );

        emit(state.update(
            isloading: false, reservationResponseElectronicModel: res));
      } else if (event is packeydetcutpaymentevent) {
        emit(state.update(isloading: true));

        ReservationResponseMyWalletModel stationfromModel =
            await _packagesRespo.packagepaywallet(
                amount: event.Amount!,
                fromStationID: event.FromStationID.toString(),
                packageid: event.PackageID!,
                paymentTypeID: event.PaymentTypeID!,
                promocodeid: event.PromoCodeID!,
                toStationId: event.ToStationID.toString(),
                paymentMethodID: event.PaymentMethodID.toString());

        emit(state.update(
            isloading: false,
            reservationResponseMyWalletModel: stationfromModel));
      } else if (event is PackageelectronicEvent) {
        // emit(state.update(isloading: true));

        ReservationResponseElectronicModel stationfromModel =
            await _packagesRespo.electronicpay(
                amount: double.parse(event.Amount!),
                fromStationID: event.FromStationID.toString(),
                packageid: event.PackageID!,
                paymentTypeID: event.PaymentTypeID!,
                mobile: event.phone!,
                toStationId: event.ToStationID.toString(),
                paymentMethodID: event.PaymentMethodID.toString());

        emit(state.update(
            isloading: false,
            reservationResponseElectronicModel: stationfromModel));
      } else if (event is checkversionevent) {
        // emit(state.update(isloading: true));

        final res = await _packagesRespo.checkversion();

        emit(state.update(isloading: false, updateversion: res));
      }
    });
  }

  PackagesRespo _packagesRespo = new PackagesRespo();
}
