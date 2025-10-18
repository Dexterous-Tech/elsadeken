import 'package:elsadeken/features/auth/signup/data/models/general_info_models.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/profile_details_action_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/models/profile_details_response_model.dart';
import 'package:elsadeken/features/profile/profile_details/data/repo/profile_details_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/networking/api_constants.dart';

part 'profile_details_state.dart';

class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  ProfileDetailsCubit(this.profileDetailsRepoInterface)
      : super(ProfileDetailsInitial());

  final ProfileDetailsRepoInterface profileDetailsRepoInterface;

  void likeUser(int userId) async {
    emit(LikeUserLoading());

    var response = await profileDetailsRepoInterface.likeUser(userId);

    response.fold((error) {
      emit(LikeUserFailure(error.displayMessage));
    }, (likeUserResponseModel) {
      emit(LikeUserSuccess(likeUserResponseModel));
    });
  }

  void ignoreUser(int userId) async {
    emit(IgnoreUserLoading());

    var response = await profileDetailsRepoInterface.ignoreUser(userId);

    response.fold((error) {
      emit(IgnoreUserFailure(error.displayMessage));
    }, (ignoreUserResponseModel) {
      emit(IgnoreUserSuccess(ignoreUserResponseModel));
    });
  }

  void getProfileDetails(int userId) async {
    emit(GetProfileDetailsLoading());

    var response = await profileDetailsRepoInterface.getProfileDetails(userId);

    response.fold((error) {
      emit(GetProfileDetailsFailure(error.displayMessage));
    }, (profileDetailsResponseModel) {
      emit(GetProfileDetailsSuccess(profileDetailsResponseModel));
    });
  }

  void reportUser(int userId, int reasonId) async {
    emit(ReportUserLoading());

    var response =
        await profileDetailsRepoInterface.reportUser(userId, reasonId);

    response.fold((error) {
      emit(ReportUserFailure(error.displayMessage));
    }, (likeUserResponseModel) {
      emit(ReportUserSuccess(likeUserResponseModel));
    });
  }

  void shareUser(int userId) async {
    emit(ShareUserLoading());

    var response = await profileDetailsRepoInterface.shareUser(userId);

    response.fold((error) {
      emit(ShareUserFailure(error.displayMessage));
    }, (shareUserResponseModel) {
      emit(ShareUserSuccess(shareUserResponseModel));
    });
  }

  void getReportReasons() async {
    emit(ReportReasonLoading());

    var response = await profileDetailsRepoInterface
        .getGeneralInfo(ApiConstants.reportReasons);

    response.fold((error) {
      emit(ReportReasonFailure(error.displayMessage));
    }, (list) {
      emit(ReportReasonSuccess(list));
    });
  }
}
