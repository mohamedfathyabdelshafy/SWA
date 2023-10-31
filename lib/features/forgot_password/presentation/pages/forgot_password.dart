import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';


class ForgetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgetPasswordScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox( height: context.height * 0.15),
            SvgPicture.asset("assets/images/Swa Logo.svg"),
            SizedBox( height: context.height * 0.09),
            Text(
              "Forgot Password",
              style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 21
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              "Please enter your retested email to send the custom Regain code via email",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20,),
            CustomizedField(
              colorText: Colors.white,
              color :AppColors.lightBink,hintText: "Enter Email",
              controller: emailController,
              validator: (value){
                return "Enter Email";
              }
            ),
            InkWell(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context){return CreatePasscodeFormScreen();}));
                Navigator.pushNamed(context, Routes.createPasscode);
              },
              child: Constants.customButton(text: "Send Code")
            )
          ],
        ),
      ),
    );
  }
}
