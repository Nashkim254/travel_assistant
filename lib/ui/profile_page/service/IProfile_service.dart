import 'package:jua_area/ui/home/model/product_model.dart';
import 'package:jua_area/ui/profile_page/model/user_model.dart';

abstract class IProfileService {
  Future<List<ProductModel>> getFoodList();
  Future<List<ProductModel>> getTravelList();

  Future<ProfileUserModel> getUserModel(String uid);
}
