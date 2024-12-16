import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/Swa_umra/Screens/Enter_trip_data.dart';
import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';

class TriplistScreen extends StatefulWidget {
  String city, campaign, date;
  TriplistScreen(
      {super.key,
      required this.campaign,
      required this.city,
      required this.date});

  @override
  State<TriplistScreen> createState() => _TriplistScreenState();
}

class _TriplistScreenState extends State<TriplistScreen> {
  final UmraBloc _umraBloc = UmraBloc();

  int opentap = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _umraBloc.add(GetcampaginsListEvent(
        campain: widget.campaign, city: widget.city, date: widget.date));
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
                        LanguageClass.isEnglish ? 'Campaigns' : 'الحملات',
                        style: const TextStyle(
                            fontSize: 38,
                            fontFamily: 'bold',
                            fontWeight: FontWeight.w500),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.triplistmodel!.message!.list!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 33, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    opentap == index
                                        ? opentap = -1
                                        : opentap = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Color(0xffC3C3C3),
                                      borderRadius: BorderRadius.circular(14),
                                      image: state.triplistmodel!.message!
                                                  .list![index].image ==
                                              null
                                          ? null
                                          : DecorationImage(
                                              fit: BoxFit.cover,
                                              image: state
                                                  .triplistmodel!
                                                  .message!
                                                  .list![index]
                                                  .image)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          state.triplistmodel!.message!
                                              .list![index].name!,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'bold',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('10 Nights',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'regular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                  DateFormat(
                                                          "EEE, MMM d, yyyyy")
                                                      .format(state
                                                          .triplistmodel!
                                                          .message!
                                                          .list![index]
                                                          .creationDate!)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'regular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('Transportation',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'regular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                  DateFormat("h:mm a")
                                                      .format(state
                                                          .triplistmodel!
                                                          .message!
                                                          .list![index]
                                                          .creationDate!)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'regular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 80,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            41)),
                                                child: Text(
                                                    LanguageClass.isEnglish
                                                        ? 'Book'
                                                        : 'احجز',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'regular',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xffcacaca))),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text('Availability 22',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontFamily: 'regular',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              opentap == index
                                  ? Container(
                                      child: ListView.builder(
                                        itemCount: state.triplistmodel!.message!
                                            .list![index].detailsList!.length,
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index2) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                                state
                                                    .triplistmodel!
                                                    .message!
                                                    .list![index]
                                                    .detailsList![index2]
                                                    .description!,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'meduim',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black)),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
