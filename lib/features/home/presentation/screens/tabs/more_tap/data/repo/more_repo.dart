import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/Acess_point_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/FAQ_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_classes_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_images_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/privacy_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/send_message_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/terms_and_condition_model.dart';

class MoreRepo {
  final ApiConsumer apiConsumer;
  MoreRepo(this.apiConsumer);

  Future<AboutUsResponse?> getAboutUs() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer
        .get("${EndPoints.baseUrl}Settings/AboutUs?countryID=$countryid");
    log("AboutUsResbonse" + res.body);
    var decode = json.decode(res.body);
    AboutUsResponse aboutUsResponse = AboutUsResponse.fromJson(decode);
    return aboutUsResponse;
  }

  Future<StationsModel?> getStations() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}Stations/SationListFromCityRepeated?countryID=$countryid");
    log("AboutUsResbonse" + res.body);
    var decode = json.decode(res.body);
    StationsModel stationsModel = StationsModel.fromJson(decode);
    return stationsModel;
  }

  Future<BusClassesModel?> getBusClasses() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer
        .get("${EndPoints.baseUrl}Bus/BusServiceClasses?countryID=$countryid");

    log("BusClassResbonse" + res.body);
    var decode = json.decode(res.body);
    BusClassesModel busClassesModel = BusClassesModel.fromJson(decode);
    return busClassesModel;
  }

  Future<LinesModel?> getLines() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer
        .get("${EndPoints.baseUrl}Lines/Lines?countryID=$countryid");

    log("Lines/LinesResbonse" + res.body);
    var decode = json.decode(res.body);
    LinesModel linesModel = LinesModel.fromJson(decode);
    return linesModel;
  }

  Future<Accesspontmodel?> getPoints({String? lineid}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}/Lines/GetAllStationsForSingleLine?lineId=$lineid&countryID=$countryid");

    log("Access point" + res.body);
    var decode = json.decode(res.body);
    Accesspontmodel linesModel = Accesspontmodel.fromJson(decode);
    return linesModel;
  }

  Future<TermsAndConditionModel?> getTermsCondition() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}Settings/TermsAndConditionsList?countryID=$countryid");
    log("TermsCondition" + res.body);
    var decode = json.decode(res.body);
    TermsAndConditionModel termsAndConditionModel =
        TermsAndConditionModel.fromJson(decode);
    return termsAndConditionModel;
  }

  Future<FaqModel?> getFAQ() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer
        .get("${EndPoints.baseUrl}Settings/FAQ?countryID=$countryid");
    log("TermsCondition" + res.body);
    var decode = json.decode(res.body);
    FaqModel faqModel = FaqModel.fromJson(decode);
    return faqModel;
  }

  Future<PrivacyModel?> getPrinacy() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}Settings/PrivacyPolicyList?countryID=$countryid");
    log("Privacy" + res.body);
    var decode = json.decode(res.body);
    PrivacyModel privacyModel = PrivacyModel.fromJson(decode);
    return privacyModel;
  }

  Future<BusImagesModel?> getBusImages({required String typeClass}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}Bus/ServiceTypeImage?serviceTypeId=$typeClass&countryID=$countryid");

    log("busImages" + res.body);
    var decode = json.decode(res.body);
    BusImagesModel busImagesModel = BusImagesModel.fromJson(decode);
    return busImagesModel;
  }

  Future getmobile() async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}Settings/ContactUsMobileNo?countryID=$countryid");

    log("busImages" + res.body);
    var decode = json.decode(res.body);
    return decode['message'];
  }

  Future<SendMessageModel?> sendMessage(
      {required String name,
      required String email,
      required String message}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );

    final res = await apiConsumer.post(
        "${EndPoints.baseUrl}Settings/SubmitContactUsMessage",
        body: jsonEncode({
          "Name": name,
          "Email": email,
          "Message": message,
          "countryID": countryid
        }));
    log("Privacy" + res.request.body);

    log("Privacy" + res.body);
    var decode = json.decode(res.body);
    SendMessageModel sendMessageModel = SendMessageModel.fromJson(decode);
    return sendMessageModel;
  }
}
