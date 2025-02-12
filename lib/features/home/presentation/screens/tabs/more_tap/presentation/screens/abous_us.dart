import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
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
  AboutUsResponse aboutUsResponse = AboutUsResponse();
  @override
  void initState() {
    get();
    super.initState();
  }

  void get() async {
    await BlocProvider.of<MoreCubit>(context).getStations();
    aboutUsResponse = (await moreRepo.getAboutUs())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Directionality(
      textDirection:
          LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder(
            bloc: BlocProvider.of<MoreCubit>(context),
            builder: (context, state) {
              if (state is LoadingAboutUs) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          LanguageClass.isEnglish ? "About us" : "من نحن",
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
                      Container(
                        height: 90,
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/applogo.png'),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text(
                                aboutUsResponse.message?.description ?? "",
                                style: fontStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontFamily.medium),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          )),
    );
  }
}
