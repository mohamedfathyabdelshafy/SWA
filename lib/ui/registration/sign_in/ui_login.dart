import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utilts/styles.dart';
import 'package:swa/ui/component/custom_Button.dart';
import 'package:swa/ui/component/custom_text_form_field.dart';
import 'package:swa/ui/home/home_screen.dart';
import 'package:swa/ui/registration/forget_password/forget_password.dart';
import 'package:swa/ui/registration/sign_up/sign_up.dart';

import '../../../core/utilts/My_Colors.dart';


class LoginScreen extends StatelessWidget {
  static String routeName = '';
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            SizedBox(height:sizeHeight * 0.15),
            Container(
              height: sizeHeight*0.22,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomizedField(
                        colorText: Colors.white,
                        obsecureText: false,
                        color :MyColors.lightBink,
                        hintText:"Enter Username or Phone Number",
                        controller: userNameController,
                        validator: (value){
                      if(value == null ||value.isEmpty ){
                        return  "Enter UserName";
                      }
                      return null;
                    }),
                    CustomizedField(
                        colorText: Colors.white,
                        ispassword: true,
                        obsecureText: true,
                        color :MyColors.lightBink,
                        hintText: "Enter Password",
                        controller: passwordController,
                        validator: (value){
                          if(value == null ||value.isEmpty ){
                            return  "Enter password";
                          }
                          return null;
                        }),
                  ],
                ),
              ),
            ),

            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return HomeScreen();
                  }));
                },
                child: CustomBottun(text: "Login")),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return ForgetPasswordScreen();
                  }));
            },
                child: Text(
                  "Forget Password ?",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    color: MyColors.white
                  ),
                )),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "Don’t have an account? ",
                  style: TextStyle(
                      color: MyColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return SignUp();
                      }));
                },
                    child:  Text(
                      "Sign UP",
                      style: TextStyle(
                          color: MyColors.yellow,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),)
              ],
            ),
            SizedBox(height: 50,)

          ],
        ),
      ),
    );
  }
}
