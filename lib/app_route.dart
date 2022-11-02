library app_route;

import 'package:flutter/widgets.dart';

import './pages/page1.dart';
import './pages/page2.dart';
import './pages/page3.dart';
import './pages/page4.dart';


export './routeManager/route_manager.dart';
export './app_route.dart';

abstract class RouteName{
  static const String page1 = "/page1";
  static const String page2 = "/page2";
  static const String page3 = "/page3";
  static const String page4 = "/page4";
}

abstract class AppRoute {

  static final Map<String, WidgetBuilder> routes = {
    RouteName.page1: (_) => const Page1(),
    RouteName.page2: (_) => const Page2(),
    RouteName.page3: (_) => const Page3(),
    RouteName.page4: (_) => const Page4(),
  };

}











/*
abstract class AppRoutes {
  static RouteFactory? get onGenerateRoute => (routeSettings) {
    switch (routeSettings.name) {
      case RouteName.page1:
        return NavigationTransition.customized(
          widget: const Page1(), 
          routeName: RouteName.page1,
          transitionType: TransitionType.scaleCenter,
          transitionDuration: const Duration(milliseconds: 1000),

        );
      case RouteName.page2:
        return MaterialPageRoute(
          builder: (_) => const Page2(),
          settings: const RouteSettings(name: '/Page2', arguments: 'xuxa') 
        );

        /*return NavigationTransition.normalMaterial(
          widget: const Page2(), 
          routeName: RouteName.page2,
          //argument: 'xuxa'
        );*/
      case RouteName.page3:
        return NavigationTransition.customized(
          widget: const Page3(),
          routeName: RouteName.page3,
          transitionType: TransitionType.rotateCenter,
          curve: Curves.ease,
          transitionDuration: const Duration(milliseconds: 1000),
        );
      case RouteName.page4:
        return NavigationTransition.customized(
          widget: const Page4(), 
          routeName: RouteName.page4, 
          transitionType: TransitionType.slideWithScaleRightToLeft, 
          transitionDuration: const Duration(milliseconds: 1000),
        );
      default: return null; //throw "Nome da página não localizada";
    }
  };

}
*/
