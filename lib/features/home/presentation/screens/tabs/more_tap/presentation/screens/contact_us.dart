import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController messageController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int index = 0;
  MoreRepo moreRepo = MoreRepo(sl());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  String mobile = '';
  void get() async {
    mobile = (await moreRepo.getmobile())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: sizeHeight * 0.08,
                  ),
                  Container(
                    alignment: LanguageClass.isEnglish
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Routes.isomra
                            ? AppColors.umragold
                            : AppColors.primaryColor,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      LanguageClass.isEnglish ? "Contact Us" : "تواصل معنا",
                      style: fontStyle(
                          color: AppColors.blackColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: FontFamily.bold),
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight * 0.01,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Routes.isomra
                                ? AppColors.umragold
                                : AppColors.primaryColor,
                          ),
                          child: Text(
                            LanguageClass.isEnglish
                                ? "By Email"
                                : "بواسطة الايميل",
                            style: fontStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                                fontFamily: FontFamily.bold),
                          ),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Routes.isomra
                                ? AppColors.umragold
                                : AppColors.primaryColor,
                          ),
                          child: Text(
                            LanguageClass.isEnglish ? "By Mobile" : "موبيل",
                            style: fontStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                                fontFamily: FontFamily.bold),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                  index == 0
                      ? SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                CustomizedField(
                                  colorText: Color(0xffD5D5D5),
                                  borderradias: 10,
                                  isPassword: false,
                                  obscureText: false,
                                  color: Color(0xffF7F8F9),
                                  hintText: LanguageClass.isEnglish ? "" : "",
                                  labelText: LanguageClass.isEnglish
                                      ? ""
                                          "name"
                                      : "اسمك ",
                                  controller: nameController,
                                  validator: (validator) {
                                    if (validator == null ||
                                        validator.isEmpty) {
                                      return LanguageClass.isEnglish
                                          ? "Enter your name"
                                          : "ادخل اسمك ";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                CustomizedField(
                                  colorText: Color(0xffD5D5D5),
                                  borderradias: 10,
                                  isPassword: false,
                                  obscureText: false,
                                  color: Color(0xffF7F8F9),
                                  hintText: LanguageClass.isEnglish
                                      ? "example@gmail.com"
                                      : "example@gmail.com",
                                  labelText: LanguageClass.isEnglish
                                      ? "Email"
                                      : "ايميل",
                                  controller: emailController,
                                  validator: (validator) {
                                    if (validator == null ||
                                        validator.isEmpty) {
                                      return LanguageClass.isEnglish
                                          ? "Enter Email"
                                          : "ادخل الايميل";
                                    }
                                    String pattern =
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                    RegExp regex = RegExp(pattern);
                                    if (!regex.hasMatch(validator)) {
                                      return LanguageClass.isEnglish
                                          ? "Your Email is invalid"
                                          : "هذا الايميل غير صالح";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    textAlignVertical: TextAlignVertical.top,
                                    controller: messageController,
                                    validator: (validator) {
                                      if (validator == null ||
                                          validator.isEmpty) {
                                        return LanguageClass.isEnglish
                                            ? "message"
                                            : "رساله ";
                                      }
                                      return null;
                                    },
                                    style: fontStyle(
                                        color: Color(0xffD5D5D5),
                                        fontSize: 18.sp,
                                        fontFamily: FontFamily.medium),
                                    cursorColor: Color(0xffA2A2A2),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      labelStyle: fontStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      hintText: LanguageClass.isEnglish
                                          ? "Type your message here ..."
                                          : "اكتب رسالتك هنا ...",
                                      errorStyle: fontStyle(
                                          fontSize: 10,
                                          fontFamily: FontFamily.medium,
                                          color: Colors.red),
                                      hintStyle: fontStyle(
                                        color: Color(0xffA2A2A2),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xffF7F8F9),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                BlocListener(
                                  bloc: BlocProvider.of<MoreCubit>(context),
                                  listener: (context, state) {
                                    if (state is LoadingSendMessage) {
                                      Constants.showLoadingDialog(context);
                                    }
                                    if (state is LoadedSendMessage) {
                                      Constants.hideLoadingDialog(context);
                                      Constants.showDefaultSnackBar(
                                          context: context,
                                          text: state.sendMessageModel.message!,
                                          color: Colors.green);
                                      setState(() {
                                        nameController.text = '';
                                        emailController.text = '';
                                        messageController.text = '';
                                      });
                                    }
                                    if (state is ErrorSendMessage) {
                                      Constants.showDefaultSnackBar(
                                          context: context, text: state.msg);
                                    }
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        print("object");
                                        BlocProvider.of<MoreCubit>(context)
                                            .sendMessage(
                                          name: nameController.text,
                                          email: emailController.text,
                                          message: messageController.text,
                                        );
                                      }
                                    },
                                    child: Constants.customButton(
                                        borderradias: 41,
                                        color: Routes.isomra
                                            ? AppColors.umragold
                                            : AppColors.primaryColor,
                                        text: LanguageClass.isEnglish
                                            ? "Send"
                                            : "ارسال"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          decoration: BoxDecoration(
                              color: Color(0xffF7F8F9),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  launch('tel:$mobile');
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      LanguageClass.isEnglish
                                          ? "Call Us"
                                          : "اتصل بنا",
                                      style: fontStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                          fontFamily: FontFamily.bold,
                                          color: Colors.black),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
