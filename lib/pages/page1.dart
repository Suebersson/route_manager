
import 'package:flutter/material.dart';
import 'package:dart_dev_utils/dart_dev_utils.dart';

import '../shared_widgets/generic_button.dart';
import '../app_route.dart';
import './page2.dart';
import '../main.dart';

class Page1 extends StatelessWidget {
  const Page1({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page1'),
      ),
      body: Center(
        child: GenericButton(
          name: 'Page2',
          onTap: () {
              
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => BindingPageBuilder(
                  builder: (_) => const Page2(), 
                  controller: () => Controller(),
                  sigleton: false,
                )
              )
            );
              
            /*Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => const Page2()
              )
            );*/
              
              
            /*context.routeManager.pushNamed(
              routeName: RouteName.page2,
              arguments: 'from context',
            );*/
              
            //print(context.routeManager.getRoutes.length);
            
            //var p = Theme.of(context).pageTransitionsTheme.builders.keys.first.name;
            //print(p);
            
            //print(RouteManager.routes.length);
            //print(RouteManager.routes.containsKey('/page1'));
              
            /*Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => const Page2()
              ),
            );*/
              
            /*Navigator.push(
              context, 
              CupertinoPageRoute(
                builder: (_) => const Page2()
              ),
            );*/
            
            /*RouteManager.i.pushNamed(
              routeName: RouteName.page2,
              arguments: 'zulu'  
            );*/
              
              
            /*Navigator.push(
              context, 
              NavigationTransition.flutterDefault(
                builder: (_) => const Page2(),
                flutterDefaultTransition: FlutterDefaultTransition.cupertino
              ),
            );*/
              
            /*Navigator.push(
              context, 
              NavigationTransition.customized(
                builder: (_) => const UnKnowRouteScreen(),
                routeName: 'CustomPageRoute',
                //transitionDuration: const Duration(seconds: 3),
                //reverseTransitionDuration: const Duration(seconds: 3),
              ),
            );*/
              
            /*RouteManager.i.pushNamedCustomized(
              routeName: RouteName.page2,
              arguments: 'form pushNamedCustomized',
              transitionDuration: const Duration(seconds: 3),
              reverseTransitionDuration: const Duration(seconds: 3),
            );*/
              
            
            /*Navigator.pushNamed(
              RouteManager.context, 
              RouteName.page2,
              arguments: 'zulu'
            );*/
              
              
            // RouteManager.i.pushCustomized(
            //   builder: (_) => const Page2(),
            //   settings: const RouteSettings(name: 'flutter'),
            //   transitionType: TransitionType.theme,
            //   transitionDuration: const Duration(seconds: 3),
            //   reverseTransitionDuration: const Duration(seconds: 3)
            // );

            // Navigator.push(
            //   context, 
            //   ScreenRouteBuilder(builder: (_) => const Page2())
            // );
              
          }, 
        ),
      ),
    );
  }
}

class Any extends Disposeble{
  int couter = 10;

  @override
  void dispose() {
   print('---- disposing ----'); 
    
  }

}

class Controller extends Disposeble{
  int couter = 10;

  @override
  void dispose() {
   print('---- disposing ----'); 
  }

}
