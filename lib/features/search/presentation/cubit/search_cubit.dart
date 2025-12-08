// File: lib/presentation/chat_settings_cubit/search_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elsadeken/features/search/domain/entities/search_filter.dart';
import 'package:elsadeken/features/search/logic/use_cases/search_use_cases.dart';

import '../../../profile/interests_list/data/models/users_response_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchUseCase;

  SearchCubit(this.searchUseCase) : super(SearchInitial());

  SearchFilter _currentFilter = SearchFilter(latest: 1);

  SearchFilter get currentFilter => _currentFilter;

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

  void updateQualification(String qualificationId) {
    _currentFilter = _currentFilter.copyWith(qualificationId: qualificationId);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateSortByLatest(bool isLatest) {
    _currentFilter = _currentFilter.copyWith(latest: isLatest ? 1 : 0);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateMaritalStatus(String maritalStatus) {
    _currentFilter = _currentFilter.copyWith(maritalStatus: maritalStatus);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateTypeOfMarriage(String typeOfMarriage) {
    _currentFilter = _currentFilter.copyWith(typeOfMarriage: typeOfMarriage);
    emit(SearchFilterUpdated(_currentFilter));
  }

  void updateSkinColor(String skinColor) {
    _currentFilter = _currentFilter.copyWith(skinColor: skinColor);
    emit(SearchFilterUpdated(_currentFilter));
  }

  Future<void> performSearch({int page = 1}) async {
    if (page == 1) {
      emit(SearchLoading());
    }
    try {
      final results = await searchUseCase.searchUsers(
        _currentFilter,
        page: page,
      );

      if (state is SearchSuccess && page > 1) {
        // Append results for pagination
        final currentState = state as SearchSuccess;
        final updatedResults = currentState.results;
        emit(
          SearchSuccess(
            updatedResults,
            currentPage: page,
            lastPage: page + 1, // Assuming there might be more pages
          ),
        );
      } else {
        // First page or fresh search
        emit(
          SearchSuccess(
            results,
            currentPage: page,
            lastPage: results.data!.length >= 10
                ? page + 1
                : page, // Assuming 10 items per page
          ),
        );
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> loadMoreResults() async {
    if (state is SearchSuccess) {
      final currentState = state as SearchSuccess;
      if (currentState.hasNextPage) {
        await performSearch(page: currentState.currentPage + 1);
      }
    }
  }
}
