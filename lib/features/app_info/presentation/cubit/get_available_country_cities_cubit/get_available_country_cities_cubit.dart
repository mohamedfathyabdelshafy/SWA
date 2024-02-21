import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/features/app_info/domain/entities/city.dart';
import 'package:swa/features/app_info/domain/use_cases/get_country_cities_usecase.dart';

part 'get_available_country_cities_cubit_state.dart';

class GetAvailableCountryCitiesCubit
    extends Cubit<GetAvailableCountryCitiesCubitState> {
  final GetAvailableCountryCitiesUseCase getAvailableCountryCitiesUseCase;

  GetAvailableCountryCitiesCubit(
      {required this.getAvailableCountryCitiesUseCase})
      : super(GetAvailableCountryCitiesInitialState());

  Future<void> getAvailableCountries(int countryId) async {
    emit(GetAvailableCountryCitiesLoadingState());
    Either<Failure, List<City>> response =
        await getAvailableCountryCitiesUseCase(countryId);
    emit(
      response.fold(
        (failure) =>
            GetAvailableCountryCitiesErrorState(error: failure.toString()),
        (cities) => GetAvailableCountryCitiesLoadedState(countryCities: cities),
      ),
    );
  }
}
