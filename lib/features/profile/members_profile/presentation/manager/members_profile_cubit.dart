import 'package:elsadeken/features/profile/members_profile/data/repo/members_profile_repo.dart';
import 'package:elsadeken/features/profile/members_profile/data/model/members_profile_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'members_profile_state.dart';

class MembersProfileCubit extends Cubit<MembersProfileState> {
  MembersProfileCubit(this.membersProfileRepo)
      : super(MembersProfileStateInitial());

  final MembersProfileRepoInterface membersProfileRepo;
  int _selectedCountryId = 1;

  static MembersProfileCubit get(context) => BlocProvider.of(context);

  int get selectedCountryId => _selectedCountryId;

  Future<void> getMembersProfile({int? page, int? countryId}) async {
    try {
      // If country is changing, reset to page 1 and clear existing data
      if (countryId != null && countryId != _selectedCountryId) {

        _selectedCountryId = countryId;
        page = 1; // Force page 1 when country changes
      }

      if (page == 1 || page == null) {

        emit(MembersProfileStateLoading());
      } else {

        // Don't emit loading state for pagination to keep existing data visible
      }

      var response =
          await membersProfileRepo.getMembersProfile(_selectedCountryId);

      response.fold((error) {

        emit(MembersProfileStateFailure(error.displayMessage));
      }, (membersProfileResponseModel) {
        if (page == 1 || page == null) {

          emit(MembersProfileStateSuccess(
            membersProfileResponseModel,
            hasNextPage:
                membersProfileResponseModel.meta?.currentPage != null &&
                    membersProfileResponseModel.meta?.lastPage != null &&
                    membersProfileResponseModel.meta!.currentPage! <
                        membersProfileResponseModel.meta!.lastPage!,
            currentPage: membersProfileResponseModel.meta?.currentPage ?? 1,
          ));
        } else {
          final currentState = state;
          if (currentState is MembersProfileStateSuccess) {
            final updatedData = <MembersProfileDataModel>[
              ...currentState.membersProfileResponseModel.data ?? [],
              ...membersProfileResponseModel.data ?? []
            ];
            final updatedModel =
                membersProfileResponseModel.copyWith(data: updatedData);

            emit(MembersProfileStateSuccess(
              updatedModel,
              hasNextPage:
                  membersProfileResponseModel.meta?.currentPage != null &&
                      membersProfileResponseModel.meta?.lastPage != null &&
                      membersProfileResponseModel.meta!.currentPage! <
                          membersProfileResponseModel.meta!.lastPage!,
              currentPage: membersProfileResponseModel.meta?.currentPage ?? 1,
            ));
          }
        }
      });
    } catch (e) {

      emit(MembersProfileStateFailure('An unexpected error occurred: $e'));
    }
  }

  void resetState() {
    emit(MembersProfileStateInitial());
  }
}
