import 'package:elsadeken/features/profile/interests_list/data/repo/fav_user_repo.dart';
import 'package:elsadeken/features/profile/interests_list/presentation/manager/fav_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavUserCubit extends Cubit<FavUserState> {
  FavUserCubit(this.favUserRepoInterface) : super(FavUserInitial());

  final FavUserRepoInterface favUserRepoInterface;

  static FavUserCubit get(context) => BlocProvider.of(context);

  void favUser() async {
    emit(FavUserLoading());
    var response = await favUserRepoInterface.favUsers();
    response.fold((error) {
      emit(FavUserFailure(error.displayMessage));
    }, (favUserResponseModel) {
      emit(FavUserSuccess(favUserResponseModel));
    });
  }
}
