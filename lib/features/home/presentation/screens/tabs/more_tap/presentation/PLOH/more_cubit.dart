import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/main.dart';

class MoreCubit extends Cubit<MoreStates>{
  MoreCubit():super(InitialMoreStates());
  MoreRepo moreRepo = MoreRepo(sl());

  Future<AboutUsResponse?> getTicketHistory(
      int customerId
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
}