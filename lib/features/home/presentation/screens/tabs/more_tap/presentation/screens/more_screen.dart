import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/FAQ_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/bus_class.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/contact_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/lines_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/privacy_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/stations_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/terms_and_conditions_terms.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      title: Text(
        "More",
        style: TextStyle(
            color: AppColors.white,
            fontSize: 34,
            fontFamily: "bold"),
      ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: sizeHeight * 0.1,
            ),
            InkWell(
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return BlocProvider<MoreCubit>(
                        create:(context) => MoreCubit() ,
                        child: const AboutUsScreen(),);
                  }));

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                child: Row(
                  children: [
                    Text(
                    "About Us",
                      style: TextStyle(
                          color: AppColors.white,
                          fontFamily: "regular",
                          fontSize: 18,
                      ),
                    ),
                   const Spacer(),
                    Icon(Icons.arrow_forward_ios,color: AppColors.white,size: 20,),
                  ],
                ),
              ),
            ),
            Divider(
              color: AppColors.white,
              thickness: 1,
            ),
            //TODO UNCOMMENT THIS WHEN FEATURES INTEGRATED
            // SizedBox(
            //   height: sizeHeight * 0.7,
            //   child: ListView.separated(
            //       itemBuilder: (context,index){
            //         return InkWell(
            //           onTap: (){
            //             if(index==4){
            //               Navigator.push(context, MaterialPageRoute(builder: (context){
            //                 return BlocProvider<MoreCubit>(
            //                     create:(context) => MoreCubit() ,
            //                     child: AboutUsScreen());
            //               }));
            //             }
            //           },
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
            //             child: Row(
            //               children: [
            //                 Text(
            //                     index==0?"Stations":
            //                         index==1?"Routes":
            //                             index==2?"Bus classes":
            //                                 index==3?"FAQ":
            //                                     index==4?"About Us":
            //                                         index==5?"Provacy":
            //                                             "Terms And Conditions",
            //                   style: TextStyle(
            //                     color: AppColors.white,
            //                     fontFamily: "regular",
            //                     fontSize: 18
            //                   ),
            //                 ),
            //                 Spacer(),
            //                 Icon(Icons.arrow_forward_ios,color: AppColors.white,size: 20,)
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //       separatorBuilder: (context,index){
            //         return Divider(
            //           color: AppColors.white,
            //           thickness: 1,
            //         );
            //       },
            //       itemCount:7 ),
            // )
          ],
=======
    return Directionality(
      textDirection: LanguageClass.isEnglish?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          LanguageClass.isEnglish? "More":"المزيد",
          style: TextStyle(
              color: AppColors.white,
              fontSize: 34,
              fontFamily: "bold"),
        ),
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: sizeHeight * 0.05,
              ),
              SizedBox(
                height: sizeHeight * 0.7,
                child: ListView.separated(
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          if(index==0){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return BlocProvider<MoreCubit>(
                                  create:(context) => MoreCubit() ,
                                  child: StationScreen());
                            }));
                          }  else if(index==1){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return BlocProvider<MoreCubit>(
                                  create:(context) => MoreCubit() ,
                                  child: LinesScreen());
                            }));
                          }
                          else if(index==2){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return BlocProvider<MoreCubit>(
                                  create:(context) => MoreCubit() ,
                                  child: BusClasses());
                            }));
                          }
                          else if(index==3){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return BlocProvider<MoreCubit>(
                                  create:(context) => MoreCubit() ,
                                  child: FAQScreen());
                            }));
                          }
                          else if(index==4){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return BlocProvider<MoreCubit>(
                                  create:(context) => MoreCubit() ,
                                  child: AboutUsScreen());
                            }));
                          }
                          else if(index==5){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return BlocProvider<MoreCubit>(
                                  create:(context) => MoreCubit() ,
                                  child: PrivacyScreen());
                            }));
                          }
                          else if(index==6){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return BlocProvider<MoreCubit>(
                                  create:(context) => MoreCubit() ,
                                  child: TermsConditionsScreen());
                            }));
                          }
                          else if(index==7){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return BlocProvider<MoreCubit>(
                                  create:(context) => MoreCubit() ,
                                  child: ContactUs());
                            }));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                          child: Row(
                            children: [
                              Text(
                                  index==0?LanguageClass.isEnglish?"Stations":"محطات":
                                      index==1?LanguageClass.isEnglish?"Routes":"خطوط":
                                          index==2?LanguageClass.isEnglish?"Bus classes":"انواع الاتوبيس":
                                              index==3?LanguageClass.isEnglish?"FAQ":"اسئله شائعة":
                                                  index==4?LanguageClass.isEnglish?"About Us":"معلومات عنا":
                                                      index==5?LanguageClass.isEnglish?"Privacy policy":"سياسة الخصوصية":
                                                        index == 6?LanguageClass.isEnglish?"Terms And Conditions":"الأحكام والشروط":
                                                          LanguageClass.isEnglish?"Contact us":"تواصل معنا",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: "regular",
                                  fontSize: 18
                                ),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios,color: AppColors.white,size: 20,)
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context,index){
                      return Divider(
                        color: AppColors.white,
                        thickness: 1,
                      );
                    },
                    itemCount:8 ),
              )
            ],
          ),
>>>>>>> ahmed
        ),
      ),
    );
  }
}
