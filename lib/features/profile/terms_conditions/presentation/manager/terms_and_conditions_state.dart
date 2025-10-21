
import '../../../about_us/data/models/about_us_model.dart';

abstract class TermsState {}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsLoaded extends TermsState {
  final AboutUsResponseModel aboutUsResponseModel;
  TermsLoaded(this.aboutUsResponseModel);
}

class TermsError extends TermsState {
  final String message;
  TermsError(this.message);
}
