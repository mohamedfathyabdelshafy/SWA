import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/main.dart';


Future<void> TicketHistoryInjectionInit() async{
  sl.registerFactory<TicketCubit>(() => TicketCubit());

}