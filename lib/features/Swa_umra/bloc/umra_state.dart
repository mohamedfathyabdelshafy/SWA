part of 'umra_bloc.dart';

class UmraState {
  bool isloading;
  TripUmramodel? tripUmramodel;
  CampainModel? campainModel;
  CityUmramodel? cityUmramodel;
  PackagesModel? packagesModel;
  Pagelistmodel? pagelistmodel;
  Seatsmodel? seatsmodel;
  Promocodemodel? promocodemodel;
  ReservationResponseMyWalletModel? reservationResponseMyWalletModel;
  ReservationResponseCreditCard? reservationResponseCreditCard;
  ReservationResponseElectronicModel? reservationResponseElectronicModel;
  Policyticketmodel? policyticketmodel;
  Campainlistmodel? campainlistmodel;
  SendMessageModel? sendMessageModel;
  TransportationListModel? transportationListModel;
  AccomidationModel? accomidationModel;
  ProgramsModel? programsModel;
  Paymenttypemodel? paymenttypemodel;
  UmraTicketsModel? umraTicketsModel;
  SendMessageModel? cancelrespnce;
  UmraState(
      {required this.isloading,
      this.pagelistmodel,
      this.tripUmramodel,
      this.reservationResponseElectronicModel,
      this.cityUmramodel,
      this.promocodemodel,
      this.reservationResponseMyWalletModel,
      this.packagesModel,
      this.sendMessageModel,
      this.seatsmodel,
      this.reservationResponseCreditCard,
      this.policyticketmodel,
      this.campainlistmodel,
      this.transportationListModel,
      this.campainModel,
      this.accomidationModel,
      this.programsModel,
      this.paymenttypemodel,
      this.cancelrespnce,
      this.umraTicketsModel});

  factory UmraState.init() {
    return UmraState(
        isloading: false,
        pagelistmodel: Pagelistmodel(),
        campainlistmodel: Campainlistmodel(message: Campainlis(list: [])),
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
        packagesModel: PackagesModel(message: []),
        campainModel: CampainModel(message: Campain(list: [])),
        cityUmramodel: CityUmramodel(message: []),
        tripUmramodel: TripUmramodel(message: Messageumra(list: [])),
        transportationListModel: TransportationListModel(),
        accomidationModel: AccomidationModel(),
        programsModel: ProgramsModel(),
        paymenttypemodel: Paymenttypemodel(),
        umraTicketsModel: UmraTicketsModel());
  }

  UmraState update({
    required bool isloading,
    Pagelistmodel? pagelistmodel,
    Policyticketmodel? policyticketmodel,
    ReservationResponseElectronicModel? reservationResponseElectronicModel,
    ReservationResponseCreditCard? reservationResponseCreditCard,
    ReservationResponseMyWalletModel? reservationResponseMyWalletModel,
    PackagesModel? packagesModel,
    TripUmramodel? tripUmramodel,
    Campainlistmodel? campainlistmodel,
    Seatsmodel? seatsmodel,
    Promocodemodel? promocodemodel,
    SendMessageModel? sendMessageModel,
    CampainModel? campainModel,
    CityUmramodel? cityUmramodel,
    TransportationListModel? transportationListModel,
    AccomidationModel? accomidationModel,
    ProgramsModel? programsModel,
    Paymenttypemodel? paymenttypemodel,
    UmraTicketsModel? umraTicketsModel,
    SendMessageModel? cancelrespnce,
  }) {
    return UmraState(
        isloading: isloading,
        policyticketmodel: policyticketmodel,
        pagelistmodel: pagelistmodel,
        campainlistmodel: campainlistmodel,
        reservationResponseElectronicModel: reservationResponseElectronicModel,
        reservationResponseMyWalletModel: reservationResponseMyWalletModel,
        campainModel: campainModel,
        reservationResponseCreditCard: reservationResponseCreditCard,
        promocodemodel: promocodemodel,
        sendMessageModel: sendMessageModel,
        seatsmodel: seatsmodel,
        packagesModel: packagesModel ?? this.packagesModel,
        cityUmramodel: cityUmramodel,
        tripUmramodel: tripUmramodel ?? this.tripUmramodel,
        transportationListModel: transportationListModel,
        accomidationModel: accomidationModel,
        programsModel: programsModel,
        paymenttypemodel: paymenttypemodel,
        cancelrespnce: cancelrespnce,
        umraTicketsModel: umraTicketsModel);
  }
}
