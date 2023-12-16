import 'package:equatable/equatable.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/FAQ_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_classes_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/privacy_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/send_message_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/terms_and_condition_model.dart';

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

class LoadingTermsAndCondition extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadedTermsAndCondition  extends MoreStates{
  TermsAndConditionModel termsAndConditionModel;
  LoadedTermsAndCondition ({required this.termsAndConditionModel});
  @override
  List<Object?> get props => [];
}
class ErrorTermsAndCondition extends MoreStates {
  String msg;

  ErrorTermsAndCondition({required this.msg});

  @override
  List<Object?> get props => [];
}

class LoadingFAQ extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadedFAQ  extends MoreStates{
  FaqModel faqModel;
  LoadedFAQ ({required this.faqModel});
  @override
  List<Object?> get props => [];
}
class ErrorFAQ extends MoreStates {
  String msg;

  ErrorFAQ({required this.msg});

  @override
  List<Object?> get props => [];
}


class LoadingPrivacy extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadedPrivacy  extends MoreStates{
  PrivacyModel privacyModel;
  LoadedPrivacy ({required this.privacyModel});
  @override
  List<Object?> get props => [];
}
class ErrorPrivacy extends MoreStates {
  String msg;

  ErrorPrivacy({required this.msg});

  @override
  List<Object?> get props => [];
}


class LoadingSendMessage extends MoreStates{
  @override
  List<Object?> get props => [];
}
class LoadedSendMessage extends MoreStates{
  SendMessageModel sendMessageModel;
  LoadedSendMessage ({required this.sendMessageModel});
  @override
  List<Object?> get props => [];
}
class ErrorSendMessage extends MoreStates {
  String msg;

  ErrorSendMessage({required this.msg});

  @override
  List<Object?> get props => [];
}