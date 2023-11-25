import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/widgets/custom_drop_down_list.dart';
import 'package:swa/features/home/domain/entities/cities_stations.dart';
import 'package:swa/features/home/domain/use_cases/get_to_stations_list_data.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/select_from_city/select_from_city.dart';
import 'package:swa/features/home/presentation/screens/select_to_city/select_to_city.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_states.dart';
import 'package:swa/features/times_trips/presentation/screens/times_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool isTabbed = false;
  int currentIndex = 0;
  DateTime selectedDayFrom = DateTime.now();
  DateTime selectedDayTo = DateTime.now().add(Duration(days: 1));
  List<CitiesStations>? _fromStations;
  List<CitiesStations>? _toStations;
  ///To be changed by selected station id
  int? _fromStationId;
  int? _toStationId;
  String _fromCityName = 'Select';
  String _toCityName = 'Select';
  ///Getting if user is logged in or not
  User? _user;
  String tripTypeId = "1";
  List <dynamic> tripListBack = [];
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      BlocProvider.of<LoginCubit>(context).getUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity, // Take the full width of the screen
                  child: Image.asset(
                    "assets/images/oranaa.agency_85935_luxor_landscape_and_sky_with_ballons_on_sky_e8ecb03c-2e93-4118-abed-39447bd055c9.png",
                    fit: BoxFit.cover,
                    // Maintain the aspect ratio
                  ),
                ),
                Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height:sizeHeight *0.10 ,),
                          SvgPicture.asset(
                            "assets/images/Swa Logo.svg",
                            height: sizeHeight * 0.06,
                            width: sizeWidth *0.06,
                          ),
                          SizedBox(height:sizeHeight * 0.06,),
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  tripTypeId = "1";
                                  setState(() {
                                    print("tripTypeId$tripTypeId");
                                  });
                                },
                                child: Container(
                                  height:sizeHeight *0.12,
                                  width: sizeWidth * 0.45,
                                  decoration: BoxDecoration(
                                      color: tripTypeId == "1"?AppColors.primaryColor: AppColors.darkPurple,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/arrow_one_way.svg",
                                      ),
                                      const SizedBox(height: 10,),
                                      Text("One way",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: sizeWidth *0.02,),
                              InkWell(
                                onTap: (){
                                  tripTypeId = "2";
                                  setState(() {
                                    print("tripTypeId$tripTypeId");
                                  });
                                },
                                child: Container(
                                  height:sizeHeight *0.12,
                                  width: sizeWidth * 0.45,
                                  decoration: BoxDecoration(
                                      color: tripTypeId == "2"?AppColors.primaryColor:AppColors.darkPurple,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/bus.svg",
                                      ),
                                      const SizedBox(height: 10,),
                                      Text("Round Trip",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: sizeHeight *0.02,),
                          const Padding(
                            padding:EdgeInsets.zero,
                            child: Text(
                              "From",
                              style: TextStyle(color: Colors.white,
                                  fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          BlocListener(
                            bloc: BlocProvider.of<HomeCubit>(context),
                            listener: (BuildContext context, state) async {
                              if(state is GetFromStationsListLoadingState) {
                                Constants.showLoadingDialog(context);
                              }
                              else if (state is GetFromStationsListLoadedState) {
                                Constants.hideLoadingDialog(context);
                                setState(() {
                                  if(state.homeMessageResponse.status == 'failed') {
                                    Constants.showDefaultSnackBar(context: context, text: state.homeMessageResponse.message.toString());
                                  }else {
                                    _fromStations = state.homeMessageResponse.citiesStations!.cast<CitiesStations>().toList();
                                  }
                                });
                                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return SelectFromCity(fromStations: _fromStations!);
                                }));
                                if (result != null) {
                                  setState(() {
                                    _fromStationId = result['_fromStationId'];
                                    _fromCityName = result['_fromCityName'];
                                  });
                                }
                                print("bassnt nasralla2$_fromStationId $_fromCityName");

                                // Widget _fromStationsListWidget = ListView.builder(
                                //   scrollDirection: Axis.vertical,
                                //   shrinkWrap: true,
                                //   itemCount: _fromStations!.length,
                                //   itemBuilder: (context, index) {
                                //     String cityName = _fromStations![index].cityName;
                                //     List<StationList> stationsList = _fromStations![index].stationList;
                                //     return stationsList.isNotEmpty ? Material(
                                //       child: ExpansionTile(
                                //         backgroundColor: Colors.grey[200],
                                //         iconColor: AppColors.primaryColor,
                                //         title: Text(
                                //           cityName,
                                //           style: const TextStyle(
                                //               color: Colors.black,
                                //               fontWeight: FontWeight.bold
                                //           ),
                                //         ),
                                //         children: [
                                //           ListView.builder(
                                //             shrinkWrap: true,
                                //             physics: const ClampingScrollPhysics(),//NeverScrollableScrollPhysics(),
                                //             scrollDirection: Axis.vertical,
                                //             itemCount: stationsList.length,
                                //             itemBuilder: (context, index) {
                                //               return ListTile(
                                //                 onTap: (){
                                //                   setState(() {
                                //                     _fromStationId = stationsList[index].stationId;
                                //                     _fromCityName = stationsList[index].stationName;
                                //                   });
                                //                   Navigator.of(context).pop();
                                //                 },
                                //                 leading: IconButton(
                                //                   icon: Icon(
                                //                     Icons.arrow_forward_ios_outlined,
                                //                     size: 20,
                                //                     color: AppColors.primaryColor,
                                //                   ),
                                //                   onPressed: () {
                                //                   },
                                //                 ),
                                //                 title: Text(stationsList[index].stationName),
                                //               );
                                //             },
                                //           ),
                                //         ],
                                //       ),
                                //     ) : const SizedBox(width: 60,);
                                //   },
                                // );
                                // Constants.showListDialog(context, 'From Stations', _fromStationsListWidget);
                              }
                              else if (state is GetFromStationsListErrorState) {
                                Constants.hideLoadingDialog(context);
                                Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                              }
                            },
                            child: InkWell(
                                onTap: () {
                                  BlocProvider.of<HomeCubit>(context).getFromStationsListData();
                                },
                                child: CustomDropDownList(hint:_fromCityName)
                            ),
                          ),
                          SizedBox(height: sizeHeight*0.07,),
                          const Padding(
                            padding:EdgeInsets.zero,
                            child: Text(
                              "To",
                              style: TextStyle(color: Colors.white,
                                  fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          BlocListener(
                            bloc: BlocProvider.of<HomeCubit>(context),
                            listener: (BuildContext context, state) async {
                              if(state is GetToStationsListLoadingState){
                                Constants.showLoadingDialog(context);
                              }
                              else if (state is GetToStationsListLoadedState) {
                                Constants.hideLoadingDialog(context);
                                setState(() {
                                  if(state.homeMessageResponse.status == 'failed') {
                                    Constants.showDefaultSnackBar(context: context, text: state.homeMessageResponse.message.toString());
                                  }else {
                                    _toStations = state.homeMessageResponse.citiesStations!.cast<CitiesStations>().toList();
                                  }
                                });
                                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return SelectToCity(toStations: _toStations!);
                                }));
                                if (result != null) {
                                  setState(() {
                                    _toStationId = result['_toStationId'];
                                    _toCityName = result['_toCityName'];
                                  });
                                }


                                // Widget _toStationsListWidget = ListView.builder(
                                //   scrollDirection: Axis.vertical,
                                //   shrinkWrap: true,
                                //   itemCount: _toStations!.length,
                                //   itemBuilder: (context, index) {
                                //     String cityName = _toStations![index].cityName;
                                //     List<StationList> stationsList = _toStations![index].stationList;
                                //     return stationsList.isNotEmpty ? Material(
                                //       child: ExpansionTile(
                                //         backgroundColor: Colors.grey[200],
                                //         iconColor: AppColors.primaryColor,
                                //         title: Text(
                                //           cityName,
                                //           style: const TextStyle(
                                //               color: Colors.black,
                                //               fontWeight: FontWeight.bold
                                //           ),
                                //         ),
                                //         children: [
                                //           ListView.builder(
                                //             shrinkWrap: true,
                                //             physics: const ClampingScrollPhysics(),//NeverScrollableScrollPhysics(),
                                //             scrollDirection: Axis.vertical,
                                //             itemCount: stationsList.length,
                                //             itemBuilder: (context, index) {
                                //               return ListTile(
                                //                 onTap: () {
                                //                   setState(() {
                                //                     _toStationId = stationsList[index].stationId;
                                //                     _toCityName = stationsList[index].stationName;
                                //                   });
                                //                   Navigator.of(context).pop();
                                //                 },
                                //                 leading: IconButton(
                                //                   icon: Icon(
                                //                     Icons.arrow_forward_ios_outlined,
                                //                     size: 20,
                                //                     color: AppColors.primaryColor,
                                //                   ),
                                //                   onPressed: () {
                                //                   },
                                //                 ),
                                //                 title: Text(stationsList[index].stationName),
                                //               );
                                //             },
                                //           ),
                                //         ],
                                //       ),
                                //     ) : const SizedBox(width: 60,);
                                //   },
                                // );
                                // Constants.showListDialog(context, 'To Stations', _toStationsListWidget);
                              }
                              else if (state is GetToStationsListErrorState) {
                                Constants.hideLoadingDialog(context);
                                Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                              }
                            },
                            child: InkWell(
                                onTap: () {
                                  if(_fromStationId != null) {
                                    BlocProvider.of<HomeCubit>(context).getToStationsListData(ToStationsParams(stationId: _fromStationId.toString()));
                                  }
                                },
                                child: CustomDropDownList(hint: _toCityName)
                            ),
                          ),
                          SizedBox(height: sizeHeight*0.03,),
                          Padding(
                            padding:  const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                            child: Row(
                              children: [
                                tripTypeId == "1"?
                                Row(
                                  children: [
                                    SizedBox(width: sizeWidth * 0.25,),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.date_range_outlined,color: AppColors.white,size: 16,),
                                            SizedBox(width: sizeWidth * 0.01,),
                                            Text("DEPART ON",
                                              style: TextStyle(color: AppColors.white,fontSize:12 ),)
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showMyDatePicker(selectedDayFrom);
                                            setState(() {
                                              selectedDayFrom;
                                            });
                                          },
                                          child: Text(
                                              "${selectedDayFrom.day}/${selectedDayFrom.month}/${selectedDayFrom.year}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: AppColors.white,fontSize: 20 )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ): Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.date_range_outlined,color: AppColors.white,size: 16,),
                                        SizedBox(width: sizeWidth * 0.01,),
                                        Text("DEPART ON",
                                          style: TextStyle(color: AppColors.white,fontSize:12 ),)
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showMyDatePicker(selectedDayFrom);
                                        setState(() {
                                          selectedDayFrom;
                                        });
                                      },
                                      child: Text(
                                          "${selectedDayFrom.day}/${selectedDayFrom.month}/${selectedDayFrom.year}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: AppColors.white,fontSize: 20 )),
                                    ),
                                  ],
                                ),
                                tripTypeId == "2"? const Spacer():SizedBox(),
                                tripTypeId == "2"?
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.date_range_outlined,color: AppColors.white,size: 16,),
                                        SizedBox(width: sizeWidth * 0.01,),
                                        Text("DEPART ON",
                                          style: TextStyle(color: AppColors.white,fontSize:12 ),)
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showMyDatePicker(selectedDayTo);
                                        setState(() {
                                          selectedDayTo;
                                        });
                                      },
                                      child: Text(
                                          "${selectedDayTo.day}/${selectedDayTo.month}/${selectedDayTo.year}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: AppColors.white,fontSize: 20 )),
                                    ),
                                  ],
                                ):SizedBox(),
                              ],
                            ),
                          ),
                          BlocListener<TimesTripsCubit,TimesTripsStates>(
                            bloc: BlocProvider.of<TimesTripsCubit>(context),
                            listener: (context,state){
                              if (state is LoadingTimesTrips) {
                                Constants.showLoadingDialog(context);
                              }else if(state is LoadedTimesTrips){
                                tripListBack = state.timesTripsResponse.message!.tripListBack ?? [];
                                Constants.hideLoadingDialog(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return TimesScreen(tripList:state.timesTripsResponse.message!.tripList!,tripTypeId: tripTypeId,
                                    tripListBack: state.timesTripsResponse.message!.tripListBack ?? [],
                                    user: _user,
                                  );
                                }));
                              }else if(state is ErrorTimesTrips){
                                Constants.hideLoadingDialog(context);
                                Constants.showDefaultSnackBar(context: context, text: state.msg);
                              }
                            },
                            child: InkWell(
                              onTap: (){
                                if(_fromStationId ==null || _toStationId == null) {
                                  Constants.showDefaultSnackBar(context: context, text:"please select from city or to city" );

                                }if(tripTypeId == "2" && tripListBack.isEmpty ){
                                  Constants.showDefaultSnackBar(context: context, text:"This journey has no return " );

                                }
                                else {
                                  print("tripTypeIdBassant  $tripTypeId  ${_fromStationId.toString()}  ${ _toStationId.toString()}"
                                      "  ${selectedDayFrom.toString()}  ${ selectedDayTo.toString()}");
                                  CacheHelper.setDataToSharedPref(key: 'fromStationId', value: _fromStationId.toString() );
                                  CacheHelper.setDataToSharedPref(key: 'toStationId', value: _toStationId.toString() );
                                  CacheHelper.setDataToSharedPref(key: 'selectedDayTo', value: selectedDayTo.toString() );
                                  CacheHelper.setDataToSharedPref(key: 'selectedDayFrom', value: selectedDayFrom.toString() );
                                  print("$_fromStationId===}$_toStationId===$selectedDayTo===$selectedDayFrom");
                                  BlocProvider.of<TimesTripsCubit>(context)
                                      .getTimes(
                                    tripType: tripTypeId,
                                    fromStationID: _fromStationId.toString(),
                                    toStationID: _toStationId.toString(),
                                    dateGo: selectedDayFrom.toString(),
                                    dateBack:selectedDayTo.toString(),
                                  );
                                }
                              },
                              child: Container(
                                height: 50,
                                //padding:  EdgeInsets.symmetric(horizontal: 10,vertical:20),
                                //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                                decoration:BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(15)
                                ) ,
                                child: Center(
                                  child: Text(
                                    "Search Bus",
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
  void showMyDatePicker(DateTime selectedDay) async {
    DateTime? newSelectedDay = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newSelectedDay != null) {
      setState(() {
        if (selectedDay == selectedDayFrom) {
          selectedDayFrom = newSelectedDay;
        } else if (selectedDay == selectedDayTo) {
          selectedDayTo = newSelectedDay;
        }
      });
    }
  }
}