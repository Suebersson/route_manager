import 'package:flutter/material.dart';
import 'package:route_manager/pages/page1.dart';

import '../app_route.dart';
import '../shared_widgets/generic_button.dart';
import './page3.dart';

class Page2 extends StatelessWidget {
  const Page2({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
   //final argumnets = ModalRoute.of(context)!.settings.arguments as String;
   //final _routeName = ModalRoute.of(context)!.settings.name;
   //print(argumnets);
   //print(_routeName);

    //var controller = context.getPageDependency<Controller>();
    //print(controller.couter);
    //var arg = context.argument<int>();
    //print(arg);

    return Scaffold(
      backgroundColor: Colors.red,
      
      appBar: AppBar(
        title: const Text('Page2'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: GenericButton(
          name: 'Page3',
          onTap: (){
            //RouteManager.i.pushNamed(routeName: RouteName.page3);
            
            /*RouteManager.i.pushCustomized (
              builder: (_) => const Page3(),
              transitionType: TransitionType.fadeWithScaleCenterLeft,
              transitionDuration: const Duration(seconds: 3)
            );*/

            /*RouteManager.i.pushReplacementNamed(
              routeName: RouteName.page3,
              arguments: 'replace to page3'
            );*/
            RouteManager.i.popAndPushNamedCustomized(
              routeName: RouteName.page4,
              transitionType: TransitionType.fadeWithScaleCenterLeft,
              transitionDuration: const Duration(seconds: 3)
            );

          }, 
        ),
      ),
    );
  }
}

