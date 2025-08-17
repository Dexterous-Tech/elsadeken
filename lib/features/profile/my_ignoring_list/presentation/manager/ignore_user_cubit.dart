import 'package:elsadeken/features/profile/my_ignoring_list/data/repo/ignore_user_repo.dart';
import 'package:elsadeken/features/profile/my_ignoring_list/presentation/manager/ignore_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IgnoreUserCubit extends Cubit<IgnoreUserState> {
  IgnoreUserCubit(this.ignoreUserRepoInterface) : super(IgnoreUserInitial());

  final IgnoreUserRepoInterface ignoreUserRepoInterface;

  static IgnoreUserCubit get(context) => BlocProvider.of(context);

  void ignoreUsers() async {
    emit(IgnoreUserLoading());
    var response = await ignoreUserRepoInterface.ignoreUsers();
    response.fold((error) {
      emit(IgnoreUserFailure(error.displayMessage));
    }, (ignoreUsersResponseModel) {
      emit(IgnoreUserSuccess(ignoreUsersResponseModel));
    });
  }
}
