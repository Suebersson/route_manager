
/*
import 'package:flutter/foundation.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart';

abstract class Dependencies<O> {

  final Map<O, Map<O Function(), O>> map = {};

  static Future<void> set(List<Dependency> dependencyList) async {
    
    await Future.forEach<Dependency>(dependencyList, (o) {


    });

  }

  static O get<O>() {
    assert(O != dynamic, 'Insira o tipo da dependência ou objeto no parâmentro generic O');

  }

  static Future<O> add<O>(O object) async{
    assert(O != dynamic, 'Insira o tipo da dependência ou objeto no parâmentro generic O');

  }

  static void remove<O>() {
    assert(O != dynamic, 'Insira o tipo da dependência ou objeto no parâmentro generic O');

  }

  static void removeAll() {

  }

  static void _dispose<O>(O object) {
    assert(O != dynamic, 'Insira o tipo da dependência ou objeto no parâmentro generic O');

  }

    
  /// Verifica se um objeto existe nas dependências
  static Future<bool> contains<O>() async{
    assert(O != dynamic, 'Insira o tipo da dependência ou objeto no parâmentro generic O');


  }

}


class Dependency {

}
*/




//  await DependencyInjector.setDependencies(dependencies: AppDependencies.dependencies);

/*

import 'package:flutter/widgets.dart';

import '../stateManager/disposable.dart';

abstract class DependencyInjector{

  static Future<void> setDependencies({@required List<AddDependency> dependencies}) async{
    assert(dependencies != null, 'insira alguma dependências');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(dependencies != null && dependencies.length > 0){
        print('----- Dependências injetadas: ${dependencies.length} -----');
        ///remover os parâmetros(objetos) de injeção da variável [dependencies]
        dependencies.clear();
      }
    });
  }

  static T getDependency<T> (){

    assert(T != dynamic, 'Insira o tipo de objeto');

    var objectList = _injectedDependence.where((e) => e.objectKey == '$T');

    if(objectList.isNotEmpty){
      _Dependency dependency = objectList.last;
      if(dependency.singleton == false){
        return dependency.objectClosure();
      }else if(dependency.instance == null){
        dependency.instance = dependency.objectClosure();
        return dependency.instance;
      }else{
        return dependency.instance;
      }
    }else{
      throw 'O objeto $T não foi adicionado a lista de dependências';
    }

  }

  static Future<T> addDependency<T>({@required Object object}) async{

    assert(object != null, "Insira o objeto de dependência");

    if(_injectedDependence.where((e) => e.objectKey == '${object.runtimeType}').isEmpty){

      _injectedDependence.add(
        _Dependency._(
          objectKey: '${object.runtimeType}',
          instance: object,
        )
      );

      return object;
    }else{
      print("----- Dependência já injetada e instânciada -----");
      return _injectedDependence.where((e) => e.objectKey == '${object.runtimeType}').last.instance;
    }

  }
  
  //remover uma unica dependência
  static void removeDependency<T>() {

    assert(T != dynamic, "Insira o tipo da dependência ou objeto");

    var dependency = _injectedDependence.where((e) => e.objectKey == '$T');

    if(dependency.isNotEmpty){

      if(dependency.last.instance != null){
        _disposeDependency(dependency.last.instance);
      }
      _injectedDependence.removeWhere((e) => e.objectKey == '$T');

      print('----- Dependência $T removida -----');

    }

  }

  //remover todas as instâncias injetadas no app
  static void removeAllDependencies(){

    print('----- Dependências removidas: ${_injectedDependence.length} -----');

    _injectedDependence.forEach((e) {
      if(e.instance != null) _disposeDependency(e.instance);
    });

    _injectedDependence.clear();

  }

  static void _disposeDependency(dynamic object){
    if(object is ChangeNotifier || object is Disposable){
      object?.dispose(); 
      print('----- The ${object.runtimeType} object has been disposed -----');
    }else if (object is Sink){
      object?.close();
      print('----- Object "Sink" disposed: ${object.runtimeType} -----');
    }else{
      try{
        object?.dispose(); 
        print('----- The ${object.runtimeType} object has been disposed -----');
      }catch(e){
        print('The Dependency has no disposable method');
      }
    }
  }
  
  //verifica se um objeto já foi instânciado
  static Future<bool> isDependency<T>() async{
    
    assert(T != dynamic, 'Insira o tipo da dependência ou objeto');

    return _injectedDependence.where((e) => e.objectKey ==  '$T').isNotEmpty ? true : false;

  }

}

final List<_Dependency> _injectedDependence = <_Dependency>[];

class AddDependency<T>{
  /// Todas as dependências seram injetadas por padrão como
  /// `lazy = true` e `singleton = true` para otimizar
  /// o desempenho do app e uso de memória
  /// Dessa forma o objeto de dependência será instânciado
  /// somente na primeira chamada de uso
  final T Function() objectClosure;
  final bool lazy;
  final bool singleton;
  AddDependency(this.objectClosure, {this.lazy = true, this.singleton = true}){
    assert(objectClosure != null, 'Insira o objeto de dependência');
    assert(lazy != null, 'Defina a propriedade "lazy" corretamente inserindo um valor true ou false');
    assert(singleton != null, 'Defina a propriedade "singleton" corretamente inserindo um valor true ou false');
    _injectedDependence.add(
      _Dependency(
        objectKey: objectClosure.runtimeType.toString().split(' => ')[1],
        lazy: lazy, 
        singleton: singleton, 
        objectClosure: objectClosure,
        /// Permitir injetar a dependência no modo `lazy = false` 
        /// somente se for uma instância `singleton = true`
        /// para evitar o armazenamento de uma instância a propriedade `instance`
        /// desnecessariamente 
        instance: lazy && singleton || !lazy && !singleton || lazy && !singleton  
          ? null 
          : objectClosure()// only => (!lazy && singleton)
      )
    );
  }
}

class _Dependency<T> {
  final String objectKey;
  final bool lazy;
  final bool singleton;
  final T Function() objectClosure;
  T instance;
  _Dependency({
    @required this.objectKey,
    @required this.lazy,
    @required this.singleton,
    @required this.objectClosure,
    this.instance
  }): assert(objectKey != null, 'Defina a propriedade objectKey'),
      assert(lazy != null, 'Defina a propriedade lazy'),
      assert(singleton != null, 'Defina a propriedade singleton'),
      assert(objectClosure != null, 'Defina a propriedade objectClosure');

  /// Construtor para adicionar uma dependêcia manualmente
  /// usando o método `addDependency`
  _Dependency._({
    @required this.objectKey,
    this.lazy = false,
    this.singleton = true,
    this.objectClosure,
    @required this.instance
  });
}

*/

