import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../di/injection_container.dart';
import '../shared/shared_preferences_helper.dart';
import '../shared/shared_preferences_key.dart';
import 'api_services.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? _dio;

  static Future<Dio> getDio() async {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio()
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      await addDioHeaders(includeAuth: false);
      addDioInterceptor();
    }

    return _dio!;
  }

  static Future<void> addDioHeaders({bool includeAuth = true}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (includeAuth) {
      final String token = await SharedPreferencesHelper.getSecuredString(
        SharedPreferencesKey.apiTokenKey,
      );
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        headers.remove('Authorization'); // Ensure no stale token is used
      }
    } else {
      headers.remove('Authorization'); // Explicitly remove auth header
    }
    _dio?.options.headers = headers;
    log("🔑 Headers before request: ${_dio?.options.headers}");
  }

  static Future<void> setTokenIntoHeaderAfterLogin(String token) async {
    _dio?.options.headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    // Force recreation of Dio instance
    log("🔑 Headers set after login: ${_dio?.options.headers}");
  }

  /*
  * to stop det it of dio and api services
  * then restart again
  * use to call in logout
  * */
  static Future<void> resetDio() async {
    // Optional: Dispose Dio if needed
    if (_dio != null) {
      _dio!.options.headers.clear();
      _dio!.close(force: true); // Fully close the Dio instance
      _dio = null;
    }

    // Unregister Dio and related services if already registered
    if (sl.isRegistered<Dio>()) {
      sl.unregister<Dio>();
    }

    // Unregister any dependent services if needed
    if (sl.isRegistered<ApiServices>()) {
      sl.unregister<ApiServices>();
    }

    // Re-register everything
    await initializeDependencies(); // Assuming this sets up Dio, ApiService, etc.

    // Wait for everything to be ready again
    await sl.allReady();
  }

  static void addDioInterceptor() {
    _dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        request: true,
        error: true,
      ),
    );
  }
}
