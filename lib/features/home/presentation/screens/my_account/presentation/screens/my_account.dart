import 'package:flutter/material.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
            size: 34,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "My Account" ,
              style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily: "bold"),
            ),
            const SizedBox(height: 37,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 17,),
                customText("Personal Info"),
                const SizedBox(height: 17,),
                customText("Change Password"),

                const SizedBox(height: 17,),
                InkWell(
                    onTap: (){
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.signInRoute,
                            (Route<dynamic> route) => false,
                      );                    },
                    child: customText("Logout")),
              ],
            ),
            const Spacer(),


          ],

        ),
      ),
    );
  }


  Widget customText(text){
    return Text(
      text,
      style: const TextStyle
        (
          color: Colors.white,
          fontSize: 21,
          fontFamily:"bold"
      ),
    );
  }
}
