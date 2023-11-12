import 'dart:convert';
import 'package:swa/core/api/api_consumer.dart';
import 'package:swa/core/api/end_points.dart';
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/select_payment/data/models/payment_message_response_model.dart';

abstract class FawryRemoteDataSource{
  Future<PaymentMessageResponseModel> fawry(FawryParams params);
}

class FawryRemoteDataSourceImpl implements FawryRemoteDataSource {
  final ApiConsumer apiConsumer;
  FawryRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<PaymentMessageResponseModel> fawry(FawryParams params) async{
    final response = await apiConsumer.post(
      ////?CustomerId=${params.customerId}&Amount=${params.amount}'
      EndPoints.fawryPaymentMethod,
      body: jsonEncode({
        "CustomerId": params.customerId,
        "Amount": double.parse(params.amount).toStringAsFixed(2)
      })
    );
    return PaymentMessageResponseModel.fromJson(json.decode(response.body.toString()));
  }


}