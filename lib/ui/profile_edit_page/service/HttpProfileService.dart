import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jua_area/ui/profile_edit_page/service/IHttpProfileService.dart';
import 'package:jua_area/ui/profile_page/model/user_model.dart';

class HttpProfileService extends IHttpProfileService {
  @override
  Future updateUserInfo(ProfileUserModel model, String kullaniciId) async {
    await http.put(
     Uri.parse("https://travelassistant-98d23-default-rtdb.firebaseio.com/userID/$kullaniciId.json"),  
        body: json.encode({
          'userBirth': model.userBirth,
          'userEmail': model.userEmail,
          'userGender': model.userGender,
          'userJob': model.userJob,
          'userName': model.userName,
          'userProfileImg': model.userProfileImg,
          'userPass': model.userPass
        }));
  }
}
