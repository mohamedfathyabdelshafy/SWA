import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/widgets/icon_back.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../domain/entities/cities_stations.dart';
import '../../../domain/entities/station_list.dart';

class SelectToCity extends StatefulWidget {
  SelectToCity({super.key,required this.toStations});
List toStations;
  @override
  State<SelectToCity> createState() => _SelectToCityState();
}

class _SelectToCityState extends State<SelectToCity> {


  ///To be changed by selected station id
  int? toStationId;

  String toCityName = 'Select';
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Select City",
              style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily:"black"),
            ),
            SizedBox(height: 15,),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.toStations.length,
                itemBuilder: (context, index) {
                  String cityName = widget.toStations[index].cityName;
                  List<StationList> stationsList = widget.toStations[index].stationList;
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
                              padding:const EdgeInsets.all(20),
                              height: 65,
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
                          isTabbed ==index? ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),//NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: stationsList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    toStationId = stationsList[index].stationId;
                                    toCityName = stationsList[index].stationName;
                                  });
                                  Navigator.of(context).pop({
                                    '_toStationId': toStationId,
                                    '_toCityName': toCityName,
                                  });                              },
                                // leading: IconButton(
                                //   icon: Icon(
                                //     Icons.arrow_forward_ios_outlined,
                                //     size: 20,
                                //     color: AppColors.primaryColor,
                                //   ),
                                //   onPressed: () {
                                //   },
                                // ),
                                title: Text(stationsList[index].stationName,
                                  style:
                                  TextStyle(
                                      color: AppColors.primaryColor,
                                      fontFamily: "regular",
                                      fontSize: 18
                                  ),),
                              );
                            },
                          ):SizedBox()
                        ],
                      ),
                    ),
                  ) : const SizedBox(width: 60,);
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}
