import 'package:flutter/material.dart';
import 'package:swa/core/utilts/My_Colors.dart';
import 'package:swa/core/utilts/styles.dart';
import 'package:swa/ui/component/custom_Button.dart';
import 'package:swa/ui/component/custom_text_form_field.dart';

class SignUp extends StatelessWidget {
TextEditingController nameController = TextEditingController();
TextEditingController MobileController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.white,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: MyColors.primaryColor,
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Sign Up",
               textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 35
              ),
              ),
              SizedBox(height:sizeHeight *0.03 ,),
              CustomizedField(
                colorText: MyColors.greyLight,
                controller: nameController,
                validator: (validator){
                  if(validator == null || validator.isEmpty)
                    return "Enter name";
                },
                color: MyColors.whitegrey,
                labelText: "Full Name",

              ),
              CustomizedField(
                colorText: MyColors.greyLight,
                controller:MobileController ,
                keyboardType: TextInputType.number,
                maxLength: 11,
                validator: (validator){
                  if(validator == null || validator.isEmpty)
                    return "Enter name";
                },
                color: MyColors.whitegrey,
                labelText: "Phone Number",

              ),
              CustomizedField(
                colorText: MyColors.greyLight,
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
                color: MyColors.whitegrey,
                labelText: "Email",

              ),
              CustomizedField(
                ispassword: true,
                 obsecureText: true,
                colorText: MyColors.greyLight,
                controller: passwordController,
                validator: (validator){
                  if(validator == null || validator.isEmpty)
                    return "Enter name";
                },
                color: MyColors.whitegrey,
                labelText: "Confirm Your Password(min 8 characters)",

              ),
              CustomizedField(
                ispassword: true,
                obsecureText: true,

                colorText: MyColors.greyLight,
                controller: rePasswordController,
                validator: (validator){
                  if(validator == null || validator.isEmpty)
                    return "Enter name";
                },
                color: MyColors.whitegrey,
                labelText: "Confirm Your Password",

              ),
              SizedBox(height: sizeHeight * 0.18,),
              InkWell(
                onTap: (){

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                  //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                  decoration:BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(10)
                  ) ,
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: MyColors.white,
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
      ),
    );
  }
}
