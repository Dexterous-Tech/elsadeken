import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/my_image/data/model/my_image_model.dart';
import 'package:elsadeken/features/profile/profile/data/models/logout_model.dart';

class MyImageDataSource {
  final ApiServices _apiServices;

  MyImageDataSource(this._apiServices);

  Future<ProfileActionResponseModel> updateImage(
      MyImageModel myImageModel) async {
    final response = await _apiServices.post(
      endpoint: ApiConstants.updateImage,
      requestBody: myImageModel.toFormData(),
    );

    return ProfileActionResponseModel.fromJson(response.data);
  }
}
