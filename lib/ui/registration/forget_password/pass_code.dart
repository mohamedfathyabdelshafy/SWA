import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utilts/My_Colors.dart';
import 'package:swa/ui/component/custom_Button.dart';
import 'package:swa/ui/registration/forget_password/new_password.dart';
import 'package:swa/ui/registration/forget_password/widget/pin_code_text_field.dart';

class CreatePasscodeForm extends StatelessWidget {
  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Container(
        width: size.width,
        height: size.height,
        //alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 30, right: 30,),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height:size.height * 0.15),
            SvgPicture.asset("assets/images/Swa Logo.svg"),
            SizedBox(height:size.height * 0.10),
            Text(
              textAlign: TextAlign.start,
              "Enter Code",
              style: TextStyle(
                  color: MyColors.yellow,
                  fontSize: 20,
                  height: 2.000,
                  fontWeight: FontWeight.bold),
            ),
            //SizedBox(height: size.height * 0.06),
            pinRowInputs(),
            InkWell(
              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context){
                  return NewPasswordScreen();
                }));
              },
                child: CustomBottun(text: "Create New Password"))
          ],
        ),
      ),
    );
  }

  pinRowInputs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: PinCodeTextField(
              controller: pin1Controller,
            ),
          ),
          Expanded(
            child: PinCodeTextField(
              controller: pin2Controller,
            ),
          ),
          Expanded(
            child: PinCodeTextField(
              controller: pin3Controller,
            ),
          ),
          Expanded(
            child: PinCodeTextField(
              controller: pin4Controller,
            ),
          ),
        ],
      ),
    );
  }
}