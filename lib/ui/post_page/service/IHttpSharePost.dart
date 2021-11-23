import 'package:jua_area/ui/post_page/model/PostModel.dart';
import 'package:jua_area/ui/profile_page/model/user_model.dart';

abstract class IHttpSharePost {
  Future postData(PostModel model, bool isFoodSelected);

  Future<ProfileUserModel> getPostUserModel(String uid);
}
