
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//part 'route_name.dart';

/// Referências
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
  - Fornecer animações básicas na transição de navegação entre páginas
*/

abstract class RouteManager {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get currentState => navigatorKey.currentState;
  static Widget? get currentWidget => navigatorKey.currentWidget;
  static BuildContext? get currentContext => navigatorKey.currentContext;
  static BuildContext get context => currentState!.context;
  static BuildContext get contextOverlay => currentState!.overlay!.context;

  //ir para uma página pelo nome configurado
  static Future<T?> pushNamed<T extends Object?>(
    {required String routeName,
    Object? arguments,}) async{
    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');
    return currentState?.pushNamed<T>(routeName, arguments: arguments);
  }

  //ir para uma página não configurada diretamente pelo Widget
  static Future<T?> pushMaterial<T extends Object?>(
    {required Widget widget,
    String? routeName, 
    Object? argument,
    bool maintainState = true,
    bool fullscreenDialog = false}) async{

    return await currentState?.push(
      NavigationTransition.normalMaterial<T>(
        widget: widget,
        routeName: routeName,
        argument: argument,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      )
    );
    // To get arguments --> final ObjectName _argumnets = ModalRoute.of(context)!.settings.arguments as ObjectName;
  }

    //ir para uma página não configurada diretamente pelo Widget
  static Future<T?> pushCupertino<T extends Object?>(
    {required Widget widget,
    String? title,
    String? routeName,
    Object? argument,
    bool maintainState = true,
    bool fullscreenDialog = false}) async{

    return await currentState?.push(
      NavigationTransition.normalCupertino<T>(
        widget: widget,
        title: title,
        routeName: routeName,
        argument: argument,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      )
    );
    // To get arguments --> final ObjectName _argumnets = ModalRoute.of(context)!.settings.arguments as ObjectName;
  }

  //ir para uma página não configurada diretamente pelo Widget
  static Future<T?> pushCustomized<T extends Object?>(
    {required Widget widget,
    String? routeName,
    Object? argument,
    TransitionType transitionType = TransitionType.slideWithScaleRightToLeft,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false}) async{

    return await currentState?.push(
      NavigationTransition.customized<T>(
        widget: widget,
        routeName: routeName,
        argument: argument,
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

  //substituir(fechar/dispose) uma página por outra pelo nome
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>({
    required String routeName,
    TO? result,
    Object? arguments,}) async {

    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');
    return currentState?.pushReplacementNamed<T, TO>(routeName, result: result, arguments: arguments);
  }

  
  //substituir(fechar/dispose) uma página por outra pelo widget
  static Future<T?> pushReplacementMaterial<T extends Object?, TO extends Object?>({
    required Widget widget,
    String? routeName, 
    Object? argument, 
    TO? result,
    bool maintainState = true,
    bool fullscreenDialog = false}) async{

    return currentState?.pushReplacement<T, TO>(
      NavigationTransition.normalMaterial<T>(
        widget: widget,
        routeName: routeName,
        argument: argument,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      result: result
    );

  }

    //substituir(fechar/dispose) uma página por outra pelo widget
  static Future<T?> pushReplacementCupertino<T extends Object?, TO extends Object?>({
    required Widget widget,
    String? title,
    String? routeName, 
    Object? argument, 
    TO? result,
    bool maintainState = true,
    bool fullscreenDialog = false}) async{

    return currentState?.pushReplacement<T, TO>(
      NavigationTransition.normalCupertino<T>(
        widget: widget,
        title: title,
        routeName: routeName,
        argument: argument,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      result: result
    );

  }

  //substituir(fechar/dispose) uma página por outra pelo widget
  static Future<T?> pushReplacementCustomized<T extends Object?, TO extends Object?>({
    required Widget widget,
    TO? result,
    String? routeName,
    Object? argument,
    TransitionType transitionType = TransitionType.slideWithScaleRightToLeft,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false}) async{

    return currentState?.pushReplacement<T, TO>(
      NavigationTransition.customized<T>(
        widget: widget,
        routeName: routeName,
        argument: argument,
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

  static void replace<T extends Object?> ({ required Route<dynamic> oldRoute, required Route<T> newRoute }){
    currentState?.replace(
      oldRoute: oldRoute, 
      newRoute: newRoute
    );
  }

  static void finaleRoute({ required Route<dynamic> route }) {
    currentState?.finalizeRoute(route);
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    {required String routeName, 
    required RoutePredicate predicate,
    Object? arguments,}) async{
    //Ex RouteManager.pushNamedAndRemoveUntil(routeName: '/routeName', predicate: ModalRoute.withName('/routeName'));

    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');
    return currentState?.pushNamedAndRemoveUntil<T>(routeName, predicate, arguments: arguments);
  }

  static Future<T?> pushAndRemoveUntilMaterial<T extends Object?>(
    {required Widget widget,
    required RoutePredicate predicate,
    String? routeName, 
    Object? argument, 
    bool maintainState = true,
    bool fullscreenDialog = false}) async{

    //Ex RouteManager.pushAndRemoveUntilMaterial(widget: AnyPage(), predicate: (Route<dynamic> predicate) => false,);
    return currentState?.pushAndRemoveUntil<T>(
      NavigationTransition.normalMaterial<T>(
        widget: widget,
        routeName: routeName,
        argument: argument,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      predicate,
    );

  }

  static Future<T?> pushAndRemoveUntilCupertino<T extends Object?>(
    {required Widget widget,
    required RoutePredicate predicate,
    String? title,
    String? routeName, 
    Object? argument, 
    bool maintainState = true,
    bool fullscreenDialog = false}) async{

    //Ex RouteManager.pushAndRemoveUntilCupertino(widget: AnyPage(), predicate: (Route<dynamic> predicate) => false,);
    return currentState?.pushAndRemoveUntil<T>(
      NavigationTransition.normalCupertino<T>(
        widget: widget,
        title: title,
        routeName: routeName,
        argument: argument,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
      ),
      predicate,
    );

  }

  static Future<T?> pushAndRemoveUntilCustomized<T extends Object?>(
    {required Widget widget,
    required RoutePredicate predicate,
    String? routeName,
    Object? argument,
    TransitionType transitionType = TransitionType.slideWithScaleRightToLeft,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false}) async{
    //Ex RouteManager.pushAndRemoveUntil(widget: AnyPage(), predicate: (Route<dynamic> predicate) => false,);
    return currentState?.pushAndRemoveUntil<T>(
      NavigationTransition.customized<T>(
        widget: widget,
        routeName: routeName,
        argument: argument,
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

  static removeRoute({ required Route<dynamic> route }){
    currentState?.removeRoute(route);
  }

  static void popUntil({required RoutePredicate predicate}){
    // feche todas as rotas até chegar na rota especificada
    // Ex: RouteManager.popUntil(predicate: ModalRoute.withName('/home'));
    currentState?.popUntil(predicate);
  }

  // Verificar na rota do navegador se na página atual existe o widget WillPoPScope
  // para interceptar e perguntar qual ação o usuário deseja fazer 
  static Future<bool> get maybePop {
    assert(currentState != null, "O objeto 'currentState' é null");
    return currentState!.maybePop();
  }

  //fechar(dispose) uma página
  static void pop<T extends Object?>([T? result]) {
    currentState?.pop<T>(result);
  }

  static bool get canPop {
    assert(currentState != null, "O objeto 'currentState' é null");
    return currentState!.canPop();
  }

  static void dispose() => currentState?.dispose();

  //fechar(dispose) uma página e ir para outra
  //tem o mesmo comportamento da função "pushReplacementNamed"
  static Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    {required String routeName, 
    TO? result,
    Object? arguments,}) async{
    assert(routeName.isNotEmpty, 'Insira o nome da rota para navegação');
    return currentState?.popAndPushNamed<T, TO>(routeName, result: result, arguments: arguments);
  }

  static RouteFactory? get onUnknownRoute => (routeSettings) {
    return NavigationTransition.customized(
      widget: const UnKnowRouteScreen(),
      routeName: routeSettings.name,
      transitionType: TransitionType.scaleCenter,
      curve: Curves.elasticInOut,
      transitionDuration: const Duration(milliseconds: 700),
    );
  };

}

abstract class NavigationTransition {

  static Route<T> normalMaterial<T>(
    {required Widget widget, 
    String? routeName, 
    Object? argument, 
    bool maintainState = true,
    bool fullscreenDialog = false}) { 
    
    return MaterialPageRoute<T>(
      builder: (context) => widget,
      settings: RouteSettings(name: routeName, arguments: argument),
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );

  }

  static Route<T> normalCupertino<T>(
    {required Widget widget,
    String? routeName,
    String? title,
    Object? argument,
    bool maintainState = true,
    bool fullscreenDialog = false}) {
    
    return CupertinoPageRoute<T>(
      builder: (context) => widget,
      title: title,
      settings: RouteSettings(name: routeName, arguments: argument),
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );

  }

  static Route<T> customized<T>(
    {required Widget widget,
    String? routeName,
    Object? argument,
    TransitionType transitionType = TransitionType.slideWithScaleRightToLeft,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false}){

    return PageRouteBuilder<T>(
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      settings: RouteSettings(name: routeName, arguments: argument), 
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _CustomAnimation(
          transitionType: transitionType, 
          animation: animation, 
          widget: child,
          curve: curve
        );
      },
    );

  }

}

@immutable
class _CustomAnimation extends StatelessWidget {
  final  TransitionType transitionType;
  final Animation<double> animation;
  final Widget widget;
  final Curve curve;

  const _CustomAnimation(
    {Key? key, 
    required this.transitionType, 
    required this.animation, 
    required this.widget, 
    required this.curve}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (transitionType) {
      case TransitionType.slideLeftToRight: 
      case TransitionType.slideRightToLeft: 
      case TransitionType.slideTopToBottom: 
      case TransitionType.slideBottomToTop:
        return SlideTransition(
          position: animation
            .drive(Tween(begin: _getOffset(transitionType), end: Offset.zero)
              .chain(CurveTween(curve: curve))),
          child: widget,
        );
      case TransitionType.scaleTopLeft: 
      case TransitionType.scaleTopCenter: 
      case TransitionType.scaleTopRight:
      case TransitionType.scaleBottomLeft: 
      case TransitionType.scaleBottomCenter: 
      case TransitionType.scaleBottomRight: 
      case TransitionType.scaleCenterLeft: 
      case TransitionType.scaleCenter: 
      case TransitionType.scaleCenterRight:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: widget,
          alignment: _getAlignment(transitionType),
        );
      case TransitionType.rotateTopLeft: 
      case TransitionType.rotateTopCenter: 
      case TransitionType.rotateTopRight:
      case TransitionType.rotateBottomLeft: 
      case TransitionType.rotateBottomCenter: 
      case TransitionType.rotateBottomRight: 
      case TransitionType.rotateCenterLeft: 
      case TransitionType.rotateCenter: 
      case TransitionType.rotateCenterRight:
        return RotationTransition(
          turns: Tween<double>(begin: 0.5, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: widget,
          alignment: _getAlignment(transitionType),
        );
      case TransitionType.sizeVertical: 
      case TransitionType.sizeHorizontal:
        return SizeTransition(
          sizeFactor: Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: widget,
          axis: transitionType == TransitionType.sizeHorizontal
            ? Axis.horizontal
            : Axis.vertical,
        );
      case TransitionType.slideWithScaleTopToBottom: 
      case TransitionType.slideWithScaleLeftToRight:
      case TransitionType.slideWithScaleRightToLeft: 
      case TransitionType.slideWithScaleBottomToTop:
        return SlideTransition(
          position: animation
            .drive(Tween(begin: _getOffset(transitionType), end: Offset.zero)
              .chain(CurveTween(curve: curve))),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
            child: widget,
          ),
        );
      case TransitionType.fade:
        return FadeTransition(
          child: widget,
          opacity: animation,
        );
      case TransitionType.fadeWithScaleTopLeft: 
      case TransitionType.fadeWithScaleTopCenter: 
      case TransitionType.fadeWithScaleTopRight:
      case TransitionType.fadeWithScaleBottomLeft: 
      case TransitionType.fadeWithScaleBottomCenter: 
      case TransitionType.fadeWithScaleBottomRight: 
      case TransitionType.fadeWithScaleCenterLeft: 
      case TransitionType.fadeWithScaleCenter:
      case TransitionType.fadeWithScaleCenterRight:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
            child: widget,
            alignment: _getAlignment(transitionType),
          ),
        );
      case TransitionType.slideWithFadeTopToBottom: 
      case TransitionType.slideWithFadeBottomToTop:
      case TransitionType.slideWithFadeLeftToRight: 
      case TransitionType.slideWithFadeRightToLeft:
        return SlideTransition(
          position: animation
            .drive(Tween(begin: _getOffset(transitionType), end: Offset.zero)
              .chain(CurveTween(curve: curve))),
          child: FadeTransition(
            child: widget,
            opacity: animation,
          ),
        );
      default: return const SizedBox();
    }
  }
}

Offset _getOffset(TransitionType transitionType){
  switch (transitionType) {
    case TransitionType.slideLeftToRight: 
    case TransitionType.slideWithScaleLeftToRight:
    case TransitionType.slideWithFadeLeftToRight: 
      return const Offset(-1.0, 0.0);
    case TransitionType.slideRightToLeft: 
    case TransitionType.slideWithScaleRightToLeft: 
    case TransitionType.slideWithFadeRightToLeft: 
      return const Offset(1.0, 0.0);
    case TransitionType.slideTopToBottom: 
    case TransitionType.slideWithScaleTopToBottom: 
    case TransitionType.slideWithFadeTopToBottom:
      return const Offset(0.0, -1.0);
    case TransitionType.slideBottomToTop: 
    case TransitionType.slideWithScaleBottomToTop: 
    case TransitionType.slideWithFadeBottomToTop: 
      return const Offset(0.0, 1.0);
    default: 
      return const Offset(1.0, 0.0);
  }
}

Alignment _getAlignment(TransitionType transitionType){
  switch (transitionType) {
    case TransitionType.scaleCenter:
    case TransitionType.rotateCenter:
    case TransitionType.fadeWithScaleCenter: 
      return Alignment.center;
    case TransitionType.scaleTopLeft: 
    case TransitionType.rotateTopLeft: 
    case TransitionType.fadeWithScaleTopLeft: 
      return Alignment.topLeft;
    case TransitionType.scaleTopCenter: 
    case TransitionType.rotateTopCenter: 
    case TransitionType.fadeWithScaleTopCenter: 
      return Alignment.topCenter;
    case TransitionType.scaleTopRight: 
    case TransitionType.rotateTopRight: 
    case TransitionType.fadeWithScaleTopRight: 
      return Alignment.topRight;
    case TransitionType.scaleBottomLeft: 
    case TransitionType.rotateBottomLeft: 
    case TransitionType.fadeWithScaleBottomLeft: 
      return Alignment.bottomLeft;
    case TransitionType.scaleBottomCenter: 
    case TransitionType.rotateBottomCenter: 
    case TransitionType.fadeWithScaleBottomCenter: 
      return Alignment.bottomCenter;
    case TransitionType.scaleBottomRight: 
    case TransitionType.rotateBottomRight: 
    case TransitionType.fadeWithScaleBottomRight:
    return Alignment.bottomRight;
    case TransitionType.scaleCenterLeft: 
    case TransitionType.rotateCenterLeft: 
    case TransitionType.fadeWithScaleCenterLeft: 
      return Alignment.centerLeft;
    case TransitionType.scaleCenterRight: 
    case TransitionType.rotateCenterRight: 
    case TransitionType.fadeWithScaleCenterRight: 
      return Alignment.centerRight;
    default: return Alignment.center;
  }
}

enum TransitionType{
  slideLeftToRight,
  slideRightToLeft,
  slideTopToBottom,
  slideBottomToTop,
  scaleCenter,
  scaleTopLeft,
  scaleTopCenter,
  scaleTopRight,
  scaleBottomLeft,
  scaleBottomCenter,
  scaleBottomRight,
  scaleCenterLeft,
  scaleCenterRight,
  rotateCenter,
  rotateTopLeft,
  rotateTopCenter,
  rotateTopRight,
  rotateBottomLeft,
  rotateBottomCenter,
  rotateBottomRight,
  rotateCenterLeft,
  rotateCenterRight,
  sizeVertical,
  sizeHorizontal,
  fade,
  fadeWithScaleCenter,
  fadeWithScaleTopLeft,
  fadeWithScaleTopCenter,
  fadeWithScaleTopRight,
  fadeWithScaleBottomLeft,
  fadeWithScaleBottomCenter,
  fadeWithScaleBottomRight,
  fadeWithScaleCenterLeft,
  fadeWithScaleCenterRight,
  slideWithFadeTopToBottom,
  slideWithFadeLeftToRight,
  slideWithFadeRightToLeft,
  slideWithFadeBottomToTop,
  slideWithScaleTopToBottom,
  slideWithScaleLeftToRight,
  slideWithScaleRightToLeft,
  slideWithScaleBottomToTop,
}

@immutable
class UnKnowRouteScreen extends StatelessWidget {
  const UnKnowRouteScreen({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.flip_to_back_rounded,//priority_high_sharp
              color: Colors.yellow,
              size: 150.0,
            ),
            const SizedBox(height: 15.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  icon: const Icon(
                    Icons.arrow_back, 
                    color: Colors.yellow,
                    size: 45.0,
                  ),
                ),
              const Text(
                'Página nomeada enexistente',
                style: TextStyle(
                  height: 2.3,
                  color: Colors.yellow,
                  fontSize: 20.0,
                ),  
              ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





/*

/// See also:
///
///  * [PageTransitionsTheme], which defines the default page transitions used
///    by the [MaterialRouteTransitionMixin.buildTransitions].
mixin MaterialRouteTransitionMixin<T> on PageRoute<T> {
  /// Builds the primary contents of the route.
  @protected
  Widget buildContent(BuildContext context);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return (nextRoute is MaterialRouteTransitionMixin && !nextRoute.fullscreenDialog)
      || (nextRoute is CupertinoRouteTransitionMixin && !nextRoute.fullscreenDialog);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = buildContent(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
          'The builder for route "${settings.name}" returned null.\n'
          'Route builders must never return null.',
        );
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }
}

*/






/*

        return _SizeTransitionCustomized(
          child: widget,
          curve: curve,
          axis: transitionType == TransitionType.sizeHorizontal
            ? Axis.horizontal
            : Axis.vertical,
        );

@immutable
class _SizeTransitionCustomized extends StatefulWidget {

  final Widget child;
  final Curve curve;
  final Axis axis;

  const _SizeTransitionCustomized({
    Key? key, 
    required this.curve, 
    required this.axis, 
    required this.child
  }) : super(key: key);

  @override
  State<_SizeTransitionCustomized> createState() => _SizeTransitionCustomizedState();
}

class _SizeTransitionCustomizedState extends State<_SizeTransitionCustomized> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      reverseDuration: const Duration(seconds: 3),
      debugLabel: 'SizeTransitionCustimized',
      vsync: this,
    );

    _animationController.forward();

    _animation =  Tween<double>(begin: 0.0, end: 1.0)
        .animate(_animationController);

    super.initState();

  }

  @override
  void dispose() {
    print('dispose');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axis: widget.axis,
      child: widget.child,
    );
  }
}
*/

















/*
//herdar essa class para criar as rotas
abstract class AppRouteSettings {

  //configurações fixas para chamadas de uma rota em primeiro plano
  Map<String, WidgetBuilder> get routes => null;
  //em segundo plano
  Route<dynamic> Function(RouteSettings) get onGenerateRoute => (RouteSettings routeSettings) => null;
  //terceiro plano
  Route<dynamic> Function(RouteSettings) get onUnknownRoute => (RouteSettings routeSettings) => null;

  List<Route<dynamic>> Function(String) get onGenerateInitialRoutes => (String string) => null;

  String Function(BuildContext) get onGenerateTitle => (BuildContext context) => null;
  
  List<NavigatorObserver> get navigatorObservers => null;

}
*/















/*
Axis _getAxis(TransitionType transitionType){
  switch (transitionType) {
    case TransitionType.sizeVertical:
      return Axis.vertical;
    case TransitionType.sizeHorizontal:
      return Axis.horizontal;
    default: 
      return Axis.vertical;
  }
}
*/












/*
  static Widget _animationForm(
    {required TransitionType transitionType, 
    required Animation<double> animation, 
    required Widget widget, 
    required Curve curve}){

    switch (transitionType) {
      case TransitionType.slideLeftToRight: 
      case TransitionType.slideRightToLeft: 
      case TransitionType.slideTopToBottom: 
      case TransitionType.slideBottomToTop:
        return SlideTransition(
          position: animation
            .drive(Tween(begin: _getOffset(transitionType), end: Offset.zero)
              .chain(CurveTween(curve: curve))),
          child: widget,
        );
      case TransitionType.scaleTopLeft: 
      case TransitionType.scaleTopCenter: 
      case TransitionType.scaleTopRight:
      case TransitionType.scaleBottomLeft: 
      case TransitionType.scaleBottomCenter: 
      case TransitionType.scaleBottomRight: 
      case TransitionType.scaleCenterLeft: 
      case TransitionType.scaleCenter: 
      case TransitionType.scaleCenterRight:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: widget,
          alignment: _getAlignment(transitionType),
        );
      case TransitionType.rotateTopLeft: 
      case TransitionType.rotateTopCenter: 
      case TransitionType.rotateTopRight:
      case TransitionType.rotateBottomLeft: 
      case TransitionType.rotateBottomCenter: 
      case TransitionType.rotateBottomRight: 
      case TransitionType.rotateCenterLeft: 
      case TransitionType.rotateCenter: 
      case TransitionType.rotateCenterRight:
        return RotationTransition(
          turns: Tween<double>(begin: 0.5, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: widget,
          alignment: _getAlignment(transitionType),
        );
      case TransitionType.sizeVertical: 
      case TransitionType.sizeHorizontal:
        return SizeTransition(
          sizeFactor: Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: widget,
          axis: _getAxis(transitionType),
        );
      case TransitionType.slideWithScaleTopToBottom: 
      case TransitionType.slideWithScaleLeftToRight:
      case TransitionType.slideWithScaleRightToLeft: 
      case TransitionType.slideWithScaleBottomToTop:
        return SlideTransition(
          position: animation
            .drive(Tween(begin: _getOffset(transitionType), end: Offset.zero)
              .chain(CurveTween(curve: curve))),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
            child: widget,
          ),
        );
      case TransitionType.fade:
        return FadeTransition(
          child: widget,
          opacity: animation,
        );
      case TransitionType.fadeWithScaleTopLeft: 
      case TransitionType.fadeWithScaleTopCenter: 
      case TransitionType.fadeWithScaleTopRight:
      case TransitionType.fadeWithScaleBottomLeft: 
      case TransitionType.fadeWithScaleBottomCenter: 
      case TransitionType.fadeWithScaleBottomRight: 
      case TransitionType.fadeWithScaleCenterLeft: 
      case TransitionType.fadeWithScaleCenter:
      case TransitionType.fadeWithScaleCenterRight:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
            child: widget,
            alignment: _getAlignment(transitionType),
          ),
        );
      case TransitionType.slideWithFadeTopToBottom: 
      case TransitionType.slideWithFadeBottomToTop:
      case TransitionType.slideWithFadeLeftToRight: 
      case TransitionType.slideWithFadeRightToLeft:
        return SlideTransition(
          position: animation
            .drive(Tween(begin: _getOffset(transitionType), end: Offset.zero)
              .chain(CurveTween(curve: curve))),
          child: FadeTransition(
            child: widget,
            opacity: animation,
          ),
        );
      default: return const SizedBox();
    }
  }
*/