import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';

import '../../main.dart';

Future<void> TimesTripInjectionInit() async{
  sl.registerFactory<TimesTripsCubit>(() => TimesTripsCubit());

}