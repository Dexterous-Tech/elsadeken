import 'dart:developer';
import 'package:elsadeken/features/profile/interests_list/data/repo/fav_user_repo.dart';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_state.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavUserCubit extends Cubit<FavUserState> {
  FavUserCubit(this.favUserRepoInterface) : super(FavUserInitial());

  final FavUserRepoInterface favUserRepoInterface;

  static FavUserCubit get(context) => BlocProvider.of(context);

  Future<void> favUser({int? page}) async {
    try {
      if (page == 1 || page == null) {
        log('Loading initial fav users...');
        emit(FavUserLoading());
      } else {
        log('Loading more fav users for page $page...');
        // Don't emit loading state for pagination to keep existing data visible
      }

      var response = await favUserRepoInterface.favUsers(page: page);

      response.fold((error) {
        emit(FavUserFailure(error.displayMessage));
      }, (favUserResponseModel) {
        if (page == 1 || page == null) {
          log('Initial fav users loaded: ${favUserResponseModel.data?.length ?? 0} items');
          emit(FavUserSuccess(
            favUserResponseModel,
            hasNextPage: favUserResponseModel.meta?.currentPage != null &&
                favUserResponseModel.meta?.lastPage != null &&
                favUserResponseModel.meta!.currentPage! <
                    favUserResponseModel.meta!.lastPage!,
            currentPage: favUserResponseModel.meta?.currentPage ?? 1,
          ));
        } else {
          final currentState = state;
          if (currentState is FavUserSuccess) {
            final updatedData = <UsersDataModel>[
              ...currentState.favUserListModel.data ?? [],
              ...favUserResponseModel.data ?? []
            ];
            final updatedModel =
                favUserResponseModel.copyWith(data: updatedData);
            log('Pagination completed: Added ${favUserResponseModel.data?.length ?? 0} items, total: ${updatedData.length}');
            emit(FavUserSuccess(
              updatedModel,
              hasNextPage: favUserResponseModel.meta?.currentPage != null &&
                  favUserResponseModel.meta?.lastPage != null &&
                  favUserResponseModel.meta!.currentPage! <
                      favUserResponseModel.meta!.lastPage!,
              currentPage: favUserResponseModel.meta?.currentPage ?? 1,
            ));
          }
        }
      });
    } catch (e) {
      log('Unexpected error loading fav users: $e');
      emit(FavUserFailure('An unexpected error occurred: $e'));
    }
  }

  void resetState() {
    emit(FavUserInitial());
  }
}
