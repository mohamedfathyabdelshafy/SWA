import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Ticketdetails_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/repo/ticket_repo.dart';
import 'package:swa/main.dart';

import 'ticket_history_state.dart';

class TicketCubit extends Cubit<TicketStates> {
  TicketCubit() : super(InitialTicketHistory());
  TicketRepo ticketRepo = TicketRepo(sl());

  Future<ResponseTicketHistoryModel?> getTicketHistory(
      {required int customerId}) async {
    try {
      emit(LoadingTicketHistory());

      final res = await ticketRepo.getTicketHistory(customerId: customerId);
      if (res?.status == "success") {
        emit(LoadedTicketHistory(responseTicketHistoryModel: res!));
      } else {
        emit(ErrorTicketHistory(msg: res?.errorMassage ?? ""));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<TicketdetailsModel?> getTicketdetails({required int tekitid}) async {
    try {
      emit(LoadingTicketHistory());

      final res = await ticketRepo.getTicktdetails(tekitid: tekitid);
      if (res?.status == "success") {
        emit(LoadedTicketdetails(ticketdetailsModel: res!));
      } else {
        emit(ErrorTicketHistory(msg: res?.errorMassage ?? ""));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future geteditpolicy() async {
    try {
      emit(LoadingTicketHistory());

      final res = await ticketRepo.geteditpolicy();
      if (res?.status == "success") {
        log('ahmed 22');
        emit(Loadededitpolicy(message: res.message!));
      } else {
        emit(ErrorTicketHistory(msg: res.errormessage ?? ""));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future cancelticket({required int id}) async {
    try {
      emit(LoadingTicketHistory());

      final res = await ticketRepo.cancelticketfun(resrvationid: id);
      if (res?.status == "success") {
        log('ahmed 22');
        emit(Cancelticketstate(message: res.message!));
      } else {
        emit(Cancelticketstate(message: res.message ?? ""));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
