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
      required String dateBack}) async {
    //try{
    emit(LoadingTimesTrips());
    final res = await timesTripsRepo.getTimesTrip(
      TripType: tripType,
      FromStationID: fromStationID,
      ToStationID: toStationID,
      DateGo: dateGo,
      DateBack: dateBack,
    );
    if (res?.message != null) {
      emit(LoadedTimesTrips(timesTripsResponse: res!));
    } else {
      print("failure message ${res?.failureMessage}");
      emit(ErrorTimesTrips(msg: res?.failureMessage.toString() ?? ""));
    }
    // }catch (e){
    //   print(e.toString());
    // }
  }
}
