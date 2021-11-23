import 'package:jua_area/ui/profile_page/model/user_model.dart';

abstract class IRegisterService {
  Future registerUserSaveData(ProfileUserModel model, String kullaniciId);
}
