import 'package:flutter/material.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/oranaa.agency_85935_A_Cinematic_Scene_from_2023_Romantic_Comedy_eec33b5c-a92f-40cb-ab53-e6c1790831cc.png",
            fit: BoxFit.fill,
            width: double.infinity,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.height * 0.05),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryColor,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.height * 0.01),
                      Text(
                        "Sign Up",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor('#F7F8F9'),
                          fontSize: 35
                        ),
                      ),
                      // SizedBox(height:context.height *0.03 ,),
                      SizedBox(height: context.height * 0.25,),
                      CustomizedField(
                        colorText: AppColors.greyLight,
                        controller: nameController,
                        validator: (validator){
                          if(validator == null || validator.isEmpty) {
                            return "Enter name";
                          }
                          return null;
                        },
                        color:Colors.black.withOpacity(0.5),
                        labelText: "Full Name",
                      ),
                      CustomizedField(
                        colorText: AppColors.greyLight,
                        controller: mobileController ,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        validator: (validator){
                          if(validator == null || validator.isEmpty) {
                            return "Enter name";
                          }
                          return null;
                        },
                        color:Colors.black.withOpacity(0.5),
                        labelText: "Phone Number",
                      ),
                      CustomizedField(
                        colorText: AppColors.greyLight,
                        controller: emailController,
                        validator: (validator){
                          if(validator == null || validator.isEmpty) {
                            return "Enter Email";
                          }
                          String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(validator)) {
                            return "your Email invalid";
                          } else {
                            return null;
                          }
                        },
                        color: Colors.black.withOpacity(0.5),
                        labelText: "Email",

                      ),
                      CustomizedField(
                        isPassword: true,
                        obscureText: true,
                        colorText: AppColors.greyLight,
                        controller: passwordController,
                        validator: (validator){
                          if(validator == null || validator.isEmpty) {
                            return "Enter name";
                          }
                          return null;
                        },
                        color:Colors.black.withOpacity(0.5),
                        labelText: "Confirm Your Password(min 8 characters)",

                      ),
                      CustomizedField(
                        isPassword: true,
                        obscureText: true,
                        colorText: AppColors.greyLight,
                        controller: rePasswordController,
                        validator: (validator){
                          if(validator == null || validator.isEmpty) {
                            return "Enter name";
                          }
                          return null;
                        },
                        color:Colors.black.withOpacity(0.5),
                        labelText: "Confirm Your Password",
                      ),
                      InkWell(
                        onTap: (){},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                          //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                          decoration:BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10)
                          ) ,
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
