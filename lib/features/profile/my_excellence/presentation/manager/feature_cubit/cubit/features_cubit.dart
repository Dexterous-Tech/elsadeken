import 'package:elsadeken/features/profile/my_excellence/presentation/manager/feature_cubit/cubit/features_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/profile/my_excellence/data/repo/features_repo.dart';
import 'package:elsadeken/features/profile/my_excellence/data/models/features_model.dart';

class FeaturesCubit extends Cubit<FeaturesState> {
  final FeaturesRepoInterface featuresRepoInterface;
  FeaturesCubit(this.featuresRepoInterface) : super(FeaturesInitial());

  void getFeatures() async {
    emit(GetFeaturesLoading());

    var response = await featuresRepoInterface.getFeatures();

    response.fold(
      (error) {
        emit(GetFeaturesFailure(error.displayMessage));
      },
      (featuresModel) {
        // if (featuresModel.data != null) {
        //   for (var feature in featuresModel.data!) {
        //
        //     // Ensure active is an integer
        //     int activeValue;
        //     if (feature.active is int) {
        //       activeValue = feature.active as int;
        //     } else if (feature.active is String) {
        //       activeValue = int.tryParse(feature.active as String) ?? 0;
        //     } else {
        //       activeValue = 0;
        //     }
        //
        //   }
        // }
        emit(GetFeaturesSuccess(featuresModel));
      },
    );
  }

  bool get isFeaturesLoaded => state is GetFeaturesSuccess;

  FeaturesModel? get currentFeatures {
    if (state is GetFeaturesSuccess) {
      return (state as GetFeaturesSuccess).featuresModel;
    }
    return null;
  }

  void refreshFeatures() {
    getFeatures();
  }
}
