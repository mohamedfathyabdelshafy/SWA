import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:swa/core/error/failures.dart';

//Create an abstract useCase so that we can use it anywhere in application it returns Type and takes Params
//This class implements callable class so that it can ( execute, log or any other function ) ( generic function )
abstract class UseCase<Type, Params>{
  Future<Either<Failure, Type>> call(Params params);
}
//Create a class where method is taking no params
class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}