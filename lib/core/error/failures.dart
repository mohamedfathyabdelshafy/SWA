import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String? message;

  Failure(this.message);
  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return '$message';
  }
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class CacheFailure extends Failure{
  CacheFailure(super.message);
}