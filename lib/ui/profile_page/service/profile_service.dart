import 'package:jua_area/core/base/service/base_service.dart';
import 'package:jua_area/core/constants/constants.dart';
import 'package:jua_area/ui/home/model/product_model.dart';
import 'package:jua_area/ui/profile_page/model/user_model.dart';

import 'IProfile_service.dart';

class ProfileService extends IProfileService {
  @override
  Future<List<ProductModel>> getFoodList() async {
    return await httpGet<ProductModel>(
        "https://travelassistant-98d23-default-rtdb.firebaseio.com/productID/food.json",
        ProductModel());
  }

  @override
  Future<List<ProductModel>> getTravelList() async {
    return await httpGet<ProductModel>(
        "https://travelassistant-98d23-default-rtdb.firebaseio.com/productID/traveller.json",
        ProductModel());
  }

  @override
  Future<ProfileUserModel> getUserModel(String uid) async {
    return await httpGet(
        AppConstants.USER_URL + "/$uid.json", ProfileUserModel());
  }
}
