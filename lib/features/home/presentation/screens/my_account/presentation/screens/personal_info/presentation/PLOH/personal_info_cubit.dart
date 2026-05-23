import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/model/personal_info_edit_response.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/repo/personal_info_repo.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/PLOH/personal_info_states.dart';
import 'package:swa/main.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoStates> {
  PersonalInfoCubit() : super(PersonalInfoInitial());

  PersonalInfoRepo personalInfoRepo = PersonalInfoRepo(sl());

  Future<PersonalInfoEditResponse?> getPersonalInfoEdit({
    required int customerId,
    required String name,
    required String mobile,
    required String email,
    required String userLoginId,
    required int countryId,
    required int cityid,
  }) async {
    try {
      emit(PersonalInfoLoading());
      final res = await personalInfoRepo.getPersonalInfoEdit(
          customerId: customerId,
          name: name,
          mobile: mobile,
          email: email,
          userLoginId: userLoginId,
          CountryID: countryId.toString(),
          CityID: cityid.toString());
      if (res!.message == 'success') {
        emit(PersonalInfoLoaded(personalInfoResponse: res));
      } else {
        emit(PersonalInfoError(msg: res.message!));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
