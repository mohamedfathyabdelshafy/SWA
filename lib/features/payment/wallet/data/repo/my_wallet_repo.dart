import 'dart:convert';
import 'dart:developer';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/payment/wallet/data/model/my_wallet_response_model.dart';

class MyWalletRepo {
  final ApiConsumer apiConsumer;
  MyWalletRepo(this.apiConsumer);

  Future<MyWalletResponseModel?> getMyWallet({required int customerId}) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final res = await apiConsumer.get(
      "${EndPoints.baseUrl}Customer/GetWalletBalance?customerid=$customerId&countryID=$countryid&toCurrency=${Routes.curruncy}",
    );
    log("mywallet" + res.body);
    var decode = jsonDecode(res.body);
    MyWalletResponseModel myWalletResponseModel =
        MyWalletResponseModel.fromJson(decode);
    return myWalletResponseModel;
  }
}
