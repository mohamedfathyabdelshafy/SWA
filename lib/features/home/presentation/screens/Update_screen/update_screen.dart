import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LanguageClass.isEnglish
                      ? 'Update App is Required'
                      : 'تحديث مطلوب',
                  style: fontStyle(
                      color: AppColors.white,
                      fontFamily: FontFamily.bold,
                      fontSize: 18),
                ),
                const SizedBox(height: 40),
                Text(
                  LanguageClass.isEnglish
                      ? 'A new version of SWA App is available! Version is now available.'
                      : 'تم العثور علي نسخه جديدة من تطبيق SWA App ، برجاء قم بتحديث التطبيق للحصول علي تحسينات جديدة',
                  textAlign: TextAlign.center,
                  style: fontStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: () async {
                    GooglePlayServicesAvailability availability =
                        await GoogleApiAvailability.instance
                            .checkGooglePlayServicesAvailability();
                    String storeUrl = Platform.isIOS
                        ? 'https://apps.apple.com/eg/app/swabus/id6473517315'
                        : availability ==
                                GooglePlayServicesAvailability.serviceMissing
                            ? "https://appgallery.huawei.com/app/C109796905"
                            : "https://play.google.com/store/apps/details?id=com.swa.app";
                    if (!await launchUrl(Uri.parse(storeUrl),
                        mode: LaunchMode.externalNonBrowserApplication)) {
                      throw 'Could not launch';
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 0.3,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Center(
                        child: Text(
                      LanguageClass.isEnglish ? 'Update Now' : 'حدث الان',
                      style: fontStyle(color: AppColors.blue),
                    )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
