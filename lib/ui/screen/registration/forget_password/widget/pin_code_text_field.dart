import 'package:flutter/material.dart';
import 'package:swa/core/utilts/My_Colors.dart';

class PinCodeTextField extends StatelessWidget {
  final TextEditingController controller;


  const PinCodeTextField({Key? key, required this.controller, })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 5.5,
      height: size.height * 0.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
      ),
      //color: MyColors.lightBink,
      child: Container(
        width: size.width / 5.5,
        height: size.height * 0.3,
        //color: MyColors.lightBink,
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
        ),
        child: TextFormField(

          obscureText: true,
          maxLength: 1,
          style: TextStyle(
              color: Colors.white,
              fontSize:30),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          controller: controller,
          decoration: InputDecoration(

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), // Apply borderRadius here
              borderSide: BorderSide(color: MyColors.lightBink), // Customize border style
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), // Apply borderRadius here
              borderSide: BorderSide(color: Colors.white), // Customize border style
            ),
              filled: true,
              fillColor: MyColors.lightBink,
              counterText: "",
              border: InputBorder.none
            // border: new OutlineInputBorder(
            // borderRadius: const BorderRadius.all(
            //   const Radius.circular(15.0),
            // ))
          ),


          validator: (value) {
            if (value!.isEmpty) {

              return null;
            }

            return null;
          },
        ),
      ),
    );
  }
}