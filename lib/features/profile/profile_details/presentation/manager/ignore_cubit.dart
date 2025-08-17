import 'package:elsadeken/features/profile/profile_details/data/repo/ignore_user_repo.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/ignore_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class IgnoreUserCubit extends Cubit<IgnoreUserState> {
  IgnoreUserCubit(this.ignoreUserRepo) : super(IgnoreUserInitial());

  final IgnoreUserRepo ignoreUserRepo;

  static IgnoreUserCubit get(context) => BlocProvider.of(context);

  void ignoreUser(String userId) async {
    emit(IgnoreUserLoading());

    var response = await ignoreUserRepo.ignoreUser(userId);

    response.fold((error) {
      emit(IgnoreUserFailure(error.displayMessage));
    }, (ignoreUserResponseModel) {
      emit(IgnoreUserSuccess(ignoreUserResponseModel));
    });
  }
}
