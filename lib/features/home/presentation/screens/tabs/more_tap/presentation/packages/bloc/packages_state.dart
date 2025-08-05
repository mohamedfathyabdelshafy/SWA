part of 'packages_bloc.dart';

class PackagesState {
  bool? isloading;
  AdvModel? advModel;
  StationfromModel? stationfromModel;
  AdsModel? adsModel;
  Selectappmodel? selectappmodel;
  InstitutionsModel? institutionsmodel;
  String? updateversion;
  Packagemodel? packagemodel;
  Promocodemodel? promocodemodel;
  ActivePackagemodel? activePackagemodel;
  ReservationResponseElectronicModel? reservationResponseElectronicModel;
  ReservationResponseCreditCard? reservationResponseCreditCard;
  ReservationResponseMyWalletModel? reservationResponseMyWalletModel;
  PackagesState(
      {this.isloading,
      this.updateversion,
      this.reservationResponseElectronicModel,
      this.stationfromModel,
      this.advModel,
      this.selectappmodel,
      this.adsModel,
      this.institutionsmodel,
      this.reservationResponseMyWalletModel,
      this.promocodemodel,
      this.packagemodel,
      this.reservationResponseCreditCard,
      this.activePackagemodel});

  factory PackagesState.init() {
    return PackagesState(
        isloading: false,
        updateversion: '',
        institutionsmodel: InstitutionsModel(),
        advModel: AdvModel(message: []),
        adsModel: AdsModel(message: []),
        reservationResponseElectronicModel: ReservationResponseElectronicModel(),
        reservationResponseCreditCard: ReservationResponseCreditCard(),
        reservationResponseMyWalletModel: ReservationResponseMyWalletModel(),
        promocodemodel: Promocodemodel(),
        activePackagemodel: ActivePackagemodel(
            message: packages(packageName: '', remaingTrip: 0, toDate: '', tripCount: 0, tripDone: 0)),
        stationfromModel: StationfromModel(),
        packagemodel: Packagemodel(message: [], errormessage: ''));
  }

  PackagesState update(
      {bool? isloading,
      AdvModel? advModel,
      String? updateversion,
      Selectappmodel? selectappmodel,
      Promocodemodel? promocodemodel,
      AdsModel? adsModel,
      InstitutionsModel? institutionsmodel,
      ReservationResponseElectronicModel? reservationResponseElectronicModel,
      ActivePackagemodel? activePackagemodel,
      ReservationResponseCreditCard? reservationResponseCreditCard,
      ReservationResponseMyWalletModel? reservationResponseMyWalletModel,
      StationfromModel? stationfromModel,
      Packagemodel? packagemodel}) {
    return PackagesState(
        isloading: isloading,
        advModel: advModel,
        institutionsmodel: institutionsmodel,
        selectappmodel: selectappmodel,
        updateversion: updateversion,
        adsModel: adsModel ?? this.adsModel,
        reservationResponseElectronicModel: reservationResponseElectronicModel,
        reservationResponseMyWalletModel: reservationResponseMyWalletModel,
        promocodemodel: promocodemodel,
        reservationResponseCreditCard: reservationResponseCreditCard,
        activePackagemodel: activePackagemodel ?? activePackagemodel,
        packagemodel: packagemodel ?? this.packagemodel,
        stationfromModel: stationfromModel);
  }
}
