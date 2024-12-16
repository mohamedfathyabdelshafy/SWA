import 'package:equatable/equatable.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Ticketdetails_model.dart';

abstract class TicketStates extends Equatable {}

class InitialTicketHistory extends TicketStates {
  @override
  List<Object?> get props => [];
}

class LoadingTicketHistory extends TicketStates {
  @override
  List<Object?> get props => [];
}

class LoadedTicketHistory extends TicketStates {
  ResponseTicketHistoryModel responseTicketHistoryModel;
  LoadedTicketHistory({required this.responseTicketHistoryModel});
  @override
  List<Object?> get props => [];
}

class LoadedTicketdetails extends TicketStates {
  TicketdetailsModel ticketdetailsModel;
  LoadedTicketdetails({required this.ticketdetailsModel});
  @override
  List<Object?> get props => [];
}

class Loadededitpolicy extends TicketStates {
  List<String> message;
  Loadededitpolicy({required this.message});
  @override
  List<Object?> get props => [message];
}

class Cancelticketstate extends TicketStates {
  String message;
  Cancelticketstate({required this.message});
  @override
  List<Object?> get props => [message];
}

class ErrorTicketHistory extends TicketStates {
  String msg;
  ErrorTicketHistory({required this.msg});
  @override
  List<Object?> get props => [];
}
