import 'package:dio/dio.dart';

import 'api_constants.dart';
import 'api_error_handler.dart';
import 'dio_factory.dart';

class ApiServices {
  final Dio _dio;

  ApiServices.internal(this._dio);
  // static ApiServices get to get the instance of the ApiServices
  static Future<ApiServices> init() async {
    final dio = await DioFactory.getDio();
    return ApiServices.internal(dio);
  }

  /// Reusable POST method
  Future<Response<T>> post<T>({
    required String endpoint,
    required dynamic requestBody,
    bool requiresAuth = true,
  }) async {
    try {
      // Update headers based on whether authentication is required
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);
      // Perform the POST request
      final response = await _dio.post<T>(
        '${ApiConstants.baseUrl}$endpoint', // Combine base URL and endpoint
        data: requestBody,
      );

      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  /// Reusable GET method
  Future<Response<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);

      final response = await _dio.get<T>(
        '${ApiConstants.baseUrl}$endpoint', // Combine base URL and endpoint
        queryParameters: queryParameters,
      );

      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // Reusable PATCH method
  Future<Response<T>> patch<T>({
    required String endpoint,
    required dynamic requestBody,
    bool requiresAuth = true,
  }) async {
    try {
      // Update headers based on whether authentication is required
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);

      // Perform the PATCH request
      final response = await _dio.patch<T>(
        '${ApiConstants.baseUrl}$endpoint', // Combine base URL and endpoint
        data: requestBody,
      );

      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // Reusable PUT method
  Future<Response<T>> put<T>({
    required String endpoint,
    required dynamic requestBody,
    bool requiresAuth = true,
  }) async {
    try {
      // Update headers based on whether authentication is required
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);

      // Perform the PUT request
      final response = await _dio.put<T>(
        '${ApiConstants.baseUrl}$endpoint', // Combine base URL and endpoint
        data: requestBody,
      );

      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // Reusable DELETE method
  Future<Response<T>> delete<T>({
    required String endpoint,
    dynamic requestBody,
    bool requiresAuth = true,
  }) async {
    try {
      // Update headers based on whether authentication is required
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);

      // Perform the DELETE request
      final response = await _dio.delete<T>(
        '${ApiConstants.baseUrl}$endpoint', // Combine base URL and endpoint
        data: requestBody, // Optional request body for DELETE
      );

      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
