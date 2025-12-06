// File: lib/presentation/chat_settings_cubit/search_state.dart
part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchFilterUpdated extends SearchState {
  final SearchFilter filter;

  const SearchFilterUpdated(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final UsersResponseModel results;
  final int currentPage;
  final int lastPage;
  final bool hasNextPage;

  const SearchSuccess(
    this.results, {
    this.currentPage = 1,
    this.lastPage = 1,
  }) : hasNextPage = currentPage < lastPage;

  @override
  List<Object?> get props => [results, currentPage, lastPage, hasNextPage];

  SearchSuccess copyWith({
    UsersResponseModel? results,
    int? currentPage,
    int? lastPage,
  }) {
    return SearchSuccess(
      results ?? this.results,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
    );
  }
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
