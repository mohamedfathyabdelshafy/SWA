import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/Swa_umra/Screens/Trip_list_screen.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';

class TripdataScreen extends StatefulWidget {
  String triptype;
  TripdataScreen({super.key, required this.triptype});

  @override
  State<TripdataScreen> createState() => _TripdataScreenState();
}

class _TripdataScreenState extends State<TripdataScreen> {
  final UmraBloc _umraBloc = UmraBloc();

  DateTime? date;

  String selectcity = '';
  String cityid = '';
  String campaginid = '';

  String selectcampain = '';

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
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "roman"),
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
                                itemCount: state.cityUmramodel!.message!.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
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
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "roman"),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }

            if (state.campainModel?.status == 'success') {
              showGeneralDialog(
                  context: context,
                  pageBuilder: (context, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return Material(
                      color: Colors.transparent,
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
                                    ? "Select Campaign"
                                    : "حدد الحملة",
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "roman"),
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
                                    state.campainModel!.message!.list!.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectcampain = state.campainModel!
                                            .message!.list![index].name!;

                                        campaginid = state
                                            .campainModel!
                                            .message!
                                            .list![index]
                                            .campiagnUmraId
                                            .toString();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      child: Text(
                                        state.campainModel!.message!
                                            .list![index].name!,
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "roman"),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
          child: BlocBuilder(
              bloc: _umraBloc,
              builder: (context, UmraState state) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 27),
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
                          margin: const EdgeInsets.only(left: 55),
                          alignment: LanguageClass.isEnglish
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Text(
                            widget.triptype,
                            style: const TextStyle(
                                fontSize: 38,
                                fontFamily: 'regular',
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
                                selectcity == '' ? 'Select City' : selectcity,
                                style: TextStyle(
                                    color: selectcity == ''
                                        ? Color(0xff969696)
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'regular',
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
                          date = await showDatePicker(
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColors.umragold,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          setState(() {});
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
                                date == null
                                    ? 'Select Date'
                                    : DateFormat('dd-MM-yyyy')
                                        .format(date!)
                                        .toString(),
                                style: TextStyle(
                                    color: selectcity == ''
                                        ? Color(0xff969696)
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'regular',
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
                      SizedBox(
                        height: 18,
                      ),
                      InkWell(
                        onTap: () {
                          _umraBloc.add(GetcampainEvent());
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
                                selectcampain == ''
                                    ? 'Select Campaint'
                                    : selectcampain,
                                style: TextStyle(
                                    color: selectcampain == ''
                                        ? Color(0xff969696)
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'regular',
                                    fontSize: 18),
                              ),
                              Icon(
                                Icons.check_circle_rounded,
                                color: selectcampain == ''
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TriplistScreen(
                                        campaign: campaginid,
                                        city: cityid,
                                        date: DateFormat('dd-MM-yyyy')
                                            .format(date!)
                                            .toString(),
                                      )));
                        },
                        child: Container(
                          height: 69,
                          margin: EdgeInsets.symmetric(horizontal: 33),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectcampain == '' ||
                                    selectcity == '' ||
                                    date == null
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'bold',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
