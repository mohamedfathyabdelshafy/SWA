import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/widgets/icon_back.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../domain/entities/cities_stations.dart';
import '../../../domain/entities/station_list.dart';

class SelectFromCity extends StatefulWidget {
   SelectFromCity({super.key,required this.fromStations});
List fromStations;

  @override
  State<SelectFromCity> createState() => _SelectFromCityState();
}

class _SelectFromCityState extends State<SelectFromCity> {

  List<CitiesStations>? _toStations;

  ///To be changed by selected station id
  int? _fromStationId;

  String _fromCityName = LanguageClass.isEnglish?"Select":"تحديد";
int isTabbed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: iconBack(context),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Directionality(
          textDirection: LanguageClass.isEnglish?TextDirection.ltr:TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
               LanguageClass.isEnglish? "Select City":"حدد المدينة",
                style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily:"black"),
              ),
              SizedBox(height: 15,),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context,index){
                    return Divider(color: Color(0xff707070),);
                  },
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.fromStations.length,
                  itemBuilder: (context, index) {
                    String cityName = widget.fromStations[index].cityName;
                    List<StationList> stationsList = widget.fromStations[index].stationList;
                    return stationsList.isNotEmpty ? Material(
                      child: Container(
                        color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  isTabbed = index;
                                  print("istabbed$isTabbed");
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                height: MediaQuery.of(context).size.height *0.080,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:isTabbed == index? AppColors.primaryColor:Colors.black,

                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      cityName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        fontSize: 18
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(Icons.keyboard_arrow_down,color: AppColors.primaryColor,size: 20,)
                                  ],
                                ),
                              ),
                            ),
                            isTabbed == index?Container(
                              color: Colors.black,
                              child: ListView.separated(
                                separatorBuilder: (context,index){
                                  return Divider(color: Color(0xff707070),);
                                },
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),//NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: stationsList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: (){
                                      setState(() {
                                        _fromStationId = stationsList[index].stationId;
                                        _fromCityName = stationsList[index].stationName;
                                      });
                                      Navigator.of(context).pop({
                                        '_fromStationId': _fromStationId,
                                        '_fromCityName': _fromCityName,
                                      });

                                    },

                                    title: Text(stationsList[index].stationName,
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontFamily: "regular",
                                          fontSize: 18
                                      ),),
                                  );
                                },
                              ),
                            ):SizedBox(),
                          ],
                        ),
                      ),
                    ) : const SizedBox(width: 60,);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
