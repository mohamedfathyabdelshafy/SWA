import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/create_passcode/presentation/widgets/pin_code_text_field.dart';

class CreatePasscodeFormScreen extends StatelessWidget {
  final TextEditingController pin1Controller = TextEditingController();
  final TextEditingController pin2Controller = TextEditingController();
  final TextEditingController pin3Controller = TextEditingController();
  final TextEditingController pin4Controller = TextEditingController();

  CreatePasscodeFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        width: context.width,
        height: context.height,
        //alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 30, right: 30,),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox( height: context.height * 0.15),
            SvgPicture.asset("assets/images/Swa Logo.svg"),
            SizedBox( height: context.height * 0.10),
            Text(
              textAlign: TextAlign.start,
              "Enter Code",
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: 20,
                height: 2.000,
                fontWeight: FontWeight.bold
              ),
            ),
            pinRowInputs(context),
            InkWell(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context){return NewPasswordScreen();}));
                Navigator.pushNamed(context, Routes.newPasswordRoute);
              },
              child: Constants.customButton(text: "Create New Password")
            )
          ],
        ),
      ),
    );
  }

  pinRowInputs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: PinCodeTextField(
              context: context,
              controller: pin1Controller,
            ),
          ),
          Expanded(
            child: PinCodeTextField(
              context: context,
              controller: pin2Controller,
            ),
          ),
          Expanded(
            child: PinCodeTextField(
              context: context,
              controller: pin3Controller,
            ),
          ),
          Expanded(
            child: PinCodeTextField(
              context: context,
              controller: pin4Controller,
            ),
          ),
        ],
      ),
    );
  }
}