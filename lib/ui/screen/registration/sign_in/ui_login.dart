import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utilts/My_Colors.dart';
import 'package:swa/core/utilts/styles.dart';
import 'package:swa/data/repo/auth_repo/auth_repo.dart';
import 'package:swa/ui/component/custom_Button.dart';
import 'package:swa/ui/component/custom_text_form_field.dart';
import 'package:swa/ui/screen/home/home_screen.dart';
import 'package:swa/ui/screen/registration/PLOH/cubit/auth_cubit.dart';
import 'package:swa/ui/screen/registration/PLOH/cubit/auth_state.dart';
import 'package:swa/ui/screen/registration/forget_password/forget_password.dart';
import 'package:swa/ui/screen/registration/sign_in/widgets/daialog.dart';
import 'package:swa/ui/screen/registration/sign_up/sign_up.dart';


class LoginScreen extends StatefulWidget {
  static String routeName = '';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
   AuthCubit authCubit = AuthCubit();
@override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    return BlocListener(
      bloc: authCubit,
      listener: (context,state){
        if(state is AuthLoadingState){
          showLoading(context);
        }else if(state is AuthErrorState){
          showErrorDialog(context, state.message);
        }else if(state is AuthSuccessState){
          hideLoading(context);
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return HomeScreen();
          }));
          showDialog(context: context, builder: (context){
            return AlertDialog(
              content: Container(
                height: 50,
                width: 50,
                child: Text(
                  "success response"
                ),
              ),
            );
          });
        }

      },
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: SingleChildScrollView(
            child: Container(
              height: sizeHeight *1,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height:sizeHeight * 0.15),
                    SvgPicture.asset("assets/images/Swa Logo.svg"),
                    SizedBox(height:sizeHeight * 0.15),
                    Container(
                      height: sizeHeight*0.22,
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

                    InkWell(
                        onTap: (){
                          if( !formKey.currentState!.validate())return;
                          authCubit.login(userNameController.text, passwordController.text);

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
                                builder: (context) {
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
            ),
          ),
        ),
      ),
    );
  }
}
