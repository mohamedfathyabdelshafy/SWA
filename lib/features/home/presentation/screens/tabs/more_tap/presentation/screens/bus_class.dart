import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_classes_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/main.dart';

class BusClasses extends StatefulWidget {
   BusClasses({super.key});

  @override
  State<BusClasses> createState() => _BusClassesState();
}

class _BusClassesState extends State<BusClasses> {
  MoreRepo moreRepo = MoreRepo(sl());
  BusClassesModel  busClasses  =BusClassesModel();
  @override
  void initState() {
    get();
    super.initState();
  }
  void get()async{
    await BlocProvider.of<MoreCubit>(context).getBusClass();
    busClasses = (await moreRepo.getBusClasses())!;
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
            "Bus Classes",
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
            if(state is LoadingBussClass){
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
                                  busClasses.message![index].title??"",
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontFamily: "regular",
                                      fontSize: 18
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
                        itemCount: busClasses.message?.length??0),
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
