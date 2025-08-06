// File: lib/domain/repositories/search_repository.dart

import '../../domain/entities/search_filter.dart';

abstract class SearchRepository {
  Future<List<String>> performSearch(SearchFilter filter);
  Future<List<String>> getNationalities();
  Future<List<String>> getCountries();
  Future<List<String>> getCities();
}

// Explain to how would u use this to perform search:

/*You're defining a **clean architecture interface** for a repository in Dart/Flutter. Here's an explanation of your code and example implementation.

---

## 🧠 What This Code Does

This abstract class defines a **contract** for any data source that handles searching, filtering, and getting location-related data like **nationalities, countries, cities**.

It is part of the **Domain Layer** in Clean Architecture.

---

## 🔍 Breakdown

```dart
abstract class SearchRepository {
  Future<List<String>> performSearch(SearchFilter filter);
  Future<List<String>> getNationalities();
  Future<List<String>> getCountries();
  Future<List<String>> getCities();
}
```

### ✨ Methods:

* `performSearch(SearchFilter filter)`
  → Uses the `SearchFilter` to return search results.

* `getNationalities()`
  → Returns a list of all available nationalities.

* `getCountries()`
  → Returns a list of all countries.

* `getCities()`
  → Returns a list of all cities.

### 🏗️ You would implement this in the **Data Layer** using an API, local DB, etc.

---

## ✅ Example Implementation (API-Based)

```dart
// File: lib/data/repositories/search_repository_impl.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../domain/repositories/search_repository.dart';
import '../../domain/search_filter.dart';

class SearchRepositoryImpl implements SearchRepository {
  final http.Client client;

  SearchRepositoryImpl(this.client);

  @override
  Future<List<String>> performSearch(SearchFilter filter) async {
    final response = await client.get(Uri.parse(
      'https://api.example.com/search?query=${filter.query}&country=${filter.country}',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['results']);
    } else {
      throw Exception('Failed to perform search');
    }
  }

  @override
  Future<List<String>> getNationalities() async {
    final response = await client.get(Uri.parse('https://api.example.com/nationalities'));
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    }
    throw Exception('Failed to load nationalities');
  }

  @override
  Future<List<String>> getCountries() async {
    final response = await client.get(Uri.parse('https://api.example.com/countries'));
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    }
    throw Exception('Failed to load countries');
  }

  @override
  Future<List<String>> getCities() async {
    final response = await client.get(Uri.parse('https://api.example.com/cities'));
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    }
    throw Exception('Failed to load cities');
  }
}
```

---

## 📦 Example SearchFilter

```dart
// File: lib/domain/search_filter.dart

class SearchFilter {
  final String query;
  final String? country;
  final String? nationality;
  final String? city;

  SearchFilter({
    required this.query,
    this.country,
    this.nationality,
    this.city,
  });
}
```

---

## 🧪 Usage in BLoC or UseCase

```dart
final searchRepo = SearchRepositoryImpl(http.Client());

final results = await searchRepo.performSearch(
  SearchFilter(query: "Ahmed", country: "Egypt"),
);
```

---

Would you like an example using **local JSON** or **mock data** instead of real API?
*/