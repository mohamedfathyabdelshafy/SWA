import 'package:equatable/equatable.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_classes_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';

abstract class MoreStates extends Equatable{
}
class InitialMoreStates extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadingAboutUs extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadedAboutUs  extends MoreStates{
  AboutUsResponse aboutUsResponse;
  LoadedAboutUs ({required this.aboutUsResponse});
  @override
  List<Object?> get props => [];
}
class ErrorAboutUs  extends MoreStates {
  String msg;

  ErrorAboutUs({required this.msg});

  @override
  List<Object?> get props => [];
}

class LoadingStations extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadedStations  extends MoreStates{
  StationsModel stationsModel;
  LoadedStations ({required this.stationsModel});
  @override
  List<Object?> get props => [];
}
class ErrorStations extends MoreStates {
  String msg;

  ErrorStations({required this.msg});

  @override
  List<Object?> get props => [];
}

class LoadingBussClass extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadedBussClass  extends MoreStates{
  BusClassesModel busClassesModel;
  LoadedBussClass ({required this.busClassesModel});
  @override
  List<Object?> get props => [];
}
class ErrorBussClass extends MoreStates {
  String msg;

  ErrorBussClass({required this.msg});

  @override
  List<Object?> get props => [];
}


class LoadingLines extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadedLines  extends MoreStates{
  LinesModel linesModel;
  LoadedLines ({required this.linesModel});
  @override
  List<Object?> get props => [];
}
class ErrorLines extends MoreStates {
  String msg;

  ErrorLines({required this.msg});

  @override
  List<Object?> get props => [];
}