part of 'my_image_cubit.dart';

@immutable
sealed class MyImageState {}

final class MyImageInitial extends MyImageState {}

final class MyImageLoading extends MyImageState {}

final class MyImageImageSelected extends MyImageState {
  final File image;

  MyImageImageSelected(this.image);
}

final class MyImageFailure extends MyImageState {
  final String error;

  MyImageFailure(this.error);
}

final class MyImageSuccess extends MyImageState {
  final ProfileActionResponseModel profileActionResponseModel;

  MyImageSuccess(this.profileActionResponseModel);
}

final class UpdateImageSettingLoading extends MyImageState {}

final class UpdateImageSettingSuccess extends MyImageState {
  final ProfileActionResponseModel profileActionResponseModel;

  UpdateImageSettingSuccess(this.profileActionResponseModel);
}

final class UpdateImageSettingFailure extends MyImageState {
  final String error;

  UpdateImageSettingFailure(this.error);
}
