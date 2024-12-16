import 'dart:convert';
import 'dart:developer';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/model/personal_info_edit_response.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/model/personal_info_response.dart';

class PersonalInfoRepo {
  final ApiConsumer apiConsumer;
  PersonalInfoRepo(this.apiConsumer);

  Future<PersonalInfoResponse?> getPersonalInfo(
      {required int customerId}) async {
    var res = await apiConsumer
        .get("${EndPoints.baseUrl}Customer/Details?customerID=$customerId");
    var decode = jsonDecode(res.body);

    PersonalInfoResponse personalInfoResponse =
        PersonalInfoResponse.fromJson(decode);
    log(await res.body);
    return personalInfoResponse;
  }

  Future<PersonalInfoEditResponse?> getPersonalInfoEdit({
    required int customerId,
    required String name,
    required String mobile,
    required String email,
    required String userLoginId,
    required String CountryID,
    required String CityID,
  }) async {
    var response = await apiConsumer.post(
      EndPoints.personalEdit,
      body: jsonEncode({
        "CustomerID": customerId,
        "Name": name,
        "Mobile": mobile,
        "Email": email,
        "UserLogInID": userLoginId,
        "CountryID": CountryID,
        "CityID": CityID,
      }),
    );
    log('ReservationResponse ' + response.body);

    var decodedResponse = json.decode(response.body);
    PersonalInfoEditResponse personalInfoEditResponse =
        PersonalInfoEditResponse.fromJson(decodedResponse);
    print("response ${json.decode(response.body)}");
    return personalInfoEditResponse;
  }
}
