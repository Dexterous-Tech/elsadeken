import 'package:elsadeken/features/chat/data/models/api_response_model.dart';
import 'package:elsadeken/features/chat/data/models/country_model.dart';
import 'package:elsadeken/features/chat/data/models/nationality_model.dart';
import 'package:elsadeken/features/chat/domain/repositories/lists_repository.dart';
import 'package:elsadeken/core/shared/shared_preferences_helper.dart';
import 'package:elsadeken/core/shared/shared_preferences_key.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// States
abstract class ListsState extends Equatable {
  const ListsState();

  @override
  List<Object?> get props => [];
}

class ListsInitial extends ListsState {}

class ListsLoading extends ListsState {}

class ListsLoaded extends ListsState {
  final List<NationalityModel> nationalities;
  final List<CountryModel> countries;
  final bool fromCache;

  const ListsLoaded({
    required this.nationalities,
    required this.countries,
    this.fromCache = false,
  });

  @override
  List<Object?> get props => [nationalities, countries, fromCache];
}

class ListsError extends ListsState {
  final String message;

  const ListsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ListsCubit extends Cubit<ListsState> {
  final ListsRepository _repository;
  bool _isLoading = false;

  ListsCubit(this._repository) : super(ListsInitial());

  /// Load both nationalities and countries with smart caching
  Future<void> loadLists({bool forceRefresh = false}) async {
    // Prevent multiple simultaneous loads
    if (_isLoading && !forceRefresh) {
      return;
    }

    final stopwatch = Stopwatch()..start();
    emit(ListsLoading());
    _isLoading = true;

    try {
      // Load nationalities and countries in parallel
      final nationalitiesFuture = _repository.getNationalitiesWithGenderNames();
      final countriesFuture = _repository.getCountries();

      final results = await Future.wait([nationalitiesFuture, countriesFuture]);

      stopwatch.stop();

      final nationalitiesResponse =
          results[0] as ApiResponseModel<List<NationalityModel>>;
      final countriesResponse =
          results[1] as ApiResponseModel<List<CountryModel>>;

      if (nationalitiesResponse.isSuccess && countriesResponse.isSuccess) {
        final fromCache =
            nationalitiesResponse.message.contains('Cached') == true ||
            countriesResponse.message.contains('Cached') == true;

        emit(
          ListsLoaded(
            nationalities: nationalitiesResponse.data ?? [],
            countries: countriesResponse.data ?? [],
            fromCache: fromCache,
          ),
        );
      } else {
        final errorMessage = !nationalitiesResponse.isSuccess
            ? nationalitiesResponse.message
            : countriesResponse.message;
        emit(ListsError(errorMessage));
      }
    } catch (e) {
      stopwatch.stop();
      emit(
        const ListsError('Error loading lists'),
      ); // Using English as fallback since no context available
    } finally {
      _isLoading = false;
    }
  }

  /// Force refresh data by clearing cache and reloading
  Future<void> forceRefresh() async {
    await loadLists(forceRefresh: true);
  }

  /// Check if lists are already loaded
  bool get isLoaded => state is ListsLoaded;

  /// Get nationality name by ID
  String getNationalityName(int id) {
    if (state is ListsLoaded) {
      final currentState = state as ListsLoaded;
      final nationality = currentState.nationalities.firstWhere(
        (n) => n.id == id,
        orElse: () => NationalityModel(
          id: 0,
          name: {'male': 'Not Specified', 'female': 'Not Specified'},
        ),
      );
      return nationality
          .displayName; // Use displayName getter for backward compatibility
    }
    return 'Not Specified';
  }

  /// Get nationality name by ID with gender support
  String getNationalityNameForGender(int id, String gender) {
    if (state is ListsLoaded) {
      final currentState = state as ListsLoaded;
      final nationality = currentState.nationalities.firstWhere(
        (n) => n.id == id,
        orElse: () => NationalityModel(
          id: 0,
          name: {'male': 'Not Specified', 'female': 'Not Specified'},
        ),
      );
      return nationality.getNameForGender(gender);
    }
    return 'Not Specified';
  }

  /// Get nationality name by ID using current user's gender
  Future<String> getNationalityNameForCurrentUser(int id) async {
    if (state is ListsLoaded) {
      final currentState = state as ListsLoaded;
      final nationality = currentState.nationalities.firstWhere(
        (n) => n.id == id,
        orElse: () => NationalityModel(
          id: 0,
          name: {'male': 'Not Specified', 'female': 'Not Specified'},
        ),
      );

      // Get user's gender from SharedPreferences
      try {
        final gender = await SharedPreferencesHelper.getSecuredString(
          SharedPreferencesKey.gender,
        );
        return nationality.getNameForGender(gender);
      } catch (e) {
        return nationality.displayName; // Fallback to display name
      }
    }
    return 'Not Specified';
  }

  /// Get country name by ID
  String getCountryName(int id) {
    if (state is ListsLoaded) {
      final currentState = state as ListsLoaded;
      final country = currentState.countries.firstWhere(
        (c) => c.id == id,
        orElse: () => CountryModel(id: 0, name: 'Not Specified'),
      );
      return country.name;
    }
    return 'Not Specified';
  }

  /// Get current nationalities list
  List<NationalityModel> get nationalities {
    if (state is ListsLoaded) {
      return (state as ListsLoaded).nationalities;
    }
    return [];
  }

  /// Get current countries list
  List<CountryModel> get countries {
    if (state is ListsLoaded) {
      return (state as ListsLoaded).countries;
    }
    return [];
  }
}
