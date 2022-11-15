part of 'route_manager.dart';

abstract class NavigationTransition {
  /// Função para transição de rotas que usa a navegação 
  /// padrão [MaterialPageRoute] ou [CupertinoPageRoute]
  static Route<T> flutterDefault<T>({
    required WidgetBuilder builder,
    String? title, /// Esse parâmetro se aplica apenas ao [CupertinoPageRoute]
    String? routeName,
    Object? arguments,
    bool maintainState = true,
    bool fullscreenDialog = false,
    FlutterDefaultTransition flutterDefaultTransition = FlutterDefaultTransition.material,
  }) {

    switch (flutterDefaultTransition) {
      case FlutterDefaultTransition.cupertino:
        return CupertinoPageRoute<T>(
          builder: builder,
          title: title,
          settings: RouteSettings(name: routeName, arguments: arguments),
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
      default:
        return MaterialPageRoute<T>(
          builder: builder,
          settings: RouteSettings(name: routeName, arguments: arguments),
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
    }

  }

  static Route<T> customized<T>({
    required WidgetBuilder builder,
    String? routeName,
    Object? arguments,
    TransitionType transitionType = NavigationTransition.defaultTransitionType,
    Duration transitionDuration = defaultTransitionDuration,
    Duration reverseTransitionDuration = defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }){

    return ScreenRouteBuilder<T>(
      builder: builder,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      settings: RouteSettings(name: routeName, arguments: arguments),
      transitionsBuilder: (route, context, animation, secondaryAnimation, child) {
        return WidgetTransitionAnimation(
          transitionType: transitionType,
          animation: animation,
          widget: child,
          curve: curve,
          route: route,
        );
      },
    );

  }

  static const Duration defaultTransitionDuration = Duration(milliseconds: 500);

  static const TransitionType defaultTransitionType = TransitionType.slideWithScaleRightToLeft;

}


enum FlutterDefaultTransition{
  material,
  cupertino,
}
