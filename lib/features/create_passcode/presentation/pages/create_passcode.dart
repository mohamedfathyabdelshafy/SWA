import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/create_passcode/presentation/widgets/pin_code_text_field.dart';

class CreatePasscodeFormScreen extends StatelessWidget {
  final TextEditingController passController = TextEditingController();
  // final TextEditingController pin2Controller = TextEditingController();
  // final TextEditingController pin3Controller = TextEditingController();
  // final TextEditingController pin4Controller = TextEditingController();

  CreatePasscodeFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Directionality(
        textDirection:
        LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Container(
          width: context.width,
          height: context.height,
          //alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(left: 30, right: 30,),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SizedBox( height: context.height * 0.12),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                SizedBox( height: context.height * 0.1),
                SvgPicture.asset("assets/images/Swa Logo.svg"),
                SizedBox( height: context.height * 0.10),
                Text(
                  textAlign: TextAlign.start,
                  LanguageClass.isEnglish?"Enter Code":"ادخل الكود",
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 20,
                    height: 2.000,
                    fontWeight: FontWeight.bold
                  ),
                ),
                CustomizedField(
                  isPassword: false,
                  obscureText: false,
                  colorText: AppColors.greyLight,
                  controller:passController ,
                  validator: (validator){
                    if (validator == null || validator.isEmpty) {
                      return LanguageClass.isEnglish ? " Enter the code" : "ادخل الكود";
                    }
                    return null;
                  },
                  color:Colors.white.withOpacity(0.2),
                  labelText: LanguageClass.isEnglish?"Code":"الكود",
                ),
                // pinRowInputs(context),
                InkWell(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context){return NewPasswordScreen();}));
                    Navigator.pushNamed(context, Routes.newPasswordRoute);
                  },
                  child: Constants.customButton(text:LanguageClass.isEnglish? "Create New Password":"انشاء كلمة مرور جديدة")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // pinRowInputs(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Expanded(
  //           child: PinCodeTextField(
  //             context: context,
  //             controller: pin1Controller,
  //           ),
  //         ),
  //         Expanded(
  //           child: PinCodeTextField(
  //             context: context,
  //             controller: pin2Controller,
  //           ),
  //         ),
  //         Expanded(
  //           child: PinCodeTextField(
  //             context: context,
  //             controller: pin3Controller,
  //           ),
  //         ),
  //         Expanded(
  //           child: PinCodeTextField(
  //             context: context,
  //             controller: pin4Controller,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}