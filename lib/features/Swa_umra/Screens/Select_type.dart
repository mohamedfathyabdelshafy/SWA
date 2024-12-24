import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/Swa_umra/Screens/Enter_trip_data.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';

class SelectUmratypeScreen extends StatefulWidget {
  const SelectUmratypeScreen({super.key});

  @override
  State<SelectUmratypeScreen> createState() => _SelectUmratypeScreenState();
}

class _SelectUmratypeScreenState extends State<SelectUmratypeScreen> {
  final UmraBloc _umraBloc = UmraBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _umraBloc.add(TripUmraTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder(
          bloc: _umraBloc,
          builder: (context, UmraState state) {
            return Container(
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 90,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset('assets/images/swaumra.png'),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset('assets/images/umrah.png'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Made Effortlessly Easy',
                          style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffA3A3A3)),
                        )
                      ],
                    ),
                  )),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          for (int i = 0;
                              i < state.tripUmramodel!.message!.list!.length;
                              i++)
                            Container(
                              height: 70,
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 33.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(41),
                                border: Border.all(
                                    width: 2, color: Color(0xff707070)),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TripdataScreen(
                                                    triptype: state
                                                        .tripUmramodel!
                                                        .message!
                                                        .list![i]
                                                        .name!,
                                                  )));
                                    },
                                    child: Center(
                                      child: Text(
                                        state.tripUmramodel!.message!.list![i]
                                            .name!,
                                        textAlign: TextAlign.justify,
                                        textDirection: LanguageClass.isEnglish
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        style: TextStyle(
                                            fontFamily: 'bold',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )),
                                  Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: state.tripUmramodel!.message!
                                        .list![i].description,
                                    verticalOffset: -70,
                                    textStyle: TextStyle(
                                      fontFamily: 'bold',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    textAlign: LanguageClass.isEnglish
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.24),
                                    decoration: BoxDecoration(
                                        color: Color(0xffECB95A),
                                        borderRadius:
                                            BorderRadius.circular(23)),
                                    child: Icon(
                                      Icons.info_outline_rounded,
                                      color: Color(0xffA5A5A5),
                                    ),
                                  )
                                ],
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
    );
  }
}
