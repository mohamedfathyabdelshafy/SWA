import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/main.dart';
import '../../../../../../../../config/routes/app_routes.dart';
import '../../../../../../../../core/utils/constants.dart';

class LinesScreen extends StatefulWidget {
  LinesScreen({super.key});

  @override
  State<LinesScreen> createState() => _LinesScreenState();
}

class _LinesScreenState extends State<LinesScreen> {
  MoreRepo moreRepo = MoreRepo(sl());
  LinesModel  linesModel  =LinesModel();
  @override
  void initState() {
    get();
    super.initState();
  }
  void get()async{
    await BlocProvider.of<MoreCubit>(context).getLines();
    linesModel = (await moreRepo.getLines())!;
    print("linesModel${linesModel.message![0].tripTypeId}");
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Directionality(
      textDirection: LanguageClass.isEnglish?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Routes",
            style: TextStyle(
                color: AppColors.white,
                fontSize: 34,
                fontFamily: "bold"),
          ),
        ),
        backgroundColor: Colors.black,
        body: BlocBuilder(
          bloc: BlocProvider.of<MoreCubit>(context),
          builder: (context,state){
            if(state is LoadingLines){
              return  Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor,),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: sizeHeight * 0.8,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 25),
                            child: SizedBox(
                              height: sizeHeight * 0.15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: sizeHeight * 0.03,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/Icon awesome-bus-alt.svg",
                                        height: sizeHeight * 0.06 ,

                                      ),
                                      SizedBox(
                                        width: sizeWidth * 0.05,
                                      ),
                                      Text(
                                        linesModel.message![index].name??"",
                                        style: TextStyle(
                                            fontFamily: "regular",
                                            fontSize: 30,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Spacer(),
                                      InkWell(
                                        onTap: (){
                                          Navigator.pushNamedAndRemoveUntil(context, Routes.initialRoute,
                                                (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Text(
                                            LanguageClass.isEnglish?"Book Now":"احجز الان",
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 20,
                                              fontFamily: "bold",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),

                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    // borderRadius: BorderRadius.circular(20)
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      LanguageClass.isEnglish?"Starts From":"يبدا من",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 20,
                                        fontFamily: "bold",
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "230.5",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 25,
                                        fontFamily: "bold",
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: linesModel.message?.length??0),
                  )
                ],
              ),


            );
          },

        ),
      ),
    );
  }
}
