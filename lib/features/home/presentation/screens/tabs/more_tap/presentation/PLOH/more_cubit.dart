import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/main.dart';

class MoreCubit extends Cubit<MoreStates>{
  MoreCubit():super(InitialMoreStates());
  MoreRepo moreRepo = MoreRepo(sl());

  Future<AboutUsResponse?> getAboutUs(
      ) async {
    try{
      emit(LoadingAboutUs());

      final res = await moreRepo.getAboutUs();
      if(res != null) {
        emit(LoadedAboutUs(aboutUsResponse: res));
      }
      // emit(ErrorAboutUs(msg: "SomeThing went wrong please try again"));

    }catch(e){
      print(e.toString());
    }
  }


  Future<AboutUsResponse?> getStations(
      ) async {
    try{
      emit(LoadingStations());

      final res = await moreRepo.getStations();
      if(res != null) {
        emit(LoadedStations(stationsModel: res));
      }

    }catch(e){
      print(e.toString());
    }
  }
  Future<LinesModel?> getLines(
      ) async {
    try{
      emit(LoadingLines());

      final res = await moreRepo.getLines();
      if(res != null) {
        emit(LoadedLines(linesModel: res));
      }

    }catch(e){
      print(e.toString());
    }
  }

  Future<AboutUsResponse?> getBusClass(
      ) async {
    try{
      emit(LoadingBussClass());

      final res = await moreRepo.getBusClasses();
      if(res != null) {
        emit(LoadedBussClass(busClassesModel: res));
      }

    }catch(e){
      print(e.toString());
    }
  }
}