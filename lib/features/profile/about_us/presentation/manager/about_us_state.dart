part of 'about_us_cubit.dart';

@immutable
sealed class AboutUsState {}

final class AboutUsInitial extends AboutUsState {}

final class AboutUsLoading extends AboutUsState {}

final class AboutUsFailure extends AboutUsState {
  final String error;

  AboutUsFailure(this.error);
}

final class AboutUsSuccess extends AboutUsState {
  final AboutUsResponseModel aboutUsResponseModel;

  AboutUsSuccess(this.aboutUsResponseModel);
}
