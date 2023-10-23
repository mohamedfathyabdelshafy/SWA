import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utilts/My_Colors.dart';
import 'package:swa/ui/component/custom_Button.dart';
import 'package:swa/ui/component/custom_text_form_field.dart';
import 'package:swa/ui/registration/forget_password/widget/done_login.dart';

class NewPasswordScreen extends StatelessWidget {
  TextEditingController newPassController = TextEditingController();
  TextEditingController renewPassController = TextEditingController();

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
                        ispassword: true,
                        obsecureText: true,
                        color :MyColors.lightBink,
                        hintText: "Enter Password",
                        controller: newPassController,
                        validator: (value){
                          if(value == null ||value.isEmpty ){
                            return  "Enter New Password";
                          }
                          return null;
                        }),
                    CustomizedField(
                        colorText: Colors.white,
                        ispassword: true,
                        obsecureText: true,
                        color :MyColors.lightBink,
                        hintText: "Re_Enter Password",
                        controller: renewPassController,
                        validator: (value){
                          if(value == null ||value.isEmpty ){
                            return  "Enter Re_password";
                          }
                          return null;
                        }),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (contex){
                      return DoneLogin();
                    }));
              },
                child: CustomBottun(text: "Done")),

          ],
        ),
      ),
    );
  }
}
