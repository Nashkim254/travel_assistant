import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jua_area/models/services/application_bloc.dart';
import 'package:provider/provider.dart';
import 'package:jua_area/core/base/model/user_model.dart';
import 'package:jua_area/ui/auth/service/auth_service.dart';
import 'package:jua_area/ui/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ApplicationBloc(),
      ),
    ], child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: Splash(),
        debugShowCheckedModeBanner: false,
        title: 'Jua Area',
      ),
    );
  }
}
