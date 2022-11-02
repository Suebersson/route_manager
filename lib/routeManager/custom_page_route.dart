part of 'route_manager.dart';

class CustomPageRoute<T> extends PageRoute<T> {
  /// Este objeto[CustomPageRoute] do tipo [Route] é uma versão 
  /// paralela(uma cópia) do objeto [PageRouteBuilder]
  /// 
  /// Ele foi criado e adaptado para receber o parâmetro [WidgetBuilder]
  ///  ao invés de uma [RoutePageBuilder]
  /// 
  /// os parâmertros [WidgetBuilder], [transitionsBuilder], [opaque], [barrierDismissible],
  /// [maintainState] e [fullscreenDialog] não podem ser nulos.
  CustomPageRoute({
    required this.builder,
    RouteSettings? settings,
    this.transitionsBuilder = _buildTransitionsFuction,
    this.transitionDuration = _transitionDuration,
    this.reverseTransitionDuration = _transitionDuration,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);
  
  /// Considerando que o projeto sempre está numa versão null-safety,
  /// não foi necéssario adicionar os [assert] para verificação ne valores nulos 

  final WidgetBuilder builder;
    
  final RouteTransitionsBuilder transitionsBuilder;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  final bool opaque; 

  @override
  final bool barrierDismissible;
  
  @override
  final bool maintainState;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation) {

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context)
    );

  }

  @override
  Widget buildTransitions(
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child) {

    return transitionsBuilder(context, animation, secondaryAnimation, child); 
  
  }

}

Widget _buildTransitionsFuction(
  BuildContext context, 
  Animation<double> animation, 
  Animation<double> secondaryAnimation, 
  Widget child) {

  return child;
  
}

const Duration _transitionDuration = Duration(milliseconds: 400);
