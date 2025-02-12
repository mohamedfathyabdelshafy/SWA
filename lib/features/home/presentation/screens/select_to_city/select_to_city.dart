import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/widgets/icon_back.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../domain/entities/cities_stations.dart';
import '../../../domain/entities/station_list.dart';

class SelectToCity extends StatefulWidget {
  SelectToCity({super.key, required this.toStations});
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: iconBack(context),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Directionality(
          textDirection:
              LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LanguageClass.isEnglish ? "Select City" : "حدد المدينة",
                style: fontStyle(
                    color: AppColors.blackColor,
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.medium),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Color(0xffE0E0E0),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.toStations.length,
                  itemBuilder: (context, index) {
                    String cityName = widget.toStations[index].cityName;
                    List<StationList> stationsList =
                        widget.toStations[index].stationList;
                    return stationsList.isNotEmpty
                        ? Material(
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isTabbed == index
                                            ? isTabbed = -1
                                            : isTabbed = index;
                                        print("istabbed$isTabbed");
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            cityName,
                                            style: fontStyle(
                                                color: isTabbed == index
                                                    ? AppColors.primaryColor
                                                    : Color(0xffA3A3A3),
                                                fontFamily: FontFamily.bold,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  isTabbed == index
                                      ? Container(
                                          color: Colors.white,
                                          child: ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return Container();
                                            },
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(), //NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: stationsList.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                dense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                                onTap: () {
                                                  setState(() {
                                                    toStationId =
                                                        stationsList[index]
                                                            .stationId;
                                                    toCityName =
                                                        stationsList[index]
                                                            .stationName;
                                                  });
                                                  Navigator.of(context).pop({
                                                    '_toStationId': toStationId,
                                                    '_toCityName': toCityName,
                                                  });
                                                },
                                                title: Row(
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.loose,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: AppColors
                                                                      .lightBink,
                                                                  offset:
                                                                      Offset(
                                                                          0, 0),
                                                                  spreadRadius:
                                                                      0,
                                                                  blurRadius:
                                                                      15)
                                                            ],
                                                            color: AppColors
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: Text(
                                                          stationsList[index]
                                                              .stationName,
                                                          style: fontStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .medium,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(
                            width: 60,
                          );
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
