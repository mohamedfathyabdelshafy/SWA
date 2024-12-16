import 'dart:convert';
import 'dart:developer';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/select_payment/data/models/payment_message_response_model.dart';

abstract class EWalletRemoteDataSource {
  Future<PaymentMessageResponseModel> eWallet(EWalletParams params);
}

class EWalletRemoteDataSourceImpl implements EWalletRemoteDataSource {
  final ApiConsumer apiConsumer;
  EWalletRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<PaymentMessageResponseModel> eWallet(EWalletParams params) async {
    var countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    final response = await apiConsumer.post(EndPoints.eWalletPaymentMethod,
        body: jsonEncode({
          "CustomerId": params.customerId,
          "Amount": double.parse(params.amount).toStringAsFixed(2),
          "Mobile": params.mobileNumber,
          "countryID": countryid
        }));

    log(response.body.toString());
    return PaymentMessageResponseModel.fromJson(
        json.decode(response.body.toString()));
  }
}
