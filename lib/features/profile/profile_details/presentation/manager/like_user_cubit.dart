import 'package:elsadeken/features/profile/profile_details/data/repo/like_user_repo.dart';
import 'package:elsadeken/features/profile/profile_details/presentation/manager/like_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeUserCubit extends Cubit<LikeUserState> {
  LikeUserCubit(this.likeUserRepoInterface) : super(LikeUserInitial());

  final LikeUserRepoInterface likeUserRepoInterface;

  static LikeUserCubit get(context) => BlocProvider.of(context);

  void likeUser(String userId) async {
    emit(LikeUserLoading());

    var response = await likeUserRepoInterface.likeUser(userId);

    response.fold((error) {
      emit(LikeUserFailure(error.displayMessage));
    }, (likeUserResponseModel) {
      emit(LikeUserSuccess(likeUserResponseModel));
    });
  }
}
