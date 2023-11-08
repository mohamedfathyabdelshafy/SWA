import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/forgot_password/domain/use_cases/forgot_password.dart';
import 'package:swa/features/home/domain/entities/from_station.dart';
import 'package:swa/features/home/domain/use_cases/get_from_stations_list_data.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetFromStationsListDataUseCase getFromStationsListDataUseCase;
  final GetToStationsListDataUseCase getToStationsListDataUseCase;

  HomeCubit({required this.getFromStationsListDataUseCase, required this.getToStationsListDataUseCase}) : super(HomeInitial());

  Future<void> getFromStationsListData() async {
    emit(GetFromStationsListLoadingState());
    Either<Failure, MessageResponse> response = await getFromStationsListDataUseCase(NoParams());
    emit(
      response.fold(
        (failure) => GetFromStationsListErrorState(error: failure),
        (messageResponse) => GetFromStationsListLoadedState(messageResponse: messageResponse)
      )
    );
  }

  Future<void> getToStationsListData(ToStationsParams params) async {
    emit(GetToStationsListLoadingState());
    Either<Failure, List<FromStations>> response = await getToStationsListDataUseCase(params);
    emit(
      response.fold(
        (failure) => GetToStationsListErrorState(error: failure),
        (toStations) => GetToStationsListLoadedState(toStations: toStations)
      )
    );
  }

}
