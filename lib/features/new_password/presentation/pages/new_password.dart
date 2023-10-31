import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/done_login/presentation/pages/done_login.dart';

class NewPasswordScreen extends StatelessWidget {
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController renewPassController = TextEditingController();

  NewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height:context.height * 0.15),
            SvgPicture.asset("assets/images/Swa Logo.svg"),
            SizedBox(height:context.height * 0.15),
            Container(
              height: context.height*0.22,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomizedField(
                      colorText: Colors.white,
                      isPassword: true,
                      obscureText: true,
                      color :AppColors.lightBink,
                      hintText: "Enter Password",
                      controller: newPassController,
                      validator: (value){
                        if(value == null ||value.isEmpty ){
                          return  "Enter New Password";
                        }
                        return null;
                      }
                    ),
                    CustomizedField(
                        colorText: Colors.white,
                        isPassword: true,
                        obscureText: true,
                        color :AppColors.lightBink,
                        hintText: "Re_Enter Password",
                        controller: renewPassController,
                        validator: (value){
                          if(value == null ||value.isEmpty ){
                            return  "Enter Re_password";
                          }
                          return null;
                        }
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context){return const DoneLoginScreen();}));
                  Navigator.pushNamed(context, Routes.doneLoginRoute);
                },
                child: Constants.customButton(text: "Done")
            ),
          ],
        ),
      ),
    );
  }
}
