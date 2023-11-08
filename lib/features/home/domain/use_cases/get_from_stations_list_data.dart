import 'package:dartz/dartz.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/forgot_password/domain/entities/message_response.dart';
import 'package:swa/features/home/domain/repositories/home_repository.dart';

class GetFromStationsListDataUseCase implements UseCase<MessageResponse, NoParams>{ //List<FromStations>
  final HomeRepository homeRepository;
  GetFromStationsListDataUseCase({required this.homeRepository});

  @override
  Future<Either<Failure, MessageResponse>> call(NoParams params) { //List<FromStations>
    return homeRepository.getFromStationsData(params);
  }
}