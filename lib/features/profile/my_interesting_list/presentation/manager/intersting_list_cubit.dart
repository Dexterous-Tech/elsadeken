import 'package:elsadeken/features/profile/my_interesting_list/data/repo/interresting_list_repo.dart';
import 'package:elsadeken/features/profile/my_interesting_list/presentation/manager/interesting_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestingListCubit extends Cubit<InterestingListState> {
  InterestingListCubit(this.interrestingListRepo)
      : super(InterestingListStateInitial());

  final InterrestingListRepo interrestingListRepo;

  static InterestingListCubit get(context) => BlocProvider.of(context);

  void favUser() async {
    emit(InterestingListStateLoading());
    var response = await interrestingListRepo.interestingList();
    response.fold((error) {
      emit(InterestingListStateFailure(error.displayMessage));
    }, (favUserResponseModel) {
      emit(InterestingListStateSuccess(favUserResponseModel));
    });
  }
}
