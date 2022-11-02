import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  const GenericButton({Key? key, required this.onTap, required this.name}) : super(key: key);
  
  final void Function() onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor,
          margin: const EdgeInsets.only(top: 40),
          height: 50,
          width: 300,
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );
  }
}
