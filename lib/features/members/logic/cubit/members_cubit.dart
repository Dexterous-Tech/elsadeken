import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:dio/dio.dart';

abstract class MembersListState<T> {}

class MembersListInitial<T> extends MembersListState<T> {}

class MembersListLoading<T> extends MembersListState<T> {}

class MembersListEmpty<T> extends MembersListState<T> {
  final String message;
  MembersListEmpty(this.message);
}

class MembersListLoaded<T> extends MembersListState<T> {
  final List<T> items;
  final bool hasNextPage;
  final int currentPage;
  final String? message;

  MembersListLoaded(
    this.items, {
    this.hasNextPage = false,
    this.currentPage = 1,
    this.message,
  });
}

class MembersListError<T> extends MembersListState<T> {
  final String message;
  MembersListError(this.message);
}

class MembersListCubit<T> extends Cubit<MembersListState<T>> {
  MembersListCubit(this.loader) : super(MembersListInitial<T>());

  /// loader function that should return either:
  /// 1. List directly, or
  /// 2. UsersResponseModel with data property
  final Future<dynamic> Function({int? page}) loader;

  Future<void> fetch({int? page}) async {
    try {
      if (page == 1 || page == null) {
        emit(MembersListLoading<T>());
      }
      // Don't emit loading state for pagination to keep existing data visible

      final response = await loader(page: page);

      List<T> items;
      String? message;
      bool hasNextPage = false;
      int currentPage = 1;

      // Handle both cases: direct data return or response object with data property
      if (response is List<T>) {
        // Loader returned data directly
        items = response;
        message = null;
      } else if (response != null && response.data != null) {
        // Loader returned response object with data property
        try {
          items = response.data as List<T>;
          message = response.message;

          // Extract pagination info from meta
          if (response.meta != null) {
            currentPage = response.meta!.currentPage ?? 1;
            final lastPage = response.meta!.lastPage ?? 1;
            hasNextPage = currentPage < lastPage;
          }
        } catch (castError) {
          // Handle case where data is not a List<T>
          items = [];
          message = 'خطأ في تنسيق البيانات';
        }
      } else {
        // No data
        items = [];
        message = null;
      }

      if (page == 1 || page == null) {
        // Initial load
        if (items.isEmpty) {
          emit(MembersListEmpty<T>(message ?? 'لا توجد نتائج'));
        } else {
          emit(MembersListLoaded<T>(
            items,
            hasNextPage: hasNextPage,
            currentPage: currentPage,
            message: message,
          ));
        }
      } else {
        // Pagination load - append to existing data
        final currentState = state;
        if (currentState is MembersListLoaded<T>) {
          final updatedItems = <T>[
            ...currentState.items,
            ...items,
          ];
          emit(MembersListLoaded<T>(
            updatedItems,
            hasNextPage: hasNextPage,
            currentPage: currentPage,
            message: message,
          ));
        }
      }
    } catch (e) {
      // Handle API errors gracefully
      String errorMessage;

      if (e is DioException) {
        final apiError = ApiErrorHandler.handle(e);
        errorMessage = apiError.displayMessage;

        // Provide more user-friendly messages for common server errors
        if (apiError.statusCode == 500) {
          errorMessage = 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً';
        } else if (apiError.statusCode == 404) {
          errorMessage = 'البيانات المطلوبة غير موجودة';
        } else if (apiError.statusCode == 401) {
          errorMessage = 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى';
        }
      } else {
        // For non-API errors, provide a generic message
        errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }

      emit(MembersListError<T>(errorMessage));
    }
  }

  void resetState() {
    emit(MembersListInitial<T>());
  }
}
