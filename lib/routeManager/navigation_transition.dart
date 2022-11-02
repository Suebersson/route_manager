part of 'route_manager.dart';

abstract class NavigationTransition {
  /// Função para transição de rotas que usa a navegação 
  /// padrão [MaterialPageRoute] ou [CupertinoPageRoute]
  static Route<T> flutterDefault<T>({
    required WidgetBuilder builder,
    String? title, /// Esse parâmetro se aplica apenas a [CupertinoPageRoute]
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
    TransitionType transitionType = _transitionType,
    Duration transitionDuration = _transitionDuration,
    Duration reverseTransitionDuration = _transitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }){

    return CustomPageRoute<T>(
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
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return CustomWidgetTransition(
          transitionType: transitionType, 
          animation: animation, 
          widget: child,
          curve: curve,
        );
      },
    );

  }

}

const TransitionType _transitionType = TransitionType.slideWithScaleRightToLeft;

enum FlutterDefaultTransition{
  material,
  cupertino,
}
