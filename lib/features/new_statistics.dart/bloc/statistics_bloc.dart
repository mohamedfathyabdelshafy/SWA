import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/features/new_statistics.dart/model/All_statics_model.dart';
import 'package:swa/features/new_statistics.dart/model/Reservationdetails_model.dart';
import 'package:swa/features/new_statistics.dart/model/main_statics_model.dart';
import 'package:swa/features/new_statistics.dart/servecies/statisticts_repostary.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsInitial()) {
    on<GetmainstatisticsEvent>(
      (event, emit) => Getmainstatistics(event, emit),
    );

    on<GetAllStatisticsEvent>(
      (event, emit) => GetAllStatistic(event, emit),
    );

    on<getReservationdetailsEvent>(
      (event, emit) => getreservationdetails(event, emit),
    );
  }

  StatistictsRepostary _repostary = StatistictsRepostary();

  Future Getmainstatistics(event, Emitter<StatisticsState> emit) async {
    emit(Loading());

    final res = await _repostary.getmaindata();
    if (res is MainStaticsModel) {
      emit(MainstatisticsState(mainStaticsModel: res));
    }
  }

  Future GetAllStatistic(event, Emitter<StatisticsState> emit) async {
    emit(Loading());

    final res = await _repostary.getallStatics();
    if (res is AllStaticsModel) {
      emit(AllstatisticsState(allStaticsModel: res));
    }
  }

  Future getreservationdetails(getReservationdetailsEvent event, Emitter<StatisticsState> emit) async {
    emit(Loading());

    final res = await _repostary.getReservationsDetails(reservationID: event.id);
    if (res is ReservationDetailsModel) {
      emit(ReservationdetailsState(reservationdetailsModel: res, reservation: event.reservation));
    }
  }
}
