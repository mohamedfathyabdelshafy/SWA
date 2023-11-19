import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';

import '../../main.dart';

Future<void> BusLayoutInjectionInit() async{
  sl.registerFactory<ReservationCubit>(() => ReservationCubit());

}