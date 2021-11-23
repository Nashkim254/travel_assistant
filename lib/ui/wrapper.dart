import 'package:flutter/material.dart';
import 'package:jua_area/home_page.dart';
import 'package:provider/provider.dart';
import 'package:jua_area/core/base/model/user_model.dart';
//import 'package:jua_area/ui/home/view/home.dart';

import 'auth/view/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    // Return Home or Auth widget
    if (user == null) {
      return Auth();
    } else {
      return HomePage();
    }
  }
}
