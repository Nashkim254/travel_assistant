import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jua_area/core/base/service/base_service.dart';
import 'package:jua_area/ui/post_page/model/PostModel.dart';
import 'package:jua_area/ui/post_page/service/IHttpSharePost.dart';
import 'package:jua_area/ui/profile_page/model/user_model.dart';

class HttpSharePost extends IHttpSharePost {
  @override
  Future postData(PostModel model, bool isFoodSelected) async {
    String postLocation = isFoodSelected ? "food" : "traveller";
    await http.post(
        Uri.parse("https://travelassistant-98d23.firebaseio.com/productID/$postLocation.json",),
        body: json.encode({
          'sharedDate': model.sharedDate,
          'sharedImg': {'0': model.sharedImg},
          'sharedLat': model.sharedLat,
          'sharedLong': model.sharedLong,
          'sharedText': model.sharedText,
          'sharedUserId': model.sharedUserId,
          'sharedUserName': model.sharedUserName,
          'sharedUserProfileImg': model.sharedUserProfileImg
        }));
  }

  @override
  Future<ProfileUserModel> getPostUserModel(String uid) async {
    return await httpGet(
        "https://travelassistant-98d23.firebaseio.com/userID/WnbONX7iZCNjHsijSTFu5fL30nI2.json",
        ProfileUserModel());
  }
}
