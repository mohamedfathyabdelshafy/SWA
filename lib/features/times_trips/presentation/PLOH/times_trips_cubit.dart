import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/times_trips/data/repo/times_trips_repo.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_states.dart';

import '../../../../main.dart';
import '../../data/models/TimesTripsResponsedart.dart';

class TimesTripsCubit extends Cubit<TimesTripsStates> {
  TimesTripsCubit() :super(InitialTimesTrips());
TimesTripsRepo timesTripsRepo = TimesTripsRepo(apiConsumer: sl(),);
  Future<TimesTripsResponse?>getTimes({
    required String TripType,
    required String FromStationID,
    required String ToStationID,
    required String DateGo,
    required String DateBack
})async {
    try{
      emit(LoadingTimesTrips());
      final res = await timesTripsRepo.getTimesTrip(
        TripType: TripType,
        FromStationID: FromStationID,
        ToStationID: ToStationID,
        DateGo: DateGo,
        DateBack: DateBack,
      );
      if(res.message != null){
        emit(LoadedTimesTrips(timesTripsResponse: res));
      }else{
        emit(ErrorTimesTrips(msg: res.message.toString()));
      }
    }catch (e){
      emit(ErrorTimesTrips(msg: e.toString()));
    }
  }
}