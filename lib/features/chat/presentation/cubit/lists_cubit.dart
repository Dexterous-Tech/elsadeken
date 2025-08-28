import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/nationality_model.dart';
import '../../data/models/country_model.dart';
import '../../data/models/api_response_model.dart';
import '../../data/repositories/lists_repository.dart';

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
      print('[ListsCubit] Already loading, skipping duplicate request');
      return;
    }

    print('[ListsCubit] Starting to load lists... (forceRefresh: $forceRefresh)');
    final stopwatch = Stopwatch()..start();
    emit(ListsLoading());
    _isLoading = true;
    
    try {
      print('[ListsCubit] Loading nationalities and countries in parallel...');
      
      // Load nationalities and countries in parallel
      final nationalitiesFuture = _repository.getNationalities();
      final countriesFuture = _repository.getCountries();
      
      final results = await Future.wait([nationalitiesFuture, countriesFuture]);
      
      stopwatch.stop();
      print('[ListsCubit] Both requests completed in ${stopwatch.elapsedMilliseconds}ms');
      
      final nationalitiesResponse = results[0] as ApiResponseModel<List<NationalityModel>>;
      final countriesResponse = results[1] as ApiResponseModel<List<CountryModel>>;
      
      print('[ListsCubit] Nationalities response: ${nationalitiesResponse.isSuccess} - ${nationalitiesResponse.message}');
      print('[ListsCubit] Countries response: ${countriesResponse.isSuccess} - ${countriesResponse.message}');
      print('[ListsCubit] Nationalities count: ${nationalitiesResponse.data?.length ?? 0}');
      print('[ListsCubit] Countries count: ${countriesResponse.data?.length ?? 0}');
      
      if (nationalitiesResponse.isSuccess && countriesResponse.isSuccess) {
        final fromCache = nationalitiesResponse.message?.contains('Cached') == true || 
                         countriesResponse.message?.contains('Cached') == true;
        
        print('[ListsCubit] Both successful, emitting ListsLoaded (fromCache: $fromCache)');
        print('[ListsCubit] Performance: ${fromCache ? 'CACHE HIT' : 'API CALL'} - ${stopwatch.elapsedMilliseconds}ms');
        
        emit(ListsLoaded(
          nationalities: nationalitiesResponse.data ?? [],
          countries: countriesResponse.data ?? [],
          fromCache: fromCache,
        ));
      } else {
        final errorMessage = !nationalitiesResponse.isSuccess 
            ? nationalitiesResponse.message 
            : countriesResponse.message;
        print('[ListsCubit] Error occurred: $errorMessage');
        emit(ListsError(errorMessage));
      }
    } catch (e) {
      stopwatch.stop();
      print('[ListsCubit] Exception occurred after ${stopwatch.elapsedMilliseconds}ms: $e');
      emit(const ListsError('حدث خطأ أثناء تحميل القوائم'));
    } finally {
      _isLoading = false;
    }
  }

  /// Force refresh data by clearing cache and reloading
  Future<void> forceRefresh() async {
    print('[ListsCubit] Force refreshing lists...');
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
        orElse: () => NationalityModel(id: 0, name: 'غير محدد'),
      );
      return nationality.name;
    }
    return 'غير محدد';
  }

  /// Get country name by ID
  String getCountryName(int id) {
    if (state is ListsLoaded) {
      final currentState = state as ListsLoaded;
      final country = currentState.countries.firstWhere(
        (c) => c.id == id,
        orElse: () => CountryModel(id: 0, name: 'غير محدد'),
      );
      return country.name;
    }
    return 'غير محدد';
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

