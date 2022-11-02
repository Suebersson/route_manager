import 'package:flutter/material.dart';

import './app_route.dart';

void main() => runApp(const StartApp());

class StartApp extends StatelessWidget {
  const StartApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'teste route manager',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      initialRoute: RouteName.page1,
      navigatorKey: AppRoute.routes.navigatorKey,
      onUnknownRoute: AppRoute.routes.onUnknownRoute,
      routes: AppRoute.routes,
      /*builder: (context, child){
        return child!;
      }*/
    );
  }
}
