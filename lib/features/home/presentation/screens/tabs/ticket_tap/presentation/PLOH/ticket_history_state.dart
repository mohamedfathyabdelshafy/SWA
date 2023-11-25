import 'package:equatable/equatable.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Response_ticket_history_Model.dart';

abstract class TicketStates extends Equatable{
}
class InitialTicketHistory extends TicketStates{
  @override
  List<Object?> get props => [];
}
class LoadingTicketHistory extends TicketStates{
  @override
  List<Object?> get props => [];
}
class LoadedTicketHistory extends TicketStates{
  ResponseTicketHistoryModel responseTicketHistoryModel;
  LoadedTicketHistory({required this.responseTicketHistoryModel});
  @override
  List<Object?> get props => [];
}
class ErrorTicketHistory extends TicketStates{
  String msg;
  ErrorTicketHistory({required this.msg});
  @override
  List<Object?> get props => [];
}