import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
   ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController nameController =TextEditingController();

  TextEditingController emailController =TextEditingController();

  TextEditingController messageController =TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
int index =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          LanguageClass.isEnglish?  "Contact Us":"تواصل معنا",
          style: TextStyle(
              color: AppColors.white,
              fontSize: 34,
              fontFamily: "bold"),
        ),
      ),
      backgroundColor: Colors.black,
      body: Directionality(
        textDirection:
        LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: (){
                          setState(() {
                            index =0;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.primaryColor
                          ),
                          child: Text(
                            LanguageClass.isEnglish? "By Email":"بواسطة الايميل" ,
                            style: TextStyle(color: AppColors.white,fontSize: 20,fontFamily: "bold"),
                          ),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: (){
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.primaryColor
                          ),
                          child: Text(
                            LanguageClass.isEnglish? "By Mobile":"موبيل" ,
                            style: TextStyle(color: AppColors.white,fontSize: 20,fontFamily: "bold"),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
              index == 0?  SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        CustomizedField(
                          isPassword: false,
                          obscureText: false,
                          colorText: AppColors.greyLight,
                          controller:nameController,
                          validator: (validator){
                            if(validator == null || validator.isEmpty) {
                              return LanguageClass.isEnglish?"Enter your name":"ادخل اسمك ";
                            }
                            return null;
                          },
                          color:Colors.white.withOpacity(0.2),
                          labelText: LanguageClass.isEnglish?""
                              "name":"اسمك ",
                        ),
                        SizedBox(height: 15,),
                        CustomizedField(
                          isPassword: false,
                          obscureText: false,
                          colorText: AppColors.greyLight,
                          controller:emailController ,
                          validator: (validator){
                            if (validator == null || validator.isEmpty) {
                              return LanguageClass.isEnglish?"Enter Email":"ادخل الايميل";
                            }
                            String pattern =
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(validator)) {
                              return LanguageClass.isEnglish?"Your Email is invalid":"هذا الايميل غير صالح";
                            } else {
                              return null;
                            }
                          },
                          color:Colors.white.withOpacity(0.2),
                          labelText: LanguageClass.isEnglish?"Email":"ايميل",
                        ),
                        SizedBox(height: 15,),
                        CustomizedField(
                          isPassword: false,
                          obscureText: false,
                          colorText: AppColors.greyLight,
                          controller:messageController ,
                          validator: (validator){
                            if(validator == null || validator.isEmpty) {
                              return LanguageClass.isEnglish?"message":"رساله ";
                            }
                            return null;
                          },
                          color:Colors.white.withOpacity(0.2),
                          labelText:LanguageClass.isEnglish? "Message":"رساله",
                        ),
                        Spacer(),
                        BlocListener(
                          bloc:BlocProvider.of<MoreCubit>(context),
                          listener: (context,state){
                            if(state is LoadingSendMessage){
                              Constants.showLoadingDialog(context);
                            }if(state is LoadedSendMessage){
                              Constants.hideLoadingDialog(context);
                              Constants.showDefaultSnackBar(context: context, text: state.sendMessageModel.message!,color: Colors.green);
                            }if(state is ErrorSendMessage){
                              Constants.showDefaultSnackBar(context: context, text: state.msg);

                            }
                          },
                          child: InkWell(
                            onTap: (){
                              if(!formKey.currentState!.validate())return;
                              BlocProvider.of<MoreCubit>(context).sendMessage(
                                name: nameController.text,
                                email: emailController.text,
                                message: messageController.text,);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              child: Constants.customButton(text: LanguageClass.isEnglish?"Send":"ارسال",color: AppColors.primaryColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ):
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                decoration: BoxDecoration(
                  color:Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [

                InkWell(
                onTap: (){
                launch('tel:+01204444333');
                Navigator.pop(context);
                },
                  child: Row(
                    children: [
                      Text(
                      LanguageClass.isEnglish?"Call Us":"اتصل بنا",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontFamily: "bold",
                            color: Colors.white
                        ),),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                  ),
                    ],
                  ),
                ),

                  ],
                ),
              )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
