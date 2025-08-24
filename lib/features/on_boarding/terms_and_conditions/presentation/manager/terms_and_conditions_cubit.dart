import 'package:bloc/bloc.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/data/models/terms_and_conditions_model.dart';
import 'package:elsadeken/features/on_boarding/terms_and_conditions/data/repo/terms_and_conditions_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'terms_and_conditions_state.dart';

class TermsAndConditionsCubit extends Cubit<TermsAndConditionsState> {
  TermsAndConditionsCubit(this.termsAndConditionsRepoInterface) : super(TermsAndConditionsInitial());

  final TermsAndConditionsRepoInterface termsAndConditionsRepoInterface;

  static TermsAndConditionsCubit get(context) => BlocProvider.of(context);

  void getTermsAndConditions() async {
    emit(TermsAndConditionsLoading());

    var response = await termsAndConditionsRepoInterface.getTermsAndConditions();

    response.fold((error) {
      emit(TermsAndConditionsFailure(error.displayMessage));
    }, (termsAndConditionsResponseModel) {
      emit(TermsAndConditionsSuccess(termsAndConditionsResponseModel));
    });
  }
}
