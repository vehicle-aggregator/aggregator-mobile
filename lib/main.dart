import 'package:aggregator_mobile/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: "Aggregator",
          theme: themeData,
          routes: Routes.routes,
          initialRoute: Routes.splash,
        );
  }
}

final ThemeData themeData = new ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  primaryColorBrightness: Brightness.dark,
  accentColorBrightness: Brightness.light,
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    elevation: 0,
  ),
  buttonTheme: ButtonThemeData(
      height: 48.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
  ),
);



