import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/ui/component/custom_Button.dart';
import 'package:swa/ui/component/custom_text_form_field.dart';
import 'package:swa/ui/registration/forget_password/pass_code.dart';

import '../../../core/utilts/My_Colors.dart';

class ForgetPasswordScreen extends StatelessWidget {
 TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height:sizeHeight * 0.15),
            SvgPicture.asset("assets/images/Swa Logo.svg"),
            SizedBox(height:sizeHeight * 0.09),

            Text(
              "Forget Password",
              style: TextStyle(
                  color: MyColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 21
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Please enter your retested email to send the custom Regain code via email",
              style: TextStyle(
                color: MyColors.white,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20,),
            CustomizedField(
                colorText: Colors.white,
                color :MyColors.lightBink,hintText: "Enter Email",
                controller: emailController,
                validator: (value){
              return "Enter Email";
                }
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return CreatePasscodeForm();
                    }));
              },
                child: CustomBottun(text: "Send Code"))

          ],
        ),
      ),
    );
  }
}
