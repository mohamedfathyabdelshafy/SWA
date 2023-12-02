import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/abou_us_response.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/main.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}


class _AboutUsScreenState extends State<AboutUsScreen> {
  MoreRepo moreRepo = MoreRepo(sl());
  AboutUsResponse  aboutUsResponse  =AboutUsResponse();
  @override
  void initState() {
get();
    super.initState();
  }
 void get()async{
    aboutUsResponse = (await moreRepo.getAboutUs())!;
    setState(() {

    });
 }
  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.blackColor,
        title:  Text(
          "ABOUT US",
          style: TextStyle(
              color: AppColors.white,
              fontSize: 30,
              fontFamily: "bold"),
        ),
      ),
      body:
           Column(

            children: [
              Stack(
                children: [
                  SizedBox(
                    width:
                    double.infinity, // Take the full width of the screen
                    child: Image.asset(
                      "assets/images/oranaa.agency_85935_luxor_landscape_and_sky_with_ballons_on_sky_e8ecb03c-2e93-4118-abed-39447bd055c9.png",
                      fit: BoxFit.cover,
                      // Maintain the aspect ratio
                    ),
                  ),

                  Column(
                    children: [
                      SizedBox(
                        height: sizeHeight * 0.1,
                      ),
                      Center(
                        child: SvgPicture.asset(
                          "assets/images/Swa Logo.svg",
                          height: sizeHeight * 0.06,
                          width: sizeWidth * 0.06,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                child: Text(
                  aboutUsResponse.message?.description??"",
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontFamily: "regular"),
                ),
              ),
            ],
           )
          );

  }
}
