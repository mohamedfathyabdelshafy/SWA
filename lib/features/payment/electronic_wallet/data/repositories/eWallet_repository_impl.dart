import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/features/payment/electronic_wallet/data/data_sources/ewallet_remote_data_source.dart';
import 'package:swa/features/payment/electronic_wallet/domain/repositories/eWallet_repository.dart';
import 'package:swa/features/payment/electronic_wallet/domain/use_cases/ewallet_use_case.dart';
import 'package:swa/features/payment/fawry/data/data_sources/fawry_remote_data_source.dart';
import 'package:swa/features/payment/fawry/domain/repositories/fawry_repository.dart';
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';


class EWalletPaymentRepositoryImpl implements EWalletPaymentRepository {
  final NetworkInfo networkInfo;
  final EWalletRemoteDataSource eWalletRemoteDataSource;

  EWalletPaymentRepositoryImpl({required this.networkInfo, required this.eWalletRemoteDataSource});

  @override
  Future<Either<Failure, PaymentMessageResponse>> eWalletPayment(EWalletParams params) async {
    try {
      final eWallet = await eWalletRemoteDataSource.eWallet(params);
      return Right(eWallet);
    } on ServerException catch(error){
      return Left(ServerFailure(error.toString()));
    }
  }
}