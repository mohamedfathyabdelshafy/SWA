import 'package:flutter/material.dart';

import '../../core/utilts/My_Colors.dart';

class CustomBottun extends StatelessWidget {
String text;
CustomBottun({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
      //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
      decoration:BoxDecoration(
          color: MyColors.darkRed,
          borderRadius: BorderRadius.circular(10)
      ) ,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22
          ),
        ),
      ),
    );
  }
}
