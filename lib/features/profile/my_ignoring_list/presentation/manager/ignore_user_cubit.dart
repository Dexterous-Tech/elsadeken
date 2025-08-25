import 'dart:developer';
import 'package:elsadeken/features/profile/my_ignoring_list/data/repo/ignore_user_repo.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/manager/ignore_user_state.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IgnoreUserCubit extends Cubit<IgnoreUserState> {
  IgnoreUserCubit(this.ignoreUserRepoInterface) : super(IgnoreUserInitial());

  final IgnoreUserRepoInterface ignoreUserRepoInterface;

  static IgnoreUserCubit get(context) => BlocProvider.of(context);

  Future<void> ignoreUsers({int? page}) async {
    try {
      if (page == 1 || page == null) {
        log('Loading initial ignore users...');
        emit(IgnoreUserLoading());
      } else {
        log('Loading more ignore users for page $page...');
        // Don't emit loading state for pagination to keep existing data visible
      }

      var response = await ignoreUserRepoInterface.ignoreUsers(page: page);

      response.fold((error) {
        emit(IgnoreUserFailure(error.displayMessage));
      }, (ignoreUsersResponseModel) {
        if (page == 1 || page == null) {
          log('Initial ignore users loaded: ${ignoreUsersResponseModel.data?.length ?? 0} items');
          emit(IgnoreUserSuccess(
            ignoreUsersResponseModel,
            hasNextPage: ignoreUsersResponseModel.meta?.currentPage != null &&
                ignoreUsersResponseModel.meta?.lastPage != null &&
                ignoreUsersResponseModel.meta!.currentPage! <
                    ignoreUsersResponseModel.meta!.lastPage!,
            currentPage: ignoreUsersResponseModel.meta?.currentPage ?? 1,
          ));
        } else {
          final currentState = state;
          if (currentState is IgnoreUserSuccess) {
            final updatedData = <UsersDataModel>[
              ...currentState.ignoreUsersResponseModel.data ?? [],
              ...ignoreUsersResponseModel.data ?? []
            ];
            final updatedModel =
                ignoreUsersResponseModel.copyWith(data: updatedData);
            log('Pagination completed: Added ${ignoreUsersResponseModel.data?.length ?? 0} items, total: ${updatedData.length}');
            emit(IgnoreUserSuccess(
              updatedModel,
              hasNextPage: ignoreUsersResponseModel.meta?.currentPage != null &&
                  ignoreUsersResponseModel.meta?.lastPage != null &&
                  ignoreUsersResponseModel.meta!.currentPage! <
                      ignoreUsersResponseModel.meta!.lastPage!,
              currentPage: ignoreUsersResponseModel.meta?.currentPage ?? 1,
            ));
          }
        }
      });
    } catch (e) {
      log('Unexpected error loading ignore users: $e');
      emit(IgnoreUserFailure('An unexpected error occurred: $e'));
    }
  }

  void resetState() {
    emit(IgnoreUserInitial());
  }
}
