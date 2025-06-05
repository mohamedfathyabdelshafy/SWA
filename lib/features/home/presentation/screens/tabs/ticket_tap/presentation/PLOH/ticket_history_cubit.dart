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
      return res; // Return the response
    } catch (e) {
      print(e.toString());
      emit(ErrorTicketHistory(
          msg: "Failed to load ticket history: ${e.toString()}"));
      return null;
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
      return res; // Return the response
    } catch (e) {
      print(e.toString());
      emit(ErrorTicketHistory(
          msg: "Failed to load ticket details: ${e.toString()}"));
      return null;
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
      emit(ErrorTicketHistory(
          msg: "Failed to load edit policy: ${e.toString()}"));
    }
  }

  Future cancelticket({required int id, required customerId}) async {
    try {
      emit(
          LoadingTicketHistory()); // Show loading indicator during cancellation

      final res = await ticketRepo.cancelticketfun(resrvationid: id);
      if (res?.status == "success") {
        log('Ticket cancelled successfully');
        emit(Cancelticketstate(message: res.message!));
        // After successful cancellation, refresh ticket history
        await getTicketHistory(customerId: customerId); // Await this call
      } else {
        // If cancellation fails, still attempt to refresh history to show latest state
        emit(Cancelticketstate(message: res?.message ?? "Cancellation failed"));
        await getTicketHistory(customerId: customerId); // Await this call
      }
    } catch (e) {
      print(e.toString());
      emit(ErrorTicketHistory(
          msg: "Error during ticket cancellation: ${e.toString()}"));
      // Even on error, try to refresh the list in case some data changed
      await getTicketHistory(customerId: customerId);
    }
  }
}
