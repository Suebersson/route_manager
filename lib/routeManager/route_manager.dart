import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart';
import 'package:dependency_manager/dependency_manager.dart' show dependencyDispose;

part 'widget_transition_animation.dart';
part 'route_observer_provider.dart';
part 'unknow_route_screen.dart';
part 'screen_route_builder.dart';
part 'navigation_transition.dart';
part 'bind_page_builder.dart';

/// Referências:
/// https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
/// https://api.flutter.dev/flutter/widgets/NavigatorState-class.html
/// https://api.flutter.dev/flutter/widgets/Navigator-class.html
/// https://api.flutter.dev/flutter/widgets/GlobalKey-class.html
/// https://api.flutter.dev/flutter/material/MaterialApp/onGenerateTitle.html
/// https://api.flutter.dev/flutter/widgets/NavigatorObserver-class.html
/// 
/* #######################  Responsabilidades dessa package ########################
  - Facilitar a navegação entre páginas sem contexto com rotas nomeadas ou não
  - Animações na transição de rotas 
  - Fornecer a GlobalKey<NavigatorState>
  - Fornecer o BuildContext(context) para possibilitar o uso(chamada) de outros métodos fora da árvore de Widgets. 
      EX: Podemos chamar uma AlertDialog ou showModalBottomSheet de qualquer 
          lugar do projeto ao usar a função "contextOverlay"
*/

extension ImplementNavigatorkey on Map<String, WidgetBuilder> {
  
  GlobalKey<NavigatorState> get navigatorKey {
    if(RouteManager.i._routes.isEmpty) RouteManager.i._routes.addAll(this);
    return RouteManager.i._navigatorKey;
  }

  RouteFactory get onUnknownRoute => RouteManager.i.onUnknownRoute;

}

extension ImplementFunction<T> on BuildContext {

  RouteManager get routeManager => RouteManager.i;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  NavigatorState get navigator => Navigator.of(this);
  ModalRoute<T>? get modalRoute => ModalRoute.of(this);
  // ignore: avoid_shadowing_type_parameters
  T? argument<T>() {
    var arg = modalRoute?.settings.arguments;
    if(arg == null){
      printLog(
        "O valor do argumento é nulo, verifique se o valor está sendo passado no parâmentro 'RouteSettings' para essa página",
        name: 'RouteManager',
      );  
      return null;
    } else {
      return arg as T;
    }
  }

}

class RouteManager {

  static final RouteManager _instance = RouteManager._();
  static RouteManager get i => _instance;
  RouteManager._();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final Map<String, WidgetBuilder> _routes = {};

  Map<String, WidgetBuilder> get getRoutes => {..._routes};
  List<String> get getRoutesName => _routes.keys.toList();
  List<WidgetBuilder> get getRoutesWidgetBuilder => _routes.values.toList();
  NavigatorState? get currentState => _navigatorKey.currentState;
  Widget? get currentWidget => _navigatorKey.currentWidget;
  BuildContext? get currentContext => _navigatorKey.currentContext;
  BuildContext get context => currentState!.context;
  BuildContext get contextOverlay => currentState!.overlay!.context;

  // ###################################  Métodos para rotas nomeadas  #################################
  
  /// Navegar para uma página nomeada
  Future<T?> pushNamed<T extends Object?>({
    required String routeName,
    Object? arguments,
    FlutterDefaultTransition? flutterDefaultTransition,
  }) async {

    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');

    if(flutterDefaultTransition == null) {
      return currentState?.pushNamed<T>(
        routeName, 
        arguments: arguments,
      );
    } else {
      return currentState?.push<T>(
        NavigationTransition.flutterDefault<T>(
          builder: _routes.containsKey(routeName)
            ? _routes[routeName]!
            : (_) => const UnKnowRouteScreen(),
          settings: RouteSettings(name: routeName, arguments: arguments),
          flutterDefaultTransition: flutterDefaultTransition,
        )
      );
    }

    // To get arguments --> final ObjectName _argumnets = ModalRoute.of(context)!.settings.arguments as ObjectName;
  }

  /// Navegar para uma página nomeada com transição personalizada
  Future<T?> pushNamedCustomized<T extends Object?>({
    required String routeName,
    Object? arguments,
    TransitionType transitionType = NavigationTransition.defaultTransitionType,
    Duration transitionDuration = NavigationTransition.defaultTransitionDuration,
    Duration reverseTransitionDuration = NavigationTransition.defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async {

    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');
    
    return currentState?.push<T>(
      NavigationTransition.customized<T>(
        builder: _routes.containsKey(routeName)
          ? _routes[routeName]!
          : (_) => const UnKnowRouteScreen(),
        settings: RouteSettings(name: routeName, arguments: arguments),
        transitionType: transitionType, 
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        curve: curve,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      )
    );

  }

  /// Substituir a página atual por outra pelo nome
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>({
    required String routeName,
    TO? result,
    Object? arguments,
    FlutterDefaultTransition? flutterDefaultTransition,
  }) async {

    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');

    if(flutterDefaultTransition == null) {
      return currentState?.pushReplacementNamed<T, TO>(
        routeName, 
        result: result, 
        arguments: arguments,
      );
    } else {
      return currentState?.pushReplacement<T, TO>(
        NavigationTransition.flutterDefault<T>(
          builder: _routes.containsKey(routeName)
            ? _routes[routeName]!
            : (_) => const UnKnowRouteScreen(),
          settings: RouteSettings(name: routeName, arguments: arguments),
          flutterDefaultTransition: flutterDefaultTransition,
        ),
        result: result,
      );
    }

  }

  /// Substituir uma página por outra
  Future<T?> pushReplacementNamedCustomized<T extends Object?, TO extends Object?>({
    required String routeName,
    TO? result,
    Object? arguments,
    TransitionType transitionType = NavigationTransition.defaultTransitionType,
    Duration transitionDuration = NavigationTransition.defaultTransitionDuration,
    Duration reverseTransitionDuration = NavigationTransition.defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async {

    return currentState?.pushReplacement<T, TO>(
      NavigationTransition.customized<T>(
        builder: _routes.containsKey(routeName)
          ? _routes[routeName]!
          : (_) => const UnKnowRouteScreen(),
        settings: RouteSettings(name: routeName, arguments: arguments),
        transitionType: transitionType, 
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        curve: curve,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      result: result,
    );

  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>({
    required String routeName, 
    required RoutePredicate predicate,
    Object? arguments,
    FlutterDefaultTransition? flutterDefaultTransition,
  }) async {

    //Ex RouteManager.pushNamedAndRemoveUntil(routeName: '/routeName', predicate: ModalRoute.withName('/routeName'));

    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');

    if(flutterDefaultTransition == null) {
      return currentState?.pushNamedAndRemoveUntil<T>(
        routeName, 
        predicate, 
        arguments: arguments,
      );
    } else {
      return currentState?.pushAndRemoveUntil<T>(
        NavigationTransition.flutterDefault<T>(
          builder: _routes.containsKey(routeName)
            ? _routes[routeName]!
            : (_) => const UnKnowRouteScreen(),
          settings: RouteSettings(name: routeName, arguments: arguments),
          flutterDefaultTransition: flutterDefaultTransition,
        ),
        predicate,
      );
    }
  }

  Future<T?> pushNamedAndRemoveUntilCustomized<T extends Object?>({
    required String routeName,
    required RoutePredicate predicate,
    Object? arguments,
    TransitionType transitionType = NavigationTransition.defaultTransitionType,
    Duration transitionDuration = NavigationTransition.defaultTransitionDuration,
    Duration reverseTransitionDuration = NavigationTransition.defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async {
    
    //Ex RouteManager.pushNamedAndRemoveUntilCustomized(widget: AnyPage(), predicate: (Route<dynamic> predicate) => false,);
    return currentState?.pushAndRemoveUntil<T>(
      NavigationTransition.customized<T>(
        builder: _routes.containsKey(routeName)
          ? _routes[routeName]!
          : (_) => const UnKnowRouteScreen(),
        settings: RouteSettings(name: routeName, arguments: arguments),
        transitionType: transitionType,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        curve: curve,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      predicate,
    );

  }

  /// Fechar(dispose) uma página e vá para outra
  /// tem o comportamento semelhante da função "pushReplacementNamed"
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>({
    required String routeName,
    TO? result,
    Object? arguments,
    FlutterDefaultTransition? flutterDefaultTransition,
  }) async {

    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');

    if(flutterDefaultTransition == null) {
      return currentState?.popAndPushNamed<T, TO>(
        routeName, 
        result: result, 
        arguments: arguments,
      );
    } else {
      currentState?.pop<TO>(result);
      return currentState?.push<T>(
        NavigationTransition.flutterDefault<T>(
          builder: _routes.containsKey(routeName)
            ? _routes[routeName]!
            : (_) => const UnKnowRouteScreen(),
          settings: RouteSettings(name: routeName, arguments: arguments),
          flutterDefaultTransition: flutterDefaultTransition,
        )
      );
    }
    
  }

  Future<T?> popAndPushNamedCustomized<T extends Object?, TO extends Object?>({
    required String routeName, 
    TO? result,
    Object? arguments,
    TransitionType transitionType = NavigationTransition.defaultTransitionType,
    Duration transitionDuration = NavigationTransition.defaultTransitionDuration,
    Duration reverseTransitionDuration = NavigationTransition.defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async {

    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');
    
    currentState?.pop<TO>(result);

    return currentState?.push<T>(
      NavigationTransition.customized<T>(
        builder: _routes.containsKey(routeName)
          ? _routes[routeName]!
          : (_) => const UnKnowRouteScreen(),
        settings: RouteSettings(name: routeName, arguments: arguments),
        transitionType: transitionType, 
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        curve: curve,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      )
    );

  }

  // ##############################  Métodos para rotas não nomeadas  ##################################
   
  /// Navegar para uma página não nomeada diretamente pelo Widget
  Future<T?> push<T extends Object?>({
    required WidgetBuilder builder,
    String? title, /// esse parâmetro se aplica apenas ao objeto [CupertinoPageRoute]
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    FlutterDefaultTransition flutterDefaultTransition = FlutterDefaultTransition.material,
  }) async {

    return await currentState?.push<T>(
      NavigationTransition.flutterDefault<T>(
        builder: builder,
        title: title,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        flutterDefaultTransition: flutterDefaultTransition,
      )
    );
    // To get arguments --> final ObjectName _argumnets = ModalRoute.of(context)!.settings.arguments as ObjectName;
  }

  //ir para uma página não configurada diretamente pelo Widget
  Future<T?> pushCustomized<T extends Object?>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    TransitionType transitionType = NavigationTransition.defaultTransitionType,
    Duration transitionDuration = NavigationTransition.defaultTransitionDuration,
    Duration reverseTransitionDuration = NavigationTransition.defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async {

    return await currentState?.push(
      NavigationTransition.customized<T>(
        builder: builder,
        settings: settings,
        transitionType: transitionType, 
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        curve: curve,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      )
    );
    // To get arguments --> final ObjectName _argumnets = ModalRoute.of(context)!.settings.arguments as ObjectName;
  }
  
  /// Substituir a página atual por outra
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>({
    required WidgetBuilder builder,
    String? title, /// esse parâmetro se aplica apenas ao objeto [CupertinoPageRoute]
    RouteSettings? settings,
    TO? result,
    bool maintainState = true,
    bool fullscreenDialog = false,
    FlutterDefaultTransition flutterDefaultTransition = FlutterDefaultTransition.material,
  }) async {

    return currentState?.pushReplacement<T, TO>(
      NavigationTransition.flutterDefault<T>(
        builder: builder,
        title: title,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        flutterDefaultTransition: flutterDefaultTransition,
      ),
      result: result
    );

  }

  /// Substituir uma página por outra
  Future<T?> pushReplacementCustomized<T extends Object?, TO extends Object?>({
    required WidgetBuilder builder,
    TO? result,
    RouteSettings? settings,
    TransitionType transitionType = NavigationTransition.defaultTransitionType,
    Duration transitionDuration = NavigationTransition.defaultTransitionDuration,
    Duration reverseTransitionDuration = NavigationTransition.defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async {

    return currentState?.pushReplacement<T, TO>(
      NavigationTransition.customized<T>(
        builder: builder,
        settings: settings,
        transitionType: transitionType, 
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        curve: curve,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      result: result
    );

  }

  Future<T?> pushAndRemoveUntil<T extends Object?>({
    required WidgetBuilder builder,
    required RoutePredicate predicate,
    String? title, /// esse parâmetro se aplica apenas ao objeto [CupertinoPageRoute]
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    FlutterDefaultTransition flutterDefaultTransition = FlutterDefaultTransition.material,
  }) async {

    //Ex RouteManager.pushAndRemoveUntil(widget: AnyPage(), predicate: (Route<dynamic> predicate) => false,);
    return currentState?.pushAndRemoveUntil<T>(
      NavigationTransition.flutterDefault<T>(
        builder: builder,
        title: title,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        flutterDefaultTransition: flutterDefaultTransition,
      ),
      predicate,
    );

  }

  Future<T?> pushAndRemoveUntilCustomized<T extends Object?>({
    required WidgetBuilder builder,
    required RoutePredicate predicate,
    RouteSettings? settings,
    TransitionType transitionType = NavigationTransition.defaultTransitionType,
    Duration transitionDuration = NavigationTransition.defaultTransitionDuration,
    Duration reverseTransitionDuration = NavigationTransition.defaultTransitionDuration,
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async {
    
    //Ex RouteManager.pushAndRemoveUntilCustomized(widget: AnyPage(), predicate: (Route<dynamic> predicate) => false,);
    return currentState?.pushAndRemoveUntil<T>(
      NavigationTransition.customized<T>(
        builder: builder,
        settings: settings,
        transitionType: transitionType,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        curve: curve,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      predicate,
    );

  }

  /// ---------------------------  Outros métodos  --------------------------------
  /// 
  void replace<T extends Object?> ({
    required Route<dynamic> oldRoute, 
    required Route<T> newRoute,
  }){
  
    currentState?.replace(
      oldRoute: oldRoute, 
      newRoute: newRoute,
    );
  
  }

  void finaleRoute({ required Route<dynamic> route }) {
    currentState?.finalizeRoute(route);
  }

  removeRoute({ required Route<dynamic> route }){
    currentState?.removeRoute(route);
  }

  void popUntil({ required RoutePredicate predicate }){
    // feche todas as rotas até chegar na rota especificada
    // Ex: RouteManager.popUntil(predicate: ModalRoute.withName('/home'));
    currentState?.popUntil(predicate);
  }

  // Verificar na rota do navegador se na página atual existe o widget WillPoPScope
  // para interceptar e perguntar qual ação o usuário deseja fazer 
  Future<bool> get maybePop {
    assert(currentState != null, "O objeto 'currentState' é null");
    return currentState!.maybePop();
  }

  //fechar(dispose) uma página
  void pop<T extends Object?>([T? result]) {
    currentState?.pop<T>(result);
  }

  bool get canPop {
    assert(currentState != null, "O objeto 'currentState' é null");
    return currentState!.canPop();
  }

  void dispose() => currentState?.dispose();

  RouteFactory get onUnknownRoute => (routeSettings) {
    return NavigationTransition.customized(
      builder: (_) => const UnKnowRouteScreen(),
      settings: routeSettings,
      transitionType: TransitionType.scaleCenter,
      curve: Curves.elasticInOut,
      transitionDuration: NavigationTransition.defaultTransitionDuration,
    );
  };

}
