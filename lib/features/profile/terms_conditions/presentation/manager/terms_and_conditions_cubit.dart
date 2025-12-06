import 'package:elsadeken/features/profile/terms_conditions/data/repo/terms_conditions_repo.dart';
import 'package:elsadeken/features/profile/terms_conditions/presentation/manager/terms_and_conditions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsCubit extends Cubit<TermsState> {
  TermsCubit(this.termsConditionsRepoInterface) : super(TermsInitial());

  final TermsConditionsRepoInterface termsConditionsRepoInterface;

  static TermsCubit get(context) => BlocProvider.of<TermsCubit>(context);

  void termsConditions() async {
    emit(TermsLoading());

    var response = await termsConditionsRepoInterface.termsConditions();

    response.fold((error) {
      emit(TermsError(error.displayMessage));
    }, (aboutUsResponseModel) {
      emit(TermsLoaded(aboutUsResponseModel));
    });
  }
}
