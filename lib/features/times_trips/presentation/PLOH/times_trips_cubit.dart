import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/times_trips/data/repo/times_trips_repo.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_states.dart';

import '../../../../main.dart';

class TimesTripsCubit extends Cubit<TimesTripsStates> {
  TimesTripsCubit() : super(InitialTimesTrips());
  TimesTripsRepo timesTripsRepo = TimesTripsRepo(
    apiConsumer: sl(),
  );
  Future<void> getTimes(
      {required String tripType,
      required String fromStationID,
      required String toStationID,
      required String dateGo,
      int? companeyid,
      int? recommendeID,
      String? startTime,
      String? endTime,
      required String dateBack}) async {
    //try{
    emit(LoadingTimesTrips());
    final res = await timesTripsRepo.getTimesTrip(
        companyID: companeyid,
        TripType: tripType,
        FromStationID: fromStationID,
        ToStationID: toStationID,
        recommendeID: recommendeID,
        DateGo: dateGo,
        DateBack: dateBack,
        startTime: startTime,
        endTime: endTime);
    if (res?.message != null) {
      // getCompaniesList();
      emit(LoadedTimesTrips(timesTripsResponse: res!));
    } else {
      print("failure message ${res?.failureMessage}");
      emit(ErrorTimesTrips(msg: res?.failureMessage.toString() ?? ""));
    }
    // }catch (e){
    //   print(e.toString());
    // }
  }

  Future<void> getCompaniesList() async {
    //try{
    emit(LoadingCompaniesList());
    final res = await timesTripsRepo.getCompaniesTrip();
    if (res?.message != null) {
      emit(LoadedCompaniesList(compaiesModel: res!));
    } else {
      print("failure message ${res?.failureMessage}");
      emit(ErrorCompaniesList(msg: res?.failureMessage.toString() ?? ""));
    }
    // }catch (e){
    //   print(e.toString());
    // }
  }

  Future<void> getRecomendedList() async {
    //try{
    emit(LoadingCompaniesList());
    final res = await timesTripsRepo.getRecommendedTrip();
    if (res?.message != null) {
      emit(LoadedRecommendedList(recommendedModel: res!));
    } else {
      print("failure message ${res?.failureMessage}");
      emit(ErrorCompaniesList(msg: res?.failureMessage.toString() ?? ""));
    }
    // }catch (e){
    //   print(e.toString());
    // }
  }
}
