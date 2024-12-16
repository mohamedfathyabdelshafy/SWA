import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/features/Swa_umra/models/City_umra_model.dart';
import 'package:swa/features/Swa_umra/models/Trip_umra_model.dart';
import 'package:swa/features/Swa_umra/models/campain_list_model.dart';
import 'package:swa/features/Swa_umra/models/campain_model.dart';
import 'package:swa/features/Swa_umra/repository/Umra_repository.dart';
import 'package:swa/features/app_info/data/models/city_model.dart';

part 'umra_event.dart';
part 'umra_state.dart';

class UmraBloc extends Bloc<UmraEvent, UmraState> {
  UmraRepos umraRepos = UmraRepos();
  UmraBloc() : super(UmraState.init()) {
    on<TripUmraTypeEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getTripUmraType();

      emit(state.update(isloading: true, tripUmramodel: response));
    });

    on<GetcityEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getcity();
      emit(state.update(isloading: true, cityUmramodel: response));
    });

    on<GetcampainEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getcampaint();
      emit(state.update(isloading: true, campainModel: response));
    });

    on<GetcampaginsListEvent>((event, emit) async {
      emit(state.update(isloading: true));

      final response = await umraRepos.getcampaginlist(
          campainid: event.campain, city: event.city, date: event.date);
      emit(state.update(isloading: true, triplistmodel: response));
    });
  }
}
