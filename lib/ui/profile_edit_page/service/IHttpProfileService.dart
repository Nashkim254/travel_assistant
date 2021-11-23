import 'package:jua_area/ui/profile_page/model/user_model.dart';

abstract class IHttpProfileService {
  Future updateUserInfo(ProfileUserModel model, String kullaniciId);
}
