import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/profile/interests_list/data/models/users_response_model.dart';

class InterestingListDataSource {
  final ApiServices _apiServices;

  InterestingListDataSource(this._apiServices);

  Future<UsersResponseModel> interestingList() async {
    var response =
        await _apiServices.get(endpoint: ApiConstants.interestingList);

    return UsersResponseModel.fromJson(response.data);
  }
}
