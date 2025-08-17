import 'package:elsadeken/features/profile/my_interesting_list/data/repo/interesting_list_repo.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/manager/interesting_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestingListCubit extends Cubit<InterestingListState> {
  InterestingListCubit(this.interestingListRepo)
      : super(InterestingListStateInitial());

  final InterestingListRepo interestingListRepo;

  static InterestingListCubit get(context) => BlocProvider.of(context);

  void favUser() async {
    emit(InterestingListStateLoading());
    var response = await interestingListRepo.interestingList();
    response.fold((error) {
      emit(InterestingListStateFailure(error.displayMessage));
    }, (favUserResponseModel) {
      emit(InterestingListStateSuccess(favUserResponseModel));
    });
  }
}
