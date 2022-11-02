
import 'package:flutter/material.dart';

import '../app_route.dart';
import '../shared_widgets/generic_button.dart';
import './page4.dart';

class Page3 extends StatelessWidget {
  const Page3({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page3'),
      ),
      body: Center(
        child: GenericButton(
          name: 'Page4',
          onTap: (){
            
            //RouteManager.i.pushNamed(routeName: RouteName.page4);
            
            /*RouteManager.i.pushNamedAndRemoveUntil(
              routeName: RouteName.page1, 
              predicate: ModalRoute.withName(RouteName.page1)
            );*/
            
            /*RouteManager.i.pushAndRemoveUntil(
              widget: const Page1(),
              transitionType: TransitionType.fadeWithScaleCenterRight,
              transitionDuration: const Duration(milliseconds: 3000),
              predicate: (Route<dynamic> predicate) => false,
            );*/

            RouteManager.i.pushReplacementNamedCustomized(
              routeName: '/page4',
              arguments: 'pushReplacementNamedCustomized',
              transitionType: TransitionType.fadeWithScaleCenterRight,
              transitionDuration: const Duration(milliseconds: 3000),
            );

            /*RouteManager.i.pushAndRemoveUntil(
              builder: (_) => const Page4(),
              predicate: (Route<dynamic> predicate) => false,
            );*/
            
            //RouteManager.i.popAndPushNamed(routeName: RouteName.page1);
          
          }, 
        ),
      ),
    );
  }
}

