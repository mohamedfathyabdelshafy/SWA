part of 'umra_bloc.dart';

class UmraState {
  bool isloading;
  TripUmramodel? tripUmramodel;
  CampainModel? campainModel;
  CityUmramodel? cityUmramodel;
  Triplistmodel? triplistmodel;
  Seatsmodel? seatsmodel;
  Promocodemodel? promocodemodel;
  ReservationResponseMyWalletModel? reservationResponseMyWalletModel;
  ReservationResponseCreditCard? reservationResponseCreditCard;
  ReservationResponseElectronicModel? reservationResponseElectronicModel;
  Policyticketmodel? policyticketmodel;

  SendMessageModel? sendMessageModel;
  UmraState(
      {required this.isloading,
      this.tripUmramodel,
      this.reservationResponseElectronicModel,
      this.cityUmramodel,
      this.promocodemodel,
      this.reservationResponseMyWalletModel,
      this.triplistmodel,
      this.sendMessageModel,
      this.seatsmodel,
      this.reservationResponseCreditCard,
      this.policyticketmodel,
      this.campainModel});

  factory UmraState.init() {
    return UmraState(
        isloading: false,
        policyticketmodel: Policyticketmodel(),
        reservationResponseElectronicModel:
            ReservationResponseElectronicModel(),
        reservationResponseCreditCard: ReservationResponseCreditCard(),
        promocodemodel: Promocodemodel(),
        reservationResponseMyWalletModel: ReservationResponseMyWalletModel(),
        sendMessageModel: SendMessageModel(),
        seatsmodel: Seatsmodel(
            message: Busdata(
                emptySeats: 0,
                totalSeats: 0,
                busDetailsVm: BusDetailsVm(
                  rowList: [],
                  totalColumn: 0,
                  totalRow: 0,
                  totalSeats: 0,
                ))),
        triplistmodel: Triplistmodel(
          message: [
            Campainlist(
              name: ' ',
              tripList: [],
              bgColor: '#ffffff',
            )
          ],
        ),
        campainModel: CampainModel(message: Campain(list: [])),
        cityUmramodel: CityUmramodel(message: []),
        tripUmramodel: TripUmramodel(message: Messageumra(list: [])));
  }

  UmraState update(
      {required bool isloading,
      Policyticketmodel? policyticketmodel,
      ReservationResponseElectronicModel? reservationResponseElectronicModel,
      ReservationResponseCreditCard? reservationResponseCreditCard,
      ReservationResponseMyWalletModel? reservationResponseMyWalletModel,
      Triplistmodel? triplistmodel,
      TripUmramodel? tripUmramodel,
      Seatsmodel? seatsmodel,
      Promocodemodel? promocodemodel,
      SendMessageModel? sendMessageModel,
      CampainModel? campainModel,
      CityUmramodel? cityUmramodel}) {
    return UmraState(
        isloading: isloading,
        policyticketmodel: policyticketmodel,
        reservationResponseElectronicModel: reservationResponseElectronicModel,
        reservationResponseMyWalletModel: reservationResponseMyWalletModel,
        campainModel: campainModel,
        reservationResponseCreditCard: reservationResponseCreditCard,
        promocodemodel: promocodemodel,
        sendMessageModel: sendMessageModel,
        seatsmodel: seatsmodel ?? this.seatsmodel,
        triplistmodel: triplistmodel ?? this.triplistmodel,
        cityUmramodel: cityUmramodel,
        tripUmramodel: tripUmramodel ?? this.tripUmramodel);
  }
}
