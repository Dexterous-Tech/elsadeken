import 'package:elsadeken/features/profile/my_excellence/data/models/features_model.dart';

class FeaturesState {}

class FeaturesInitial extends FeaturesState {}

class GetFeaturesLoading extends FeaturesState {}

class GetFeaturesFailure extends FeaturesState {
  final String error;

  GetFeaturesFailure(this.error);
}

class GetFeaturesSuccess extends FeaturesState {
  final FeaturesModel featuresModel;

  GetFeaturesSuccess(this.featuresModel);
}
