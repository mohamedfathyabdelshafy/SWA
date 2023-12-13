import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';

class DoneLoginScreen extends StatelessWidget {
  const DoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox( height: context.height * 0.15),
            SvgPicture.asset("assets/images/Swa Logo.svg"),
            SizedBox( height: context.height * 0.15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check,size: 40,color: AppColors.primaryColor,)
            ),
            SizedBox( height: context.height * 0.15),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, Routes.signInRoute);
              },
              child: Constants.customButton(text: "Login")
            ),
          ],
        ),
      ),
    );
  }
}
