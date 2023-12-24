import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/main.dart';

class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  MoreRepo moreRepo = MoreRepo(sl());
  StationsModel  aboutUsResponse  =StationsModel();
  @override
  void initState() {
get();
    super.initState();
  }
  void get()async{
    await BlocProvider.of<MoreCubit>(context).getStations();

    aboutUsResponse = (await moreRepo.getStations())!;
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
            LanguageClass.isEnglish? "Stations":"المحطات",
            style: TextStyle(
                color: AppColors.white,
                fontSize: 34,
                fontFamily: "bold"),
          ),
        ),
        backgroundColor: Colors.black,
        body: BlocBuilder(
            bloc: BlocProvider.of<MoreCubit>(context),
          builder: (context,state)  {
              if(state is LoadingStations){
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
                        height: sizeHeight * 0.05,
                      ),
                      SizedBox(
                        height: sizeHeight * 0.8,
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 25),
                                child: Row(
                                  children: [
                                    Text(
                                    aboutUsResponse.message![index].cityName!,
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontFamily: "regular",
                                          fontSize: 15
                                      ),
                                    ),
                                    Text(
                                      "  -  ${aboutUsResponse.message![index].stationName!}",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontFamily: "regular",
                                          fontSize: 15
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,)
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: AppColors.white,
                                thickness: 1,
                              );
                            },
                            itemCount: aboutUsResponse.message?.length??0),
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
