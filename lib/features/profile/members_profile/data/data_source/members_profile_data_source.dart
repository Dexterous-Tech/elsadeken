import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';

import '../model/members_profile_response_model.dart';

class MembersProfileDataSource {
  final ApiServices _apiServices;

  MembersProfileDataSource(this._apiServices);

  Future<MembersProfileResponseModel> getMembersProfile(int countryId) async {

    var response = await _apiServices.get(
        endpoint: ApiConstants.getMembersProfile,
        queryParameters: {'country_id': countryId});

    return MembersProfileResponseModel.fromJson(response.data);
  }
}
