import 'package:jua_area/ui/home/model/product_model.dart';
import 'package:jua_area/ui/profile_page/model/user_model.dart';

abstract class IHomeService {
  Future<List<ProductModel>> getFoodList();

  Future<List<ProductModel>> getTravelList();

  Future<ProfileUserModel> getUserData();
}
