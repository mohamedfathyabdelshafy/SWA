import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/times_trips/data/repo/times_trips_repo.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_states.dart';

import '../../../../main.dart';
import '../../data/models/TimesTripsResponsedart.dart';

class TimesTripsCubit extends Cubit<TimesTripsStates> {
  TimesTripsCubit() :super(InitialTimesTrips());
TimesTripsRepo timesTripsRepo = TimesTripsRepo(apiConsumer: sl(),);
  Future<TimesTripsResponse?>getTimes({
    required String tripType,
    required String fromStationID,
    required String toStationID,
    required String dateGo,
    required String dateBack
})async {
    try{
      emit(LoadingTimesTrips());
      final res = await timesTripsRepo.getTimesTrip(
        TripType: tripType,
        FromStationID: fromStationID,
        ToStationID: toStationID,
        DateGo: dateGo,
        DateBack: dateBack,
      );
      if(res.message != null){
        emit(LoadedTimesTrips(timesTripsResponse: res));
      }else{
        emit(ErrorTimesTrips(msg: res.message.toString()));
      }
    }catch (e){
      print(e.toString());
    }
  }
}