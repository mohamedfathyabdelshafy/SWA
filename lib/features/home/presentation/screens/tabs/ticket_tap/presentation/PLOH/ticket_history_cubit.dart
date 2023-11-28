import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/repo/ticket_repo.dart';
import 'package:swa/main.dart';

import 'ticket_history_state.dart';

class TicketCubit extends Cubit<TicketStates>{
  TicketCubit():super(InitialTicketHistory());
  TicketRepo ticketRepo = TicketRepo(sl());

  Future<ResponseTicketHistoryModel?> getTicketHistory(
      int customerId
      ) async {
    try{
      emit(LoadingTicketHistory());

      final res = await ticketRepo.getTicketHistory(customerId: customerId);
      if(res != null) {
      }
        emit(ErrorTicketHistory(msg: "SomeThing went wrong please try again"));

    }catch(e){
      print(e.toString());
    }
  }
}