import 'package:swa/features/payment/select_payment/presentation/data/remote/payment_methods_rds.dart';
import 'package:swa/features/reusable_payment/data/models/payment_method.dart';

abstract class PaymentMethodsRepo {
  Future<List<PaymentMethod>> getPaymentMethods({bool includeWallet = true});
}

class PaymentMethodsRepoImpl implements PaymentMethodsRepo {
  final PaymentMethodsRDS _paymentMethodsRDS;

  PaymentMethodsRepoImpl({required PaymentMethodsRDS paymentMethodsRDS})
      : _paymentMethodsRDS = paymentMethodsRDS;

  @override
  Future<List<PaymentMethod>> getPaymentMethods({bool includeWallet = true}) =>
      _paymentMethodsRDS.getPaymentMethods(includeWallet: includeWallet);
}
