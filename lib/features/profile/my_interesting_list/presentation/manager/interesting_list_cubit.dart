import 'dart:developer';
import 'package:elsadeken/features/profile/my_interesting_list/data/repo/interesting_list_repo.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/manager/interesting_list_state.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestingListCubit extends Cubit<InterestingListState> {
  InterestingListCubit(this.interestingListRepo)
      : super(InterestingListStateInitial());

  final InterestingListRepo interestingListRepo;

  static InterestingListCubit get(context) => BlocProvider.of(context);

  Future<void> favUser({int? page}) async {
    try {
      if (page == 1 || page == null) {
        log('Loading initial interesting users...');
        emit(InterestingListStateLoading());
      } else {
        log('Loading more interesting users for page $page...');
        // Don't emit loading state for pagination to keep existing data visible
      }

      var response = await interestingListRepo.interestingList(page: page);

      response.fold((error) {
        emit(InterestingListStateFailure(error.displayMessage));
      }, (favUserResponseModel) {
        if (page == 1 || page == null) {
          log('Initial interesting users loaded: ${favUserResponseModel.data?.length ?? 0} items');
          emit(InterestingListStateSuccess(
            favUserResponseModel,
            hasNextPage: favUserResponseModel.meta?.currentPage != null &&
                favUserResponseModel.meta?.lastPage != null &&
                favUserResponseModel.meta!.currentPage! <
                    favUserResponseModel.meta!.lastPage!,
            currentPage: favUserResponseModel.meta?.currentPage ?? 1,
          ));
        } else {
          final currentState = state;
          if (currentState is InterestingListStateSuccess) {
            final updatedData = <UsersDataModel>[
              ...currentState.favUserListModel.data ?? [],
              ...favUserResponseModel.data ?? []
            ];
            final updatedModel =
                favUserResponseModel.copyWith(data: updatedData);
            log('Pagination completed: Added ${favUserResponseModel.data?.length ?? 0} items, total: ${updatedData.length}');
            emit(InterestingListStateSuccess(
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
      log('Unexpected error loading interesting users: $e');
      emit(InterestingListStateFailure('An unexpected error occurred: $e'));
    }
  }

  void resetState() {
    emit(InterestingListStateInitial());
  }
}
