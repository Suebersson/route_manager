part of 'route_manager.dart';

extension ImplementPageDependecy on BuildContext {
  T getPageDependency<T>() {
    return BindPageBuilder.getPageDependency<T>(this);
  }
}

final Map<String, Object> _bindings = {};

@immutable
class BindPageBuilder<T> extends StatefulWidget {
  /// Widget responsável por acoplar uma instância de um [Object]
  /// para um outro [Widget] (página) filho usar como uma dependência (uma cotroller)
  ///
  /// O mesmo tem o total controle para instânciar os objetos [builder] e [controller]
  /// apenas quando serão usados

  const BindPageBuilder({
    Key? key,
    required this.builder,
    required this.controller,
    this.sigleton = true,
    this.lazy = true,
  }) : super(key: key);

  final WidgetBuilder builder;
  final T Function() controller;
  final bool sigleton;
  final bool lazy;

  static T getPageDependency<T>(BuildContext context) {
    /// instância de [_BindPageBuilderState]
    dynamic bindPageBuilderState = context.findAncestorStateOfType();

    ///
    /// chamar o método [controller] que não existe dentro da instância
    ///  para o dart chamar o método [noSuchMethod] e retornar o valor de [_controllerInstance
    //_TypeError (type 'Controller' is not a subtype of type 'Any')
    try {
      return bindPageBuilderState.controller();
    } on TypeError catch (e, s) {
      printLog(
        'O tipo de objeto genérico(objeto T) é diferente do tipo de objeto existente.', 
        name: 'BindPageBuilder', 
        stackTrace: s
      );
      rethrow;
    }
  }

  @override
  State<BindPageBuilder> createState() => _BindPageBuilderState();
}

class _BindPageBuilderState<T> extends State<BindPageBuilder> {
  dynamic _controllerInstance;
  late final String _dependenceName;
  late final bool _containsKey;

  dynamic _getInstance() {
    if (widget.sigleton) {
      /// Se sigleton == true, registre a instância na variável [_bindings]

      if (_containsKey) {
        if (!widget.lazy) {
          return _controllerInstance;
        } else {
          return _bindings[_dependenceName];
        }
      } else if (widget.lazy) {
        _controllerInstance = widget.controller();

        _bindings.putIfAbsent(
          _dependenceName,
          () => _controllerInstance,
        );

        return _controllerInstance;
      } else {
        _bindings.putIfAbsent(
          _dependenceName,
          () => _controllerInstance,
        );

        return _controllerInstance;
      }
    } else if (!widget.lazy) {
      return _controllerInstance;
    } else if (widget.lazy) {
      // Essa condição extra dará sempre a mesma instância do objeto
      // caso a instância seja solicitada mais uma vez, dessa forma
      // evita criar multliplas instâncias
      if (_controllerInstance != null) {
        return _controllerInstance;
      } else {
        return _controllerInstance = widget.controller();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _dependenceName = widget.controller.toString().split('=> ').last;
    _containsKey = _bindings.containsKey(_dependenceName);

    /// se lazy for false, crie ou carregue a instância
    if (!widget.lazy) {
      if (widget.sigleton && _containsKey) {
        _controllerInstance = _bindings[_dependenceName];
      } else {
        _controllerInstance = widget.controller();
      }
    }
  }

  @override
  void dispose() {
    if (!widget.sigleton) {
      try {
        if (_controllerInstance is Sink) {
          _controllerInstance?.close();
        } else {
          _controllerInstance?.dispose();
        }
      } catch (e) {
        printLog(
          '----- Método dispose não encontrado -----',
          name: 'BindPageBuilder',
        );
      }
    }

    super.dispose();
  }

  @override
  T noSuchMethod(Invocation invocation) => _getInstance();

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
