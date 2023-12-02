import 'dart:convert';
import 'dart:developer';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';

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
}