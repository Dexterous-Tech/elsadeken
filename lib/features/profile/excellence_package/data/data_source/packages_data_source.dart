import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/excellence_package/data/models/assign_package_model.dart';
import 'package:elsadeken/features/profile/excellence_package/data/models/packages_model.dart';

class PackagesDataSource {
  final ApiServices _apiServices;

  PackagesDataSource(this._apiServices);

  Future<PackagesModel> getPackages() async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.getPackages,
      requiresAuth: true,
    );

    return PackagesModel.fromJson(response.data);
  }

    Future<AssignPackageToUserModel> assignPackageToUser(String id) async {
    final response = await _apiServices.get(
      endpoint: ApiConstants.assignPackageToUser(id),
      requiresAuth: true,
    );

    return AssignPackageToUserModel.fromJson(response.data);
  }
}
