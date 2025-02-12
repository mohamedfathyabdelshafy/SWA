import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jhijri_picker/_src/_jWidgets.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/Trip_list_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/campain_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:jhijri/jHijri.dart';

class TripdataScreen extends StatefulWidget {
  String triptype;
  int typeid;
  TripdataScreen({super.key, required this.triptype, required this.typeid});

  @override
  State<TripdataScreen> createState() => _TripdataScreenState();
}

class _TripdataScreenState extends State<TripdataScreen> {
  final UmraBloc _umraBloc = UmraBloc();

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  DateTime? date;

  String selectedDate = '';

  bool opentap = false;

  String selectcity = '';
  String cityid = '';
  String campaginid = '';

  String selectcampain = '';
  bool ishijiri = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener(
          bloc: _umraBloc,
          listener: (context, UmraState state) {
            if (state.cityUmramodel?.status == 'success') {
              showGeneralDialog(
                  context: context,
                  pageBuilder: (context, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return Material(
                      color: Colors.transparent,
                      child: Directionality(
                        textDirection: LanguageClass.isEnglish
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 40,
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
                                    color: AppColors.umragold,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? "Select City"
                                      : "حدد المدينة",
                                  style: fontStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: FontFamily.bold),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Color(0xffE0E0E0),
                                    );
                                  },
                                  itemCount:
                                      state.cityUmramodel!.message!.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectcity = state.cityUmramodel!
                                              .message![index].cityName!;

                                          cityid = state.cityUmramodel!
                                              .message![index].cityId
                                              .toString();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        child: Text(
                                          state.cityUmramodel!.message![index]
                                              .cityName!,
                                          style: fontStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: FontFamily.bold),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }

            // if (state.campainModel?.status == 'success') {
            //   showGeneralDialog(
            //       context: context,
            //       pageBuilder: (context, Animation<double> animation,
            //           Animation<double> secondaryAnimation) {
            //         return Material(
            //           color: Colors.transparent,
            //           child: Container(
            //             padding: EdgeInsets.symmetric(horizontal: 25),
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: BorderRadius.circular(12)),
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               children: [
            //                 SizedBox(
            //                   height: 40,
            //                 ),
            //                 Container(
            //                   alignment: LanguageClass.isEnglish
            //                       ? Alignment.topLeft
            //                       : Alignment.topRight,
            //                   child: InkWell(
            //                     onTap: () {
            //                       Navigator.pop(context);
            //                     },
            //                     child: Icon(
            //                       Icons.arrow_back_rounded,
            //                       color: AppColors.umragold,
            //                       size: 35,
            //                     ),
            //                   ),
            //                 ),
            //                 Container(
            //                   margin: EdgeInsets.symmetric(horizontal: 25),
            //                   child: Text(
            //                     LanguageClass.isEnglish
            //                         ? "Select Campaign"
            //                         : "حدد الحملة",
            //                     style: fontStyle(
            //                         color: AppColors.blackColor,
            //                         fontSize: 25,
            //                         fontWeight: FontWeight.w500,
            //                         fontFamily: "bold"),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   height: 15,
            //                 ),
            //                 Expanded(
            //                   child: ListView.separated(
            //                     padding: EdgeInsets.zero,
            //                     separatorBuilder: (context, index) {
            //                       return Divider(
            //                         color: Color(0xffE0E0E0),
            //                       );
            //                     },
            //                     itemCount:
            //                         state.campainModel!.message!.list!.length,
            //                     scrollDirection: Axis.vertical,
            //                     shrinkWrap: true,
            //                     itemBuilder: (BuildContext context, int index) {
            //                       return InkWell(
            //                         onTap: () {
            //                           setState(() {
            //                             selectcampain = state.campainModel!
            //                                 .message!.list![index].name!;

            //                             campaginid = state
            //                                 .campainModel!
            //                                 .message!
            //                                 .list![index]
            //                                 .campiagnUmraId
            //                                 .toString();
            //                           });
            //                           Navigator.pop(context);
            //                         },
            //                         child: Container(
            //                           padding: EdgeInsets.symmetric(
            //                               horizontal: 20, vertical: 15),
            //                           child: Text(
            //                             state.campainModel!.message!
            //                                 .list![index].name!,
            //                             style: fontStyle(
            //                                 color: AppColors.blackColor,
            //                                 fontSize: 16,
            //                                 fontWeight: FontWeight.w500,
            //                                 fontFamily: "roman"),
            //                           ),
            //                         ),
            //                       );
            //                     },
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         );
            //       });
            // }
          },
          child: BlocBuilder(
              bloc: _umraBloc,
              builder: (context, UmraState state) {
                return SafeArea(
                  bottom: false,
                  child: Directionality(
                    textDirection: LanguageClass.isEnglish
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    child: Column(
                      children: [
                        10.verticalSpace,

                        Container(
                          margin: const EdgeInsets.only(left: 27, right: 27),
                          alignment: LanguageClass.isEnglish
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.umragold,
                              size: 25,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: LanguageClass.isEnglish ? 55 : 0,
                                right: LanguageClass.isEnglish ? 0 : 55),
                            alignment: LanguageClass.isEnglish
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              widget.triptype,
                              style: fontStyle(
                                  fontSize: 24.sp,
                                  color: Colors.black,
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.w500),
                            )),

                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            _umraBloc.add(GetcityEvent());
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 33),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(41),
                                border: Border.all(
                                    width: 2, color: const Color(0xff707070))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  selectcity == ''
                                      ? LanguageClass.isEnglish
                                          ? "From City ( Departs )"
                                          : "من مدينة ( المغادرة )"
                                      : selectcity,
                                  style: fontStyle(
                                      color: selectcity == ''
                                          ? Color(0xff969696)
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.bold,
                                      fontSize: 18),
                                ),
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: selectcity == ''
                                      ? Color(0xffDEDEDE)
                                      : AppColors.umragold,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        InkWell(
                          onTap: () async {
                            customdatepicker(
                              context: context,
                              hijiri: ishijiri,
                              onchange: (hdate) {
                                date = hdate.date;
                                hdate.jhijri.fDisplay = DisplayFormat.MMDDYYYY;

                                ishijiri
                                    ? selectedDate = hdate.jhijri.toString()
                                    : selectedDate =
                                        intl.DateFormat('MM-dd-yyyy')
                                            .format(date!)
                                            .toString();
                                setState(() {});
                                Navigator.pop(context);
                              },
                            );

                            //  await showDatePicker(
                            //   context: context,
                            //   builder: (context, child) {
                            //     return Theme(
                            //         data: Theme.of(context).copyWith(
                            //           colorScheme: ColorScheme.light(
                            //               primary: AppColors.umragold,
                            //               secondary: AppColors.lightgold),
                            //         ),
                            //         child: Transform.scale(
                            //             scale: 0.8,
                            //             alignment: Alignment.center,
                            //             child: child));
                            //   },
                            //   initialDate: DateTime.now(),
                            //   firstDate:
                            //       DateTime.now().subtract(Duration(days: 300)),
                            //   lastDate: DateTime.now().add(
                            //     const Duration(days: 365),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 33),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(41),
                                border: Border.all(
                                    width: 2, color: const Color(0xff707070))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  selectedDate == ''
                                      ? LanguageClass.isEnglish
                                          ? 'Select Date'
                                          : 'حدد التاريخ'
                                      : selectedDate,
                                  style: fontStyle(
                                      color: date == null
                                          ? Color(0xff969696)
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.bold,
                                      fontSize: 18),
                                ),
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: date == null
                                      ? Color(0xffDEDEDE)
                                      : AppColors.umragold,
                                )
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 18,
                        // ),
                        // InkWell(
                        //   onTap: () {
                        //     _umraBloc.add(GetcampainEvent());
                        //   },
                        //   child: Container(
                        //     margin: EdgeInsets.symmetric(horizontal: 33),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 30, vertical: 25),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(41),
                        //         border: Border.all(
                        //             width: 2, color: const Color(0xff707070))),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         Text(
                        //           selectcampain == ''
                        //               ? LanguageClass.isEnglish
                        //                   ? 'Select package'
                        //                   : 'اختر الباقة'
                        //               : selectcampain,
                        //           style: fontStyle(
                        //               color: selectcampain == ''
                        //                   ? Color(0xff969696)
                        //                   : Colors.black,
                        //               fontWeight: FontWeight.w600,
                        //               fontFamily: 'bold',
                        //               fontSize: 18),
                        //         ),
                        //         Icon(
                        //           Icons.check_circle_rounded,
                        //           color: selectcampain == ''
                        //               ? Color(0xffDEDEDE)
                        //               : AppColors.umragold,
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // state.campainModel?.status == 'success'
                        //     ? Flexible(
                        //         child: ListView.separated(
                        //         padding: EdgeInsets.symmetric(horizontal: 35),
                        //         separatorBuilder: (context, index) {
                        //           return Divider(
                        //             color: Color(0xffE0E0E0),
                        //           );
                        //         },
                        //         itemCount:
                        //             state.campainModel!.message!.list!.length,
                        //         scrollDirection: Axis.vertical,
                        //         physics: ScrollPhysics(),
                        //         shrinkWrap: true,
                        //         itemBuilder: (BuildContext context, int index) {
                        //           return InkWell(
                        //             onTap: () {
                        //               setState(() {
                        //                 selectcampain = state.campainModel!
                        //                     .message!.list![index].name!;

                        //                 campaginid = state.campainModel!.message!
                        //                     .list![index].campiagnUmraId
                        //                     .toString();
                        //               });

                        //               _umraBloc.emit(state.update(
                        //                   isloading: false,
                        //                   campainModel:
                        //                       CampainModel(status: '')));
                        //             },
                        //             child: Container(
                        //               padding: EdgeInsets.symmetric(
                        //                   horizontal: 20, vertical: 15),
                        //               child: Text(
                        //                 state.campainModel!.message!.list![index]
                        //                     .name!,
                        //                 style: fontStyle(
                        //                     color: AppColors.blackColor,
                        //                     fontSize: 16,
                        //                     fontWeight: FontWeight.w500,
                        //                     fontFamily: "roman"),
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //       ))
                        //     : SizedBox(),
                        SizedBox(
                          height: 18,
                        ),
                        InkWell(
                          onTap: () {
                            if (cityid != '' && selectedDate != '') {
                              UmraDetails.cityid = cityid;
                              UmraDetails.tripdate = selectedDate.toString();

                              UmraDetails.dateTypeID = ishijiri ? 112 : 113;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TriplistScreen(
                                            city: cityid,
                                            date: selectedDate,
                                            typeid: widget.typeid,
                                          )));
                            } else {
                              Constants.showDefaultSnackBar(
                                  context: context,
                                  color: AppColors.umragold,
                                  text: LanguageClass.isEnglish
                                      ? "Enter all the data"
                                      : 'أدخل كافة البيانات');
                            }
                          },
                          child: Container(
                            height: 69,
                            margin: EdgeInsets.symmetric(horizontal: 33),
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectcity == '' || date == null
                                  ? Color(0xffDEDEDE)
                                  : AppColors.umragold,
                              borderRadius: BorderRadius.circular(41),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  LanguageClass.isEnglish ? 'Search' : 'بحث',
                                  style: fontStyle(
                                    color: Colors.white,
                                    fontFamily: FontFamily.bold,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        bottomNavigationBar: Navigationbottombar(
          currentIndex: 0,
        ));
  }

  Future customdatepicker(
      {required BuildContext context,
      required bool hijiri,
      required onchange(JPickerValue date)}) async {
    return showGlobalDatePicker(
      context: context,
      headerTitle: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: InkWell(
            onTap: () {
              Navigator.pop(context);
              ishijiri = !ishijiri;
              customdatepicker(
                context: context,
                hijiri: ishijiri,
                onchange: onchange,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  hijiri
                      ? LanguageClass.isEnglish
                          ? 'Hijri'
                          : 'هجري'
                      : LanguageClass.isEnglish
                          ? 'Gregorian'
                          : "ميلادي",
                  style: fontStyle(
                      height: 1.2,
                      fontFamily: FontFamily.medium,
                      fontSize: 14.sp,
                      color: AppColors.blackColor),
                ),
                5.horizontalSpace,
                Icon(
                  Icons.change_circle_rounded,
                  color: AppColors.umragold,
                  size: 20,
                )
              ],
            )),
      ),
      selectedDate: JDateModel(jhijri: JHijri.now(), dateTime: DateTime.now()),
      pickerMode: DatePickerMode.day,
      pickerTheme: Theme.of(context),
      textDirection: TextDirection.ltr,
      buttons: Container(),
      locale: LanguageClass.isEnglish ? Locale("en", "US") : Locale("ar", ""),
      pickerType: hijiri ? PickerType.JHijri : PickerType.JNormal,
      onChange: onchange,
      primaryColor: AppColors.umragold,
      calendarTextColor: Colors.black,
      backgroundColor: Colors.white,
      borderRadius: const Radius.circular(0),
      buttonTextColor: Colors.white,
    );
  }
}
