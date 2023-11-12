import 'package:dartz/dartz.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/network/network_info.dart';
import 'package:swa/features/payment/fawry/data/data_sources/fawry_remote_data_source.dart';
import 'package:swa/features/payment/fawry/domain/repositories/fawry_repository.dart';
import 'package:swa/features/payment/fawry/domain/use_cases/fawry_use_case.dart';
import 'package:swa/features/payment/select_payment/domain/entities/payment_message_response.dart';


class FawryPaymentRepositoryImpl implements FawryPaymentRepository {
  final NetworkInfo networkInfo;
  final FawryRemoteDataSource fawryRemoteDataSource;

  FawryPaymentRepositoryImpl({required this.networkInfo, required this.fawryRemoteDataSource});

  @override
  Future<Either<Failure, PaymentMessageResponse>> fawryPayment(FawryParams params) async {
    try {
      final fawry = await fawryRemoteDataSource.fawry(params);
      return Right(fawry);
    } on ServerException catch(error){
      return Left(ServerFailure(error.toString()));
    }
  }


}