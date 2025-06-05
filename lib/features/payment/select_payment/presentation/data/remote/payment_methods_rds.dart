import 'dart:convert';

import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/reusable_payment/data/models/payment_method.dart';

abstract class PaymentMethodsRDS {
  Future<List<PaymentMethod>> getPaymentMethods({bool includeWallet = false});
}

class PaymentMethodsRDSImpl implements PaymentMethodsRDS {
  ApiConsumer apiConsumer;
  PaymentMethodsRDSImpl({required this.apiConsumer});
  @override
  Future<List<PaymentMethod>> getPaymentMethods(
      {bool includeWallet = false}) async {
    var countryid = CacheHelper.getDataToSharedPref(
          key: 'countryid',
        ) ??
        3;
    final res = await apiConsumer.get(
        "${EndPoints.baseUrl}Payment/GetPageList?countryID=$countryid&includWallet=true");

    final decodedResponse = json.decode(res.body);
    final isSuccess = decodedResponse['status'] == 'success';
    if (!isSuccess) throw Exception(decodedResponse['message']);
    return (decodedResponse['message'] as List)
        .map((e) => PaymentMethod.fromJson(e))
        .toList();
  }
}
