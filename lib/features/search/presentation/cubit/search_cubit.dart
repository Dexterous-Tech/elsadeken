// File: lib/presentation/cubit/search_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/search_filter.dart';
import '../../logic/use_cases/search_use_cases.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchUseCase;

  SearchCubit(this.searchUseCase) : super(SearchInitial());

  SearchFilter _currentFilter = SearchFilter();

  void updateFilter(SearchFilter filter) {
    _currentFilter = filter;
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateUsername(String username) {
    _currentFilter = _currentFilter.copyWith(username: username);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateQuickSearch(String quickSearch) {
    _currentFilter = _currentFilter.copyWith(quickSearch: quickSearch);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateNationality(String nationality) {
    _currentFilter = _currentFilter.copyWith(nationality: nationality);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateCountry(String country) {
    _currentFilter = _currentFilter.copyWith(country: country);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateCity(String city) {
    _currentFilter = _currentFilter.copyWith(city: city);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateAgeRange(int from, int to) {
    _currentFilter = _currentFilter.copyWith(ageFrom: from, ageTo: to);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateHeightRange(int from, int to) {
    _currentFilter = _currentFilter.copyWith(heightFrom: from, heightTo: to);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateWeightRange(int from, int to) {
    _currentFilter = _currentFilter.copyWith(weightFrom: from, weightTo: to);
    emit(SearchFilterUpdated(_currentFilter));
  }

  Future<void> performSearch() async {
    emit(SearchLoading());
    try {
      final results = await searchUseCase(_currentFilter);
      emit(SearchSuccess(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
