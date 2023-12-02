import 'package:equatable/equatable.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';

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