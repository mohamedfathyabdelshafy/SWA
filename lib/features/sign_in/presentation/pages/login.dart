import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';


class LoginScreen extends StatelessWidget {
  static String routeName = '';
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: context.height * 0.15),
            SvgPicture.asset("assets/images/Swa Logo.svg"),
            SizedBox(height: context.height * 0.15),
            SizedBox(
              height: context.height * 0.22,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomizedField(
                        colorText: Colors.white,
                        obscureText: false,
                        color : AppColors.lightBink,
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
                        isPassword: true,
                        obscureText: true,
                        color : AppColors.lightBink,
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
                  // Navigator.push(context, MaterialPageRoute(builder: (context){return const HomeScreen();}));
                  Navigator.pushNamed(context, Routes.homeRoute);
                },
                child: Constants.customButton(text: "Login")
            ),
            TextButton(
              onPressed: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context){return ForgetPasswordScreen();}));
                Navigator.pushNamed(context, Routes.forgotPasswordRoute);
              },
              child: Text(
                "Forget Password ?",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    color: AppColors.white
                ),
              )
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account? ",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextButton(
                  onPressed: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context){return SignUpScreen();}));
                    Navigator.pushNamed(context, Routes.signUpRoute);
                  },
                  child:  Text(
                    "Sign UP",
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}


