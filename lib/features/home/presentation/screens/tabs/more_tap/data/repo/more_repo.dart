import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/FAQ_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_classes_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_images_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/privacy_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/send_message_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/terms_and_condition_model.dart';

class MoreRepo{
  final ApiConsumer apiConsumer;
  MoreRepo(this.apiConsumer);

  Future<AboutUsResponse?> getAboutUs()async{

    final res = await apiConsumer.get(
      EndPoints.aboutUs
    );
    log("AboutUsResbonse"+res.body);
    var decode = json.decode(res.body);
    AboutUsResponse aboutUsResponse = AboutUsResponse.fromJson(decode);
    return aboutUsResponse;
  }

  Future<StationsModel?> getStations()async{

    final res = await apiConsumer.get(
        EndPoints.stations
    );
    log("AboutUsResbonse"+res.body);
    var decode = json.decode(res.body);
    StationsModel stationsModel = StationsModel.fromJson(decode);
    return stationsModel;
  }

  Future<BusClassesModel?> getBusClasses()async{

    final res = await apiConsumer.get(
        EndPoints.busClass
    );
    log("BusClassResbonse"+res.body);
    var decode = json.decode(res.body);
    BusClassesModel busClassesModel = BusClassesModel.fromJson(decode);
    return busClassesModel;
  }


  Future<LinesModel?> getLines()async{

    final res = await apiConsumer.get(
        EndPoints.lines
    );
    log("Lines/LinesResbonse"+res.body);
    var decode = json.decode(res.body);
    LinesModel linesModel = LinesModel.fromJson(decode);
    return linesModel;
  }

  Future<TermsAndConditionModel?> getTermsCondition()async{

    final res = await apiConsumer.get(
        EndPoints.termsAndCondition
    );
    log("TermsCondition"+res.body);
    var decode = json.decode(res.body);
    TermsAndConditionModel termsAndConditionModel = TermsAndConditionModel.fromJson(decode);
    return termsAndConditionModel;
  }


  Future<FaqModel?> getFAQ()async{

    final res = await apiConsumer.get(
        EndPoints.FAQ
    );
    log("TermsCondition"+res.body);
    var decode = json.decode(res.body);
    FaqModel faqModel = FaqModel.fromJson(decode);
    return faqModel;
  }
  Future<PrivacyModel?> getPrinacy()async{

    final res = await apiConsumer.get(
        EndPoints.privacy
    );
    log("Privacy"+res.body);
    var decode = json.decode(res.body);
    PrivacyModel privacyModel = PrivacyModel.fromJson(decode);
    return privacyModel;
  }

  Future<BusImagesModel?> getBusImages({
    required String typeClass
})async{

    final res = await apiConsumer.get(
       "${EndPoints.baseUrl}Bus/ServiceTypeImage?serviceTypeId=$typeClass"
    );
    log("busImages"+res.body);
    var decode = json.decode(res.body);
    BusImagesModel busImagesModel = BusImagesModel.fromJson(decode);
    return busImagesModel;
  }



  Future<SendMessageModel?> sendMessage({
    required String name,
    required String email,
    required String message
})async{

    final res = await apiConsumer.post(
        EndPoints.sendEmail,
      body: jsonEncode({
        "Name":name,
        "Email":email,
        "Message":message
      })
    );
    log("Privacy"+res.body);
    var decode = json.decode(res.body);
    SendMessageModel sendMessageModel = SendMessageModel.fromJson(decode);
    return sendMessageModel;
  }
}