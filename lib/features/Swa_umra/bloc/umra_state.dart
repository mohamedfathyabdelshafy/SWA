part of 'umra_bloc.dart';

class UmraState {
  bool isloading;
  TripUmramodel? tripUmramodel;
  CampainModel? campainModel;
  CityUmramodel? cityUmramodel;
  Triplistmodel? triplistmodel;
  UmraState(
      {required this.isloading,
      this.tripUmramodel,
      this.cityUmramodel,
      this.triplistmodel,
      this.campainModel});

  factory UmraState.init() {
    return UmraState(
        isloading: false,
        triplistmodel: Triplistmodel(message: Campainlist(list: [])),
        campainModel: CampainModel(message: Campain(list: [])),
        cityUmramodel: CityUmramodel(message: []),
        tripUmramodel: TripUmramodel(message: Message(list: [])));
  }

  UmraState update(
      {required bool isloading,
      Triplistmodel? triplistmodel,
      TripUmramodel? tripUmramodel,
      CampainModel? campainModel,
      CityUmramodel? cityUmramodel}) {
    return UmraState(
        isloading: isloading,
        campainModel: campainModel,
        triplistmodel: triplistmodel ?? this.triplistmodel,
        cityUmramodel: cityUmramodel,
        tripUmramodel: tripUmramodel ?? this.tripUmramodel);
  }
}
