import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';

import '../../../../core/utils/styles.dart';

class DoneLoginScreen extends StatelessWidget {
  const DoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: context.height * 0.15),
            SvgPicture.asset(
              "assets/images/Swa Logo.svg",
              color:
                  Routes.isomra ? AppColors.umragold : AppColors.primaryColor,
            ),
            SizedBox(height: context.height * 0.08),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Routes.isomra
                      ? AppColors.umragold
                      : AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.white,
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              width: context.width * 0.8,
              height: context.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  LanguageClass.isEnglish
                      ? "Your password has been reset successfully!"
                      : "!تم إعادة ضبط كلمة المرور بنجاح",
                  style: fontStyle(
                      color: AppColors.blackColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.medium),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.signInRoute, (r) => false);
              },
              child: Constants.customButton(
                  text: LanguageClass.isEnglish ? "Login" : 'تسجيل الدخول',
                  color: Routes.isomra
                      ? AppColors.umragold
                      : AppColors.primaryColor),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
