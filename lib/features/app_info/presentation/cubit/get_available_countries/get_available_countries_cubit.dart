import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/error/failures.dart';
import 'package:swa/core/usecases/usecase.dart';
import 'package:swa/features/app_info/domain/entities/country.dart';
import 'package:swa/features/app_info/domain/use_cases/get_available_countries_usecase.dart';

part 'get_available_countries_cubit_state.dart';

class GetAvailableCountriesCubit
    extends Cubit<GetAvailableCountriesCubitState> {
  final GetAvailableCountriesUseCase getAvailableCountriesUseCase;

  GetAvailableCountriesCubit({required this.getAvailableCountriesUseCase})
      : super(GetAvailableCountriesInitialState());

  Future<void> getAvailableCountries() async {
    emit(GetAvailableCountriesLoadingState());
    Either<Failure, List<Country>> response =
        await getAvailableCountriesUseCase(NoParams());
    emit(
      response.fold(
        (failure) => GetAvailableCountriesErrorState(error: failure.toString()),
        (countries) => GetAvailableCountriesLoadedState(countries: countries),
      ),
    );
  }
}
