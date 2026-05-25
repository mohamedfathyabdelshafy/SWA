import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/timer.dart';
import 'package:swa/features/Swa_umra/models/Transportaion_list_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/bus_reservation_layout/data/models/BusSeatsModel.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/data/repo/bus_reservation_repo.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/bus_layout_back.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_model.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/bus_seat_widget/seat_layout_widget.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/data/models/companies_model.dart';
import 'package:swa/features/times_trips/data/models/compnay_name_and_logo_model.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';

import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../bus_reservation_layout/presentation/PLOH/bus_layout_reservation_cubit.dart';

import '../../data/models/TimesTripsResponsedart.dart';
import '../PLOH/times_trips_states.dart';

// ignore: must_be_immutable
class TimesScreen extends StatefulWidget {
  TimesScreen(
      {super.key,
      required this.tripList,
      required this.tripTypeId,
      this.tripListBack,
      required this.fromTrip,
      required this.toTrip,
      required this.numberOfAdults,
      required this.dateTrip,
      this.tripType,
      this.fromStationID,
      this.toStationID,
      this.dateGo,
      this.dateBack,
      this.timesGo,
      this.timesBack});
  List<TripList> tripList;
  List<TripList>? tripListBack;

  String tripTypeId;
  String fromTrip;
  String toTrip;
  String numberOfAdults;
  String dateTrip;
  List<TimeSlots>? timesGo;
  List<TimeSlots>? timesBack;

  /// request
  String? tripType;
  String? fromStationID;
  String? toStationID;
  String? dateGo;
  String? dateBack;

  @override
  State<TimesScreen> createState() => _TimesScreenState();
}

class _TimesScreenState extends State<TimesScreen>
    with SingleTickerProviderStateMixin {
  int selected = -1;
  int selectedback = -1;
  BusSeatsModel? busSeatsModel;

  BusLayoutRepo busLayoutRepo = BusLayoutRepo(apiConsumer: (sl()));
  String? logoGo;
  String? companyGo;
  bool showTime = false;
  bool isRecommended = false;
  bool _showFilters = false;

  String selectedIndexDay = '';
  bool showCompanies = false;

  List<TimeSlots>? timeSlotsGo = [];
  List<TimeSlots>? timeSlotsBack = [];

  late ScrollController _dayScrollController;

  int startOffset = -5; // 5 days before today
  int selectedDayIndex = 5; // middle item initially

  bool isgotrip = true;

  String DateGo = '';
  String DateBack = '';
  int? recommendeID;
  int? companyID;
  String? startTime;
  String? endTime;

  String? recommendedvalue;
  String? companeyvalue;
  final List<String> _recommendedFilterItems = [];
  final List<String> _companyFilterItems = [];
  final Map<String, int?> _recommendedFilterIds = {};
  final Map<String, int?> _companyFilterIds = {};

  late DateTime selectedDate;

  final double itemWidth = 95;
  late final TimesTripsCubit _timesTripsCubit;
  late final AnimationController _roundTripHintController;
  late final Animation<double> _roundTripHintAnimation;

  bool get _hasBackTrips => widget.tripListBack?.isNotEmpty == true;

  bool get _isReturnSelectionView =>
      widget.tripTypeId == '2' &&
      Ticketreservation.Seatsnumbers1.isNotEmpty &&
      _hasBackTrips;

  bool get _isShowingBackTrips =>
      _isReturnSelectionView || (!isgotrip && _hasBackTrips);

  String get _currentTripTitle {
    if (LanguageClass.isEnglish) {
      return _isShowingBackTrips ? "Back" : "Go";
    }

    return _isShowingBackTrips ? "Ø¹ÙˆØ¯Ù‡" : "Ø°Ù‡Ø§Ø¨";
  }

  @override
  void initState() {
    super.initState();
    _timesTripsCubit = TimesTripsCubit()
      ..getCompaniesList()
      ..getRecomendedList();
    _roundTripHintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _roundTripHintAnimation = CurvedAnimation(
      parent: _roundTripHintController,
      curve: Curves.easeInOut,
    );
    // BlocProvider.of<TimesTripsCubit>(context).getCompaniesList();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _dayScrollController.jumpTo(5 * 65); // item width
    // });

    DateGo = widget.dateGo!;
    DateBack = widget.dateBack!;

    _dayScrollController = ScrollController();

    Ticketreservation.Seatsnumbers1.isNotEmpty
        ? selectedDate = widget.tripListBack!.isNotEmpty
            ? widget.tripListBack!.first.accessDate!
            : now
        : selectedDate = widget.tripList.isNotEmpty
            ? widget.tripList.first.accessDate!
            : now;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCenter();
    });

    timeSlotsGo = widget.timesGo;
    timeSlotsBack = widget.timesBack;
    selectedIndexDay = intl.DateFormat(
      'EEE, d MMM',
      LanguageClass.isEnglish ? 'en' : 'ar',
    ).format(
        widget.tripList.isNotEmpty ? widget.tripList.first.accessDate! : now);
  }

  @override
  void dispose() {
    _timesTripsCubit.close();
    _roundTripHintController.dispose();
    super.dispose();
  }

  void _scrollToCenter() {
    if (!_dayScrollController.hasClients) return;

    final daysViewportWidth = MediaQuery.of(context).size.width - 96;
    const selectedDayPosition = 5;
    const unselectedDayExtent = 100.0;
    const selectedDayExtent = 115.0;

    final targetOffset = (selectedDayPosition * unselectedDayExtent) -
        (daysViewportWidth / 2) +
        (selectedDayExtent / 2);

    _dayScrollController.animateTo(
      targetOffset.clamp(
        0,
        _dayScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _scrollSelectedDayToCenter() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToCenter();
      }
    });
  }

  CompaiesModel? compaiesModel;

  final Color _primaryColor = Color(0XFFf65702);
  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Color(0xfff3f3f3),
      // backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: Container(
          margin: EdgeInsets.symmetric(horizontal: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: Color(0xfff3f3f3),
            color: AppColors.white,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);

              Reservationtimer.stoptimer();
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.blackColor,
              size: 35,
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: SizedBox(
          width: MediaQuery.sizeOf(context).width * 1,
          child: Card(
            // color: Color(0xfff3f3f3),
            color: AppColors.white,
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(
                    "${widget.fromTrip} - ${widget.toTrip}",
                    style: fontStyle(
                        color: Colors.black,
                        fontFamily: FontFamily.medium,
                        fontSize: 12.sp),
                  ),
                  (LanguageClass.isEnglish)
                      ? Text(
                          "${widget.numberOfAdults} Adult -  ${widget.dateTrip}",
                          style: fontStyle(
                              color: Colors.grey,
                              fontFamily: FontFamily.regular,
                              fontSize: 10.sp),
                        )
                      : Text(
                          "\u202B${widget.numberOfAdults} Ø¨Ø§Ù„Øº - ${widget.dateTrip}",
                          style: fontStyle(
                              color: Colors.grey,
                              fontFamily: FontFamily.regular,
                              fontSize: 10.sp),
                        )
                ],
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Color(0xfff3f3f3),
              color: AppColors.white,
            ),
            child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(
                  CupertinoIcons.share,
                  color: AppColors.blackColor,
                  size: 20,
                )),
          )
        ],
      ),
      body: Directionality(
        textDirection:
            (LanguageClass.isEnglish) ? TextDirection.ltr : TextDirection.rtl,
        child: BlocProvider.value(
          value: _timesTripsCubit,
          child: BlocListener<TimesTripsCubit, TimesTripsStates>(
            listenWhen: (previous, current) =>
                current is LoadingTimesTrips ||
                current is LoadedTimesTrips ||
                current is ErrorTimesTrips ||
                current is LoadedRecommendedList ||
                current is LoadedCompaniesList,
            listener: _handleTimesTripsState,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_showFilters)
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 54,
                            end: 4,
                          ),
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0.0,
                            child: Row(
                              children: [
                                if (_showFilters) ...[
                                  Expanded(
                                    flex: (Platform.isIOS) ? 4 : 3,
                                    child: BlocBuilder<TimesTripsCubit,
                                        TimesTripsStates>(
                                      buildWhen: (previous, current) {
                                        return current
                                                is LoadedRecommendedList ||
                                            current is ErrorCompaniesList;
                                      },
                                      builder: (context, state) {
                                        if (state is LoadedRecommendedList &&
                                            state.recommendedModel.status !=
                                                "failed") {
                                          final Recomended =
                                              state.recommendedModel.message ??
                                                  [];

                                          return _buildFilterCard(
                                            title: recommendedvalue != null
                                                ? recommendedvalue!
                                                : (LanguageClass.isEnglish)
                                                    ? "Recommended"
                                                    : "Ø§Ù„Ù…ÙˆØµÙŠ Ø¨Ù‡Ø§",
                                            hasSelection:
                                                recommendedvalue != null,
                                            onClearSelection:
                                                _clearRecommendedFilter,
                                            dropdownItems: Recomended.map((e) =>
                                                    LanguageClass.isEnglish
                                                        ? e.textEn.toString()
                                                        : e.textAr.toString())
                                                .toList(),
                                            onItemSelected: (p0) {
                                              setState(() {
                                                recommendedvalue = p0;
                                              });
                                              var recomededid =
                                                  Recomended.where((element) =>
                                                      LanguageClass.isEnglish
                                                          ? element.textEn == p0
                                                          : element.textAr ==
                                                              p0).first.id;
                                              recommendeID = recomededid;
                                              _fetchTripsForSelectedDay();
                                            },
                                            onOpenChanged: (isOpen) {
                                              setState(() {
                                                isRecommended = isOpen;
                                                if (isOpen) {
                                                  showCompanies = false;
                                                }
                                              });
                                            },
                                            isRadiusActive: isRecommended,
                                            icon: Icons
                                                .keyboard_arrow_down_rounded,
                                          );
                                        }

                                        if (state is LoadingCompaniesList) {
                                          return const Center(
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        }

                                        if (state is ErrorCompaniesList) {
                                          return _buildFilterCard(
                                            title: LanguageClass.isEnglish
                                                ? "Recommended"
                                                : "Ø§Ù„Ù…ÙˆØµÙŠ Ø¨Ù‡Ø§",
                                            icon: Icons
                                                .keyboard_arrow_down_rounded,
                                          );
                                        }

                                        return _buildFilterCard(
                                          title: LanguageClass.isEnglish
                                              ? "Recommended"
                                              : "Ø§Ù„Ù…ÙˆØµÙŠ Ø¨Ù‡Ø§",
                                          icon:
                                              Icons.keyboard_arrow_down_rounded,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: (Platform.isIOS) ? 4 : 3,
                                    child: BlocBuilder<TimesTripsCubit,
                                        TimesTripsStates>(
                                      buildWhen: (previous, current) {
                                        return current is LoadedCompaniesList ||
                                            current is ErrorCompaniesList;
                                      },
                                      builder: (context, state) {
                                        if (state is LoadedCompaniesList &&
                                            state.compaiesModel.status !=
                                                "failed") {
                                          final companies =
                                              state.compaiesModel.message ?? [];

                                          return _buildFilterCard(
                                            onTap: () {},
                                            isRadiusActive: showCompanies,
                                            title: companeyvalue != null
                                                ? companeyvalue!
                                                : LanguageClass.isEnglish
                                                    ? "Companies"
                                                    : "Ø§Ù„Ø´Ø±ÙƒØ§Øª",
                                            hasSelection:
                                                companeyvalue != null,
                                            onClearSelection:
                                                _clearCompanyFilter,
                                            onItemSelected: (p0) {
                                              setState(() {
                                                companeyvalue = p0;
                                              });
                                              var companyid = companies
                                                  .where((element) =>
                                                      element.Name == p0)
                                                  .first
                                                  .CompanyID;
                                              companyID = companyid;
                                              _fetchTripsForSelectedDay();
                                            },
                                            dropdownItems: companies
                                                .map((e) => e.Name.toString())
                                                .toList(),
                                            onOpenChanged: (isOpen) {
                                              setState(() {
                                                showCompanies = isOpen;
                                                if (isOpen) {
                                                  isRecommended = false;
                                                }
                                              });
                                            },
                                            icon: Icons
                                                .keyboard_arrow_down_rounded,
                                          );
                                        }

                                        if (state is LoadingCompaniesList) {
                                          return const Center(
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        }

                                        if (state is ErrorCompaniesList) {
                                          return _buildFilterCard(
                                            title: LanguageClass.isEnglish
                                                ? "Companies"
                                                : "Ø§Ù„Ø´Ø±ÙƒØ§Øª",
                                            icon: Icons
                                                .keyboard_arrow_down_rounded,
                                          );
                                        }

                                        if (_companyFilterItems.isNotEmpty) {
                                          return _buildCachedCompanyFilterCard();
                                        }

                                        return _buildFilterCard(
                                          title: LanguageClass.isEnglish
                                              ? "Companies"
                                              : "Ø§Ù„Ø´Ø±ÙƒØ§Øª",
                                          icon:
                                              Icons.keyboard_arrow_down_rounded,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                                if (_showFilters && _hasBackTrips)
                                  Expanded(
                                    flex: 2,
                                    child: _buildFilterCard(
                                        onTap: () {
                                          if (!_isReturnSelectionView) {
                                            setState(() {
                                              isgotrip = !isgotrip;
                                            });
                                          }
                                          _fetchTripsForSelectedDay();
                                        },
                                        title: _currentTripTitle,
                                        icon:
                                            Icons.keyboard_arrow_down_outlined,
                                        iconCustom: true,
                                        widget: _buildTripToggleHintIcon()),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (_showFilters) _buildDayWidget(),
                    if (_showFilters) _buildTimeWidget("day", "time"),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      height: _showFilters ? 16 : 56,
                    ),
                    Ticketreservation.Seatsnumbers1.isNotEmpty
                        ? SizedBox.shrink()
                        : Expanded(
                            flex: selected.isEven ? 7 : 1,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: widget.tripList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selected == index
                                              ? selected = -1
                                              : selected = index;
                                        });
                                      },
                                      child: Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            borderRadius: selected != index
                                                ? BorderRadius.circular(10)
                                                : BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                            color: AppColors.white
                                            // color: Color(0xffF3F3F3)
                                            ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10.0),
                                        // padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (widget.tripList[index]
                                                    .IsSPonsored ==
                                                true)
                                              Container(
                                                decoration: BoxDecoration(
                                                    // gradient: const LinearGradient(
                                                    //   colors: [
                                                    //     Color(0xfffd634f),
                                                    //     Color(0xffff9976),
                                                    //   ],
                                                    // ),
                                                    color: _primaryColor),
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          LanguageClass
                                                                  .isEnglish
                                                              ? "Enjoy for less with ${widget.tripList[index].companyName}"
                                                              : "Ø§Ø³ØªÙ…ØªØ¹ Ø¨ØªÙƒÙ„ÙØ© Ø£Ù‚Ù„ Ù…Ø¹ Ø­Ø§ÙÙ„Ø§Øª ${widget.tripList[index].companyName}",
                                                          style: fontStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .bold,
                                                              fontSize: 12.sp),
                                                        ),
                                                        Text(
                                                          LanguageClass
                                                                  .isEnglish
                                                              ? "Unbeatable trips deals with ${widget.tripList[index].companyName}! "
                                                              : "Ø¹Ø±ÙˆØ¶ Ø±Ø­Ù„Ø§Øª Ù„Ø§ ØªÙØ¶Ø§Ù‡Ù‰ Ù…Ø¹ ${widget.tripList[index].companyName}!",
                                                          style: fontStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .regular,
                                                              fontSize: 10.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      LanguageClass.isEnglish
                                                          ? "Sponsored"
                                                          : "Ù…Ù…ÙˆÙ„",
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontFamily: FontFamily
                                                              .regular,
                                                          fontSize: 12.sp),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            // todo : logo and provider name
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 6),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height: 38,
                                                        width: 38,
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: _primaryColor,
                                                        ),
                                                        child: Image.network(
                                                          widget.tripList[index]
                                                                          .logo ==
                                                                      null ||
                                                                  widget
                                                                          .tripList[
                                                                              index]
                                                                          .logo ==
                                                                      ""
                                                              ? "https://play-lh.googleusercontent.com/ACfnkQHBH_KBNpqhaU2PkbNp1mcLeZtaOHHvKTSDHBEOD43QH9gB9nd5GQkWpfB9n7M=w480-h960-rw"
                                                              : widget
                                                                  .tripList[
                                                                      index]
                                                                  .logo!,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        widget.tripList[index]
                                                                .companyName ??
                                                            (LanguageClass
                                                                    .isEnglish
                                                                ? "Swa"
                                                                : "Ø³ÙˆØ§"),
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 12.sp),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: _primaryColor,
                                                        // color: Color(0xffFC9900),
                                                        size: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        "4.5",
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            height: 0,
                                                            fontSize: 12.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Expanded(
                                                    flex: 3,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      spacing: 10,
                                                      children: [
                                                        if (widget
                                                                .tripList[index]
                                                                .IsCheapeast ==
                                                            true)
                                                          Card(
                                                            margin:
                                                                EdgeInsets.zero,
                                                            elevation: 0.0,
                                                            color: Color(
                                                                0xff381213),
                                                            // color: Color(0xff05488F),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6),
                                                              bottomLeft: Radius
                                                                  .circular(6),
                                                            )),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6.0,
                                                                      vertical:
                                                                          2),
                                                              child: Center(
                                                                  child: Text(
                                                                "Cheapest",
                                                                style: fontStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                            ),
                                                          ),
                                                        if (widget
                                                                .tripList[index]
                                                                .IsBestValue ==
                                                            true)
                                                          Card(
                                                            margin:
                                                                EdgeInsets.zero,
                                                            elevation: 0.0,
                                                            color:
                                                                _primaryColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6),
                                                              bottomLeft: Radius
                                                                  .circular(6),
                                                            )),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6.0,
                                                                      vertical:
                                                                          2),
                                                              child: Center(
                                                                  child: Text(
                                                                "Best Value",
                                                                style: fontStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                            ),
                                                          ),
                                                        SizedBox(
                                                          width: 0,
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                            // todo : details from to
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 5,
                                                    children: [
                                                      Text(
                                                        widget.tripList[index]
                                                            .from!,
                                                        style: fontStyle(
                                                            color: Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        intl.DateFormat(
                                                                'hh:mm a')
                                                            .format(widget
                                                                .tripList[index]
                                                                .accessDate!)
                                                            .toString(),
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        intl.DateFormat(
                                                                'dd MMMM yyyy',
                                                                LanguageClass
                                                                        .isEnglish
                                                                    ? 'en'
                                                                    : 'ar')
                                                            .format(widget
                                                                .tripList[index]
                                                                .accessDate!)
                                                            .toString(),
                                                        style: fontStyle(
                                                            color: Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 7.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  RotatedBox(
                                                    quarterTurns:
                                                        LanguageClass.isEnglish
                                                            ? 90
                                                            : 90,
                                                    child: Stack(
                                                      // alignment: Alignment.centerLeft,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 1,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  right: 10,
                                                                  left: 10,
                                                                  bottom: 5),
                                                          color:
                                                              Color(0xff000000),
                                                          // child: Icon(
                                                          //   Icons.arrow_right_alt_rounded,
                                                          //   size: 30,
                                                          // ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 2.3,
                                                            right: LanguageClass
                                                                    .isEnglish
                                                                ? 0
                                                                : 2,
                                                            left: LanguageClass
                                                                    .isEnglish
                                                                ? 2
                                                                : 0,
                                                          ),
                                                          child: Icon(
                                                            LanguageClass.isEnglish
                                                                ? Icons
                                                                    .keyboard_arrow_left_rounded
                                                                : Icons
                                                                    .keyboard_arrow_right_rounded,
                                                            size: 15.5,
                                                            color: Color(
                                                                0xff000000),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 5,
                                                    children: [
                                                      Text(
                                                        widget.tripList[index]
                                                            .to!,
                                                        style: fontStyle(
                                                            color: Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        intl.DateFormat(
                                                                'hh:mm a')
                                                            .format(widget
                                                                .tripList[index]
                                                                .arrivalDate!)
                                                            .toString(),
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        intl.DateFormat(
                                                                'dd MMMM yyyy',
                                                                LanguageClass
                                                                        .isEnglish
                                                                    ? 'en'
                                                                    : 'ar')
                                                            .format(widget
                                                                .tripList[index]
                                                                .arrivalDate!),
                                                        style: fontStyle(
                                                            color: Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 7.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    // fit: FlexFit.loose,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      spacing: 5,
                                                      children: [
                                                        Text(
                                                          '${widget.tripList[index].price.toString()} ${Routes.curruncy ?? ""}',
                                                          style: fontStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .medium,
                                                              fontSize: 12.sp),
                                                        ),
                                                        // SizedBox(
                                                        //   height: 10,
                                                        // ),
                                                        Row(
                                                          spacing: 5,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // SvgPicture.asset(
                                                            //   "assets/images/disabled_seats.svg",
                                                            //   height: 15,
                                                            //   width: 15,
                                                            // ),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            0.0),
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/img_1.png",
                                                                  width: 20,
                                                                  height: 20,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .high,
                                                                )),
                                                            Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? '${widget.tripList[index].emptySeat}'
                                                                  : '${widget.tripList[index].emptySeat}',
                                                              style: fontStyle(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        8.verticalSpace,
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    selected == index
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                // color: Color(0xffF3F3F3),
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                )),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                    // height: 250,
                                                    width: double.infinity,
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      fit: StackFit.loose,
                                                      children: [
                                                        widget.tripList[index]
                                                                    .imageMap ==
                                                                null
                                                            ? Image.asset(
                                                                "assets/images/img.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                widget
                                                                    .tripList[
                                                                        index]
                                                                    .imageMap!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                        SizedBox(
                                                          height: 90,
                                                          width:
                                                              double.infinity,
                                                          child: ListView
                                                              .separated(
                                                            shrinkWrap: true,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context, i) =>
                                                                    Container(
                                                              height: 90,
                                                              width: 120,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    _primaryColor,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .white,
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                // image:
                                                                //     DecorationImage(
                                                                //   image: NetworkImage(widget
                                                                //           .tripList[
                                                                //               index]
                                                                //           .BusPhotos?[
                                                                //               i]
                                                                //           .toString() ??
                                                                //       ""),
                                                                //   fit: BoxFit
                                                                //       .cover,
                                                                // )
                                                              ),
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: Image
                                                                    .network(
                                                                  widget
                                                                          .tripList[
                                                                              index]
                                                                          .BusPhotos?[
                                                                              i]
                                                                          .toString() ??
                                                                      "",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  loadingBuilder:
                                                                      (context,
                                                                          child,
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    }
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                        color: AppColors
                                                                            .greyLight,
                                                                      ),
                                                                    );
                                                                  },
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .red);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            separatorBuilder:
                                                                (context,
                                                                        index) =>
                                                                    SizedBox(
                                                              width: 10,
                                                            ),
                                                            itemCount: widget
                                                                    .tripList[
                                                                        index]
                                                                    .BusPhotos
                                                                    ?.length ??
                                                                0,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                    //     MapRouteWidget(
                                                    //   routePoints: [
                                                    //     // LatLng(30.0444, 31.2357),
                                                    //     // LatLng(31.2001, 29.9187),
                                                    //     LatLng(30.0, 31.0),
                                                    //     LatLng(31.0, 30.0),
                                                    //   ],
                                                    //   googleApiKey:
                                                    //       'AIzaSyAipdrKwqPfmyfmzhZG1PZJJ8J61SM14i8',
                                                    //   useDirections: true,
                                                    // )
                                                    ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        0),
                                                            child: ListView
                                                                .builder(
                                                              itemCount: widget
                                                                  .tripList[
                                                                      index]
                                                                  .lineCity
                                                                  .length,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  ScrollPhysics(),
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index2) {
                                                                final date = now
                                                                    .add(Duration(
                                                                        days:
                                                                            index2));
                                                                final time = intl
                                                                    .DateFormat(
                                                                  'h:mm a',
                                                                  LanguageClass
                                                                          .isEnglish
                                                                      ? 'en'
                                                                      : 'ar',
                                                                ).format(date.add(
                                                                    Duration(
                                                                        hours:
                                                                            index2)));
                                                                return Container(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            70,
                                                                        child:
                                                                            Text(
                                                                          // '${widget.tripList[index].lineCity[index2].lineStationList.first.accessTime!.split(':')[0]}:${widget.tripList[index].lineCity[index2].lineStationList.first.accessTime!.split(':')[1]}' ??
                                                                          time,
                                                                          style: fontStyle(
                                                                              color: AppColors.blackColor,
                                                                              fontFamily: FontFamily.medium,
                                                                              height: 0.5,
                                                                              fontSize: 12.sp),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                13,
                                                                            width:
                                                                                13,
                                                                            alignment:
                                                                                Alignment.center,
                                                                            padding: index2 == 0
                                                                                ? EdgeInsets.all(1.2)
                                                                                : EdgeInsets.zero,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(
                                                                                style: BorderStyle.solid,
                                                                                color: index2 == 0
                                                                                    ? _primaryColor
                                                                                    // ? Color(0xff007663)
                                                                                    : Colors.transparent,
                                                                                width: index2 == 0 ? 1 : 0.0,
                                                                              ),
                                                                            ),
                                                                            child: index2 == widget.tripList[index].lineCity.length - 1
                                                                                ? Icon(
                                                                                    CupertinoIcons.location_solid,
                                                                                    size: 15,
                                                                                    color: Color(0xff7700FF),
                                                                                  )
                                                                                : Container(
                                                                                    height: 11,
                                                                                    width: 11,
                                                                                    decoration: BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                    child: Icon(
                                                                                      Icons.circle,
                                                                                      size: 4,
                                                                                      color: Colors.white,
                                                                                    )),
                                                                          ),
                                                                          index2 == widget.tripList[index].lineCity.length - 1
                                                                              ? SizedBox.shrink()
                                                                              : Container(
                                                                                  height: 20,
                                                                                  width: 1.1,
                                                                                  color: AppColors.blackColor,
                                                                                )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        '${widget.tripList[index].lineCity[index2].cityName}' ??
                                                                            '',
                                                                        style: fontStyle(
                                                                            color: AppColors
                                                                                .blackColor,
                                                                            fontFamily: FontFamily
                                                                                .bold,
                                                                            decoration: index2 == 0
                                                                                ? TextDecoration.underline
                                                                                : TextDecoration.none,
                                                                            height: 0.5,
                                                                            fontSize: 12.sp),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 25,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            child: Text(
                                                              'Premuim â€¢ AC â€¢ Bus',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: fontStyle(
                                                                color: Color(
                                                                    0xff888888),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .regular,
                                                                fontSize: 9.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          // SizedBox(
                                                          //   height: 10,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        // _buildFilterCard(
                                                        //   onTap: () {},
                                                        //   icon: Icons
                                                        //       .directions_car_filled,
                                                        //   iconColor:
                                                        //       Color(0xff007663),
                                                        //   title: (LanguageClass
                                                        //           .isEnglish)
                                                        //       ? "1 min"
                                                        //       : "20 Ø¯Ù‚ÙŠÙ‚Ø©",
                                                        //   padding: EdgeInsets.zero,
                                                        //   iconCustom: true,
                                                        //   widget: Icon(
                                                        //     Icons
                                                        //         .directions_car_filled,
                                                        //     color: Color(0xff007663),
                                                        //     size: 15,
                                                        //   ),
                                                        //   textStyle: fontStyle(
                                                        //       color:
                                                        //           Color(0xff717171),
                                                        //       fontFamily:
                                                        //           FontFamily.medium,
                                                        //       fontSize: 11.sp),
                                                        // ),
                                                        // _buildFilterCard(
                                                        //   onTap: () {},
                                                        //   icon: Icons.directions_walk,
                                                        //   iconColor:
                                                        //       Color(0xff007663),
                                                        //   title: (LanguageClass
                                                        //           .isEnglish)
                                                        //       ? "20 min"
                                                        //       : "20 Ø¯Ù‚ÙŠÙ‚Ø©",
                                                        //   padding: EdgeInsets.zero,
                                                        //   iconCustom: true,
                                                        //   widget: Icon(
                                                        //     Icons.directions_walk,
                                                        //     color: Color(0xff007663),
                                                        //     size: 15,
                                                        //   ),
                                                        //   textStyle: fontStyle(
                                                        //       color:
                                                        //           Color(0xff717171),
                                                        //       fontFamily:
                                                        //           FontFamily.medium,
                                                        //       fontSize: 11.sp),
                                                        // ),
                                                        SizedBox(
                                                          height:
                                                              sizeHeight * 0.07,
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: InkWell(
                                                            onTap: () {
                                                              CacheHelper.setDataToSharedPref(
                                                                  key:
                                                                      'numberTrip',
                                                                  value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .tripNumber);
                                                              CacheHelper.setDataToSharedPref(
                                                                  key: 'elite',
                                                                  value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .serviceType);
                                                              CacheHelper.setDataToSharedPref(
                                                                  key:
                                                                      'accessBusTime',
                                                                  value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .accessBusTime);
                                                              CacheHelper.setDataToSharedPref(
                                                                  key:
                                                                      'accessBusDate',
                                                                  value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .accessDate
                                                                      .toString());

                                                              CacheHelper.setDataToSharedPref(
                                                                  key:
                                                                      'arrivaldate',
                                                                  value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .arrivalDate
                                                                      .toString());
                                                              CacheHelper.setDataToSharedPref(
                                                                  key:
                                                                      'lineName',
                                                                  value: widget
                                                                      .tripList[
                                                                          index]
                                                                      .lineName);
                                                              CacheHelper.setDataToSharedPref(
                                                                  key:
                                                                      'tripOneId',
                                                                  value: widget
                                                                          .tripList[
                                                                              index]
                                                                          .tripId ??
                                                                      0);

                                                              CacheHelper.setDataToSharedPref(
                                                                  key: 'lineid',
                                                                  value: widget
                                                                          .tripList[
                                                                              index]
                                                                          .lineId ??
                                                                      0);

                                                              CacheHelper.setDataToSharedPref(
                                                                  key:
                                                                      'serviceTypeID',
                                                                  value: widget
                                                                          .tripList[
                                                                              index]
                                                                          .serviceTypeId ??
                                                                      0);

                                                              CacheHelper.setDataToSharedPref(
                                                                  key: 'busId',
                                                                  value: widget
                                                                          .tripList[
                                                                              index]
                                                                          .busId ??
                                                                      0);
                                                              print(
                                                                  " widget.tripList[index].tripId${widget.tripList[index].tripId}");
                                                              var bookModel =
                                                                  BookingModel(
                                                                departureCompanyLogo:
                                                                    widget
                                                                        .tripList[
                                                                            index]
                                                                        .logo,
                                                                departureCompanyName: widget
                                                                    .tripList[
                                                                        index]
                                                                    .companyName,
                                                              );

                                                              logoGo = bookModel
                                                                  .departureCompanyLogo;
                                                              companyGo = bookModel
                                                                  .departureCompanyName;
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                  return BlocProvider(
                                                                    create: (context) =>
                                                                        BusLayoutCubit(),
                                                                    child:
                                                                        BusLayoutScreen(
                                                                      isedit:
                                                                          false,
                                                                      bookingModel:
                                                                          bookModel,
                                                                      busdate: widget
                                                                          .tripList[
                                                                              index]
                                                                          .accessDate,
                                                                      arrivalDate: widget
                                                                          .tripList[
                                                                              index]
                                                                          .arrivalDate,
                                                                      busttime: widget
                                                                          .tripList[
                                                                              index]
                                                                          .accessBusTime,
                                                                      discount: widget
                                                                          .tripList[
                                                                              index]
                                                                          .discount,
                                                                      to: widget
                                                                              .tripList[index]
                                                                              .to ??
                                                                          "",
                                                                      from: widget
                                                                              .tripList[index]
                                                                              .from ??
                                                                          "",
                                                                      triTypeId:
                                                                          widget
                                                                              .tripTypeId,
                                                                      tripListBack:
                                                                          widget
                                                                              .tripListBack,
                                                                      price: widget
                                                                          .tripList[
                                                                              index]
                                                                          .price!,
                                                                      user: Routes
                                                                          .user,
                                                                      tripId: widget
                                                                          .tripList[
                                                                              index]
                                                                          .tripId!,
                                                                      tocity: widget
                                                                              .tripList[index]
                                                                              .toCityName ??
                                                                          '',
                                                                      fromcity:
                                                                          widget.tripList[index].fromCityName ??
                                                                              '',
                                                                    ),
                                                                  );
                                                                }),
                                                              ).then((value) {
                                                                if (Ticketreservation
                                                                    .Seatsnumbers1
                                                                    .isNotEmpty) {
                                                                  // WidgetsBinding
                                                                  //     .instance
                                                                  //     .addPostFrameCallback(
                                                                  //         (_) {
                                                                  //   _dayScrollController
                                                                  //       .jumpTo(5 *
                                                                  //           65); // item width
                                                                  // });

                                                                  setState(() {
                                                                    isgotrip =
                                                                        false;
                                                                    Ticketreservation
                                                                            .Seatsnumbers1
                                                                            .isNotEmpty
                                                                        ? selectedDate = widget.tripListBack!.isNotEmpty
                                                                            ? widget
                                                                                .tripListBack!.first.accessDate!
                                                                            : now
                                                                        : selectedDate = widget.tripList.isNotEmpty
                                                                            ? widget.tripList.first.accessDate!
                                                                            : now;
                                                                  });
                                                                }
                                                              });

                                                              UmraDetails.swatransportList!.add(TransportList(
                                                                  availability: widget
                                                                      .tripList[
                                                                          index]
                                                                      .emptySeat,
                                                                  busId: widget
                                                                      .tripList[
                                                                          index]
                                                                      .busId,
                                                                  from: widget
                                                                      .tripList[
                                                                          index]
                                                                      .fromCityName,
                                                                  fromStationName: widget
                                                                      .tripList[
                                                                          index]
                                                                      .from,
                                                                  to: widget
                                                                      .tripList[
                                                                          index]
                                                                      .toCityName,
                                                                  isActive:
                                                                      true,
                                                                  isDelete: widget
                                                                      .tripList[
                                                                          index]
                                                                      .isDeleted,
                                                                  isAddedTrip:
                                                                      true,
                                                                  lineId: widget
                                                                      .tripList[
                                                                          index]
                                                                      .lineId,
                                                                  notes: '',
                                                                  priceSeat: widget
                                                                      .tripList[
                                                                          index]
                                                                      .price,
                                                                  toStationName: widget
                                                                      .tripList[
                                                                          index]
                                                                      .to,
                                                                  tripDate: '${intl.DateFormat.d('en_US').format(widget.tripList[index].accessDate!)}${intl.DateFormat.MMM('en_US').format(widget.tripList[index].accessDate!)}',
                                                                  isreserved: false,
                                                                  tripId: widget.tripList[index].tripId,
                                                                  personCountReserved: 0,
                                                                  serviceTypeId: widget.tripList[index].serviceTypeId,
                                                                  tripTime: widget.tripList[index].accessBusTime.toString(),
                                                                  fromStationId: null,
                                                                  toStationId: null,
                                                                  tripUmrahTransportationId: null,
                                                                  reservationId: null));
                                                            },
                                                            child: Container(
                                                              height: 30.sp,
                                                              width: LanguageClass
                                                                      .isEnglish
                                                                  ? 60.sp
                                                                  : 48.sp,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: AppColors
                                                                          .white,
                                                                      offset:
                                                                          Offset(0,
                                                                              0),
                                                                      spreadRadius:
                                                                          0,
                                                                      blurRadius:
                                                                          8)
                                                                ],
                                                                color:
                                                                    _primaryColor,
                                                                // gradient:
                                                                // const LinearGradient(
                                                                //     colors: [
                                                                //   Color(
                                                                //       0xfffd634f),
                                                                //   Color(
                                                                //       0xffff9976),
                                                                // ]),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  LanguageClass
                                                                          .isEnglish
                                                                      ? 'Book'
                                                                      : 'Ø­Ø¬Ø²',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      fontStyle(
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .medium,
                                                                    fontSize:
                                                                        10.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => SizedBox(
                                height: 10,
                              ),
                            ),
                          ),

                    (widget.tripTypeId == '2' &&
                            Ticketreservation.Seatsnumbers1.isNotEmpty)
                        ? Expanded(
                            flex: selectedback.isEven ? 7 : 1,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: widget.tripListBack?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedback == index
                                              ? selectedback = -1
                                              : selectedback = index;
                                        });
                                      },
                                      child: Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            borderRadius: selectedback != index
                                                ? BorderRadius.circular(10)
                                                : BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                            color: AppColors.white
                                            // color: Color(0xffF3F3F3)
                                            ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10.0),
                                        // padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (widget.tripListBack?[index]
                                                    .IsSPonsored ==
                                                true)
                                              Container(
                                                decoration: BoxDecoration(
                                                  // gradient: const LinearGradient(
                                                  //   colors: [
                                                  //     Color(0xfffd634f),
                                                  //     Color(0xffff9976),
                                                  //   ],
                                                  // ),
                                                  color: _primaryColor,
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          LanguageClass
                                                                  .isEnglish
                                                              ? "Enjoy for less with ${widget.tripListBack?[index].companyName}"
                                                              : "Ø§Ø³ØªÙ…ØªØ¹ Ø¨ØªÙƒÙ„ÙØ© Ø£Ù‚Ù„ Ù…Ø¹ Ø­Ø§ÙÙ„Ø§Øª ${widget.tripListBack?[index].companyName}",
                                                          style: fontStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .bold,
                                                              fontSize: 12.sp),
                                                        ),
                                                        Text(
                                                          LanguageClass
                                                                  .isEnglish
                                                              ? "Unbeatable trips deals with ${widget.tripListBack?[index].companyName}! "
                                                              : "Ø¹Ø±ÙˆØ¶ Ø±Ø­Ù„Ø§Øª Ù„Ø§ ØªÙØ¶Ø§Ù‡Ù‰ Ù…Ø¹ ${widget.tripListBack?[index].companyName}!",
                                                          style: fontStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .regular,
                                                              fontSize: 10.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      LanguageClass.isEnglish
                                                          ? "Sponsored"
                                                          : "Ù…Ù…ÙˆÙ„",
                                                      style: fontStyle(
                                                          color: Colors.white,
                                                          fontFamily: FontFamily
                                                              .regular,
                                                          fontSize: 12.sp),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            // todo : logo and provider name
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 6),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height: 38,
                                                        width: 38,
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: _primaryColor,
                                                        ),
                                                        child: Image.network(
                                                            // "https://play-lh.googleusercontent.com/hN3av1FyuynMPnXhnQsLh3DBPlIki4cxAoO77stXaNjS5PQ0GIBsP1IO4uY6hXWJRw=w480-h960-rw",
                                                            widget.tripListBack![index].logo ==
                                                                        null ||
                                                                    widget
                                                                            .tripListBack![
                                                                                index]
                                                                            .logo ==
                                                                        ""
                                                                ? "https://play-lh.googleusercontent.com/ACfnkQHBH_KBNpqhaU2PkbNp1mcLeZtaOHHvKTSDHBEOD43QH9gB9nd5GQkWpfB9n7M=w480-h960-rw"
                                                                : widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .logo!),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        widget
                                                                .tripListBack?[
                                                                    index]
                                                                .companyName ??
                                                            (LanguageClass
                                                                    .isEnglish
                                                                ? "Swa"
                                                                : "Ø³ÙˆØ§"),
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 12.sp),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: _primaryColor,
                                                        // color: Color(0xffFC9900),
                                                        size: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        "4.5",
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            height: 0,
                                                            fontSize: 12.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Expanded(
                                                    flex: 3,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      spacing: 10,
                                                      children: [
                                                        if (widget
                                                                .tripList[index]
                                                                .IsCheapeast ==
                                                            true)
                                                          Card(
                                                            margin:
                                                                EdgeInsets.zero,
                                                            elevation: 0.0,
                                                            color: Color(
                                                                0xff381213),
                                                            // color: Color(0xff05488F),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6),
                                                              bottomLeft: Radius
                                                                  .circular(6),
                                                            )),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6.0,
                                                                      vertical:
                                                                          2),
                                                              child: Center(
                                                                  child: Text(
                                                                "Cheapest",
                                                                style: fontStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                            ),
                                                          ),
                                                        if (widget
                                                                .tripList[index]
                                                                .IsBestValue ==
                                                            true)
                                                          Card(
                                                            margin:
                                                                EdgeInsets.zero,
                                                            elevation: 0.0,
                                                            color:
                                                                _primaryColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          6),
                                                              bottomLeft: Radius
                                                                  .circular(6),
                                                            )),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6.0,
                                                                      vertical:
                                                                          2),
                                                              child: Center(
                                                                  child: Text(
                                                                "Best Value",
                                                                style: fontStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                            ),
                                                          ),
                                                        SizedBox(
                                                          width: 0,
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                            // todo : details from to
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 5,
                                                    children: [
                                                      Text(
                                                        widget
                                                                .tripListBack?[
                                                                    index]
                                                                .from! ??
                                                            "",
                                                        style: fontStyle(
                                                            color: Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        intl.DateFormat(
                                                                'hh:mm a')
                                                            .format(widget
                                                                .tripListBack![
                                                                    index]
                                                                .accessDate!)
                                                            .toString(),
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        intl.DateFormat(
                                                                'dd MMMM yyyy',
                                                                LanguageClass
                                                                        .isEnglish
                                                                    ? 'en'
                                                                    : 'ar')
                                                            .format(widget
                                                                .tripListBack![
                                                                    index]
                                                                .accessDate!)
                                                            .toString(),
                                                        style: fontStyle(
                                                            // color: Color(
                                                            //     0xff858585),
                                                            color: Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 7.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  RotatedBox(
                                                    quarterTurns:
                                                        LanguageClass.isEnglish
                                                            ? 90
                                                            : 90,
                                                    child: Stack(
                                                      // alignment: Alignment.centerLeft,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 1,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  right: 10,
                                                                  left: 10,
                                                                  bottom: 5),
                                                          color:
                                                              Color(0xff000000),
                                                          // child: Icon(
                                                          //   Icons.arrow_right_alt_rounded,
                                                          //   size: 30,
                                                          // ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 2.3,
                                                            right: LanguageClass
                                                                    .isEnglish
                                                                ? 0
                                                                : 2,
                                                            left: LanguageClass
                                                                    .isEnglish
                                                                ? 2
                                                                : 0,
                                                          ),
                                                          child: Icon(
                                                            LanguageClass.isEnglish
                                                                ? Icons
                                                                    .keyboard_arrow_left_rounded
                                                                : Icons
                                                                    .keyboard_arrow_right_rounded,
                                                            size: 15.5,
                                                            color: Color(
                                                                0xff000000),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 5,
                                                    children: [
                                                      Text(
                                                        widget
                                                                .tripListBack?[
                                                                    index]
                                                                .to! ??
                                                            "",
                                                        style: fontStyle(
                                                            color: Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        intl.DateFormat(
                                                                'hh:mm a')
                                                            .format(widget
                                                                .tripListBack![
                                                                    index]
                                                                .arrivalDate!)
                                                            .toString(),
                                                        style: fontStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                FontFamily
                                                                    .medium,
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        intl.DateFormat(
                                                                'dd MMMM yyyy',
                                                                LanguageClass
                                                                        .isEnglish
                                                                    ? 'en'
                                                                    : 'ar')
                                                            .format(widget
                                                                .tripListBack![
                                                                    index]
                                                                .arrivalDate!),
                                                        style: fontStyle(
                                                            color: Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                FontFamily
                                                                    .regular,
                                                            fontSize: 7.sp),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      spacing: 5,
                                                      children: [
                                                        Text(
                                                          '${widget.tripListBack?[index].price.toString()} ${Routes.curruncy ?? ""}',
                                                          style: fontStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .medium,
                                                              fontSize: 12.sp),
                                                        ),
                                                        Row(
                                                          spacing: 5,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            0.0),
                                                                child:
                                                                    Image.asset(
                                                                  height: 20,
                                                                  width: 20,
                                                                  "assets/images/img_1.png",
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .high,
                                                                )),
                                                            Text(
                                                              LanguageClass
                                                                      .isEnglish
                                                                  ? '${widget.tripListBack?[index].emptySeat}'
                                                                  : '${widget.tripListBack?[index].emptySeat}',
                                                              style: fontStyle(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                          ],
                                                        ),
                                                        8.verticalSpace,
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    selectedback == index
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                // color: Color(0xffF3F3F3),
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                )),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                    // height: 230,
                                                    width: double.infinity,
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      fit: StackFit.loose,
                                                      children: [
                                                        widget.tripListBack![index]
                                                                    .imageMap ==
                                                                null
                                                            ? Image.asset(
                                                                "assets/images/img.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                widget
                                                                    .tripListBack![
                                                                        index]
                                                                    .imageMap!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                        SizedBox(
                                                          height: 90,
                                                          width:
                                                              double.infinity,
                                                          child: ListView
                                                              .separated(
                                                            shrinkWrap: true,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context, i) =>
                                                                    Container(
                                                              height: 90,
                                                              width: 120,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .white,
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                // image:
                                                                //     DecorationImage(
                                                                //   image: NetworkImage(widget
                                                                //           .tripListBack?[
                                                                //               index]
                                                                //           .BusPhotos?[
                                                                //               i]
                                                                //           .toString() ??
                                                                //       ""),
                                                                //   fit: BoxFit
                                                                //       .cover,
                                                                // )
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: Image
                                                                    .network(
                                                                  widget
                                                                          .tripListBack?[
                                                                              index]
                                                                          .BusPhotos?[
                                                                              i]
                                                                          .toString() ??
                                                                      "",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  loadingBuilder:
                                                                      (context,
                                                                          child,
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    }
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                        color: AppColors
                                                                            .greyLight,
                                                                      ),
                                                                    );
                                                                  },
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .red);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            separatorBuilder:
                                                                (context,
                                                                        index) =>
                                                                    SizedBox(
                                                              width: 10,
                                                            ),
                                                            itemCount: widget
                                                                    .tripListBack?[
                                                                        index]
                                                                    .BusPhotos
                                                                    ?.length ??
                                                                0,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                    //     MapRouteWidget(
                                                    //   routePoints: [
                                                    //     // LatLng(30.0444, 31.2357),
                                                    //     // LatLng(31.2001, 29.9187),
                                                    //     LatLng(30.0, 31.0),
                                                    //     LatLng(31.0, 30.0),
                                                    //   ],
                                                    //   googleApiKey:
                                                    //       'AIzaSyAipdrKwqPfmyfmzhZG1PZJJ8J61SM14i8',
                                                    //   useDirections: true,
                                                    // )
                                                    ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        0),
                                                            child: ListView
                                                                .builder(
                                                              itemCount: widget
                                                                  .tripList[
                                                                      index]
                                                                  .lineCity
                                                                  .length,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  ScrollPhysics(),
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index2) {
                                                                final date = now
                                                                    .add(Duration(
                                                                        days:
                                                                            index2));
                                                                final time = intl
                                                                    .DateFormat(
                                                                  'h:mm a',
                                                                  LanguageClass
                                                                          .isEnglish
                                                                      ? 'en'
                                                                      : 'ar',
                                                                ).format(date.add(
                                                                    Duration(
                                                                        hours:
                                                                            index2)));
                                                                return Container(
                                                                  // padding: EdgeInsets.all(10),
                                                                  // color: Color(
                                                                  //     0xffF3F3F3),
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  child: Row(
                                                                    // mainAxisAlignment:
                                                                    //     MainAxisAlignment
                                                                    //         .spaceBetween,

                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            70,
                                                                        child:
                                                                            Text(
                                                                          // '${widget.tripList[index].lineCity[index2].lineStationList.first.accessTime!.split(':')[0]}:${widget.tripList[index].lineCity[index2].lineStationList.first.accessTime!.split(':')[1]}' ??
                                                                          time,
                                                                          style: fontStyle(
                                                                              color: AppColors.blackColor,
                                                                              fontFamily: FontFamily.medium,
                                                                              height: 0.5,
                                                                              fontSize: 12.sp),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                13,
                                                                            width:
                                                                                13,
                                                                            alignment:
                                                                                Alignment.center,
                                                                            padding: index2 == 0
                                                                                ? EdgeInsets.all(1.2)
                                                                                : EdgeInsets.zero,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(
                                                                                style: BorderStyle.solid,
                                                                                color: index2 == 0
                                                                                    ? _primaryColor
                                                                                    // ? Color(0xff007663)
                                                                                    : Colors.transparent,
                                                                                width: index2 == 0 ? 1 : 0.0,
                                                                              ),
                                                                            ),
                                                                            child: index2 == widget.tripListBack![index].lineCity.length - 1
                                                                                ? Icon(
                                                                                    CupertinoIcons.location_solid,
                                                                                    size: 15,
                                                                                    color: Color(0xff7700FF),
                                                                                  )
                                                                                : Container(
                                                                                    height: 11,
                                                                                    width: 11,
                                                                                    decoration: BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                    child: Icon(
                                                                                      Icons.circle,
                                                                                      size: 4,
                                                                                      color: Colors.white,
                                                                                    )),
                                                                          ),
                                                                          index2 == widget.tripListBack![index].lineCity.length - 1
                                                                              ? SizedBox.shrink()
                                                                              : Container(
                                                                                  height: 20,
                                                                                  width: 1.1,
                                                                                  color: AppColors.blackColor,
                                                                                )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        '${widget.tripListBack![index].lineCity[index2].cityName}' ??
                                                                            '',
                                                                        style: fontStyle(
                                                                            color: AppColors
                                                                                .blackColor,
                                                                            fontFamily: FontFamily
                                                                                .bold,
                                                                            decoration: index2 == 0
                                                                                ? TextDecoration.underline
                                                                                : TextDecoration.none,
                                                                            height: 0.5,
                                                                            fontSize: 12.sp),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 25,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                            child: Text(
                                                              'Premuim â€¢ AC â€¢ Bus',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: fontStyle(
                                                                color: Color(
                                                                    0xff888888),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontFamily:
                                                                    FontFamily
                                                                        .regular,
                                                                fontSize: 9.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        SizedBox(
                                                          height:
                                                              sizeHeight * 0.07,
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (Ticketreservation
                                                                  .Seatsnumbers1
                                                                  .isNotEmpty) {
                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'numberTrip2',
                                                                    value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .tripNumber);
                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'elite2',
                                                                    value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .serviceType);
                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'accessBusDate2',
                                                                    value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .accessDate
                                                                        .toString());

                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'arrivalDate2',
                                                                    value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .arrivalDate
                                                                        .toString());
                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'accessBusTime2',
                                                                    value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .accessBusTime);
                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'lineName2',
                                                                    value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .lineName);
                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'tripOneId',
                                                                    value: widget
                                                                            .tripListBack![index]
                                                                            .tripId ??
                                                                        0);

                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'tripRoundId',
                                                                    value: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .tripId
                                                                        .toString());

                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'lineid2',
                                                                    value: widget
                                                                            .tripListBack![index]
                                                                            .lineId ??
                                                                        0);

                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'serviceTypeID2',
                                                                    value: widget
                                                                            .tripListBack![index]
                                                                            .serviceTypeId ??
                                                                        0);

                                                                CacheHelper.setDataToSharedPref(
                                                                    key:
                                                                        'busId2',
                                                                    value: widget
                                                                            .tripListBack![index]
                                                                            .busId ??
                                                                        0);

                                                                UmraDetails.swatransportList!.add(TransportList(
                                                                    availability: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .emptySeat,
                                                                    busId: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .busId,
                                                                    from: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .fromCityName,
                                                                    fromStationName: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .from,
                                                                    to: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .toCityName,
                                                                    isActive:
                                                                        true,
                                                                    isDelete: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .isDeleted,
                                                                    isAddedTrip:
                                                                        true,
                                                                    lineId: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .lineId,
                                                                    notes: '',
                                                                    priceSeat: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .price,
                                                                    toStationName: widget
                                                                        .tripListBack![
                                                                            index]
                                                                        .to,
                                                                    tripDate:
                                                                        '${intl.DateFormat.d('en_US').format(widget.tripListBack![index].accessDate!)}${intl.DateFormat.MMM('en_US').format(widget.tripListBack![index].accessDate!)}',
                                                                    isreserved: false,
                                                                    tripId: widget.tripListBack![index].tripId,
                                                                    personCountReserved: 0,
                                                                    serviceTypeId: widget.tripListBack![index].serviceTypeId,
                                                                    tripTime: widget.tripListBack![index].accessBusTime.toString(),
                                                                    fromStationId: null,
                                                                    toStationId: null,
                                                                    tripUmrahTransportationId: null,
                                                                    reservationId: null));
                                                                var bookModel =
                                                                    BookingModel(
                                                                  departureCompanyLogo:
                                                                      logoGo,
                                                                  departureCompanyName:
                                                                      companyGo,
                                                                  returnCompanyLogo: widget
                                                                      .tripListBack?[
                                                                          index]
                                                                      .logo,
                                                                  returnCompanyName: widget
                                                                      .tripListBack?[
                                                                          index]
                                                                      .companyName,
                                                                );
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          MultiBlocProvider(
                                                                              providers: [
                                                                                BlocProvider<LoginCubit>(create: (context) => sl<LoginCubit>()),
                                                                                BlocProvider<TimesTripsCubit>(
                                                                                  create: (context) => TimesTripsCubit(),
                                                                                ),
                                                                                BlocProvider<BusLayoutCubit>(
                                                                                  create: (context) => BusLayoutCubit(),
                                                                                )
                                                                              ],
                                                                              // Replace with your actual cubit creation logic
                                                                              child: BusLayoutScreenBack(
                                                                                isedit: false,
                                                                                bookingModel: bookModel,
                                                                                arrivaltime: widget.tripListBack?[index].arrivalDate,
                                                                                busdate: widget.tripListBack![index].accessDate,
                                                                                busttime: widget.tripListBack![index].accessBusTime,
                                                                                to: widget.tripListBack![index].to ?? "",
                                                                                from: widget.tripListBack![index].from ?? "",
                                                                                triTypeId: widget.tripTypeId,
                                                                                price: widget.tripListBack![index].price!,
                                                                                user: Routes.user,
                                                                                discount: widget.tripListBack![index].discount,
                                                                                tripId: widget.tripListBack![index].tripId!,
                                                                                tocity: widget.tripListBack![index].toCityName ?? '',
                                                                                fromcity: widget.tripListBack![index].fromCityName ?? '',
                                                                              ))),
                                                                ).then((value) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              } else {
                                                                Constants.showDefaultSnackBar(
                                                                    context:
                                                                        context,
                                                                    text: LanguageClass
                                                                            .isEnglish
                                                                        ? "Please reserve go trip first"
                                                                        : "Ø¨Ø±Ø¬Ø§Ø¡ Ø§Ø®ØªÙŠØ§Ø± Ø±Ø­Ù„Ø© Ø°Ù‡Ø§Ø¨ Ø§ÙˆÙ„Ø§Ù‹");
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 30.sp,
                                                              width: LanguageClass
                                                                      .isEnglish
                                                                  ? 60.sp
                                                                  : 48.sp,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: AppColors
                                                                          .white,
                                                                      offset:
                                                                          Offset(0,
                                                                              0),
                                                                      spreadRadius:
                                                                          0,
                                                                      blurRadius:
                                                                          8)
                                                                ],
                                                                color:
                                                                    _primaryColor,
                                                                // gradient:
                                                                //     const LinearGradient(
                                                                //         colors: [
                                                                //       Color(
                                                                //           0xfffd634f),
                                                                //       Color(
                                                                //           0xffff9976),
                                                                //     ]),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  LanguageClass
                                                                          .isEnglish
                                                                      ? 'Book'
                                                                      : 'Ø­Ø¬Ø²',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      fontStyle(
                                                                    color: AppColors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .medium,
                                                                    fontSize:
                                                                        12.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => SizedBox(
                                height: 10,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    // todo :  button action next confirm
                    Ticketreservation.Seatsnumbers2.isNotEmpty &&
                            Ticketreservation.Seatsnumbers1.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlocProvider<LoginCubit>(
                                          create: (context) => sl<LoginCubit>(),
                                          child: ReservationTicket(
                                            tripTypeId: "2",
                                            actualDiscount:
                                                Ticketreservation.discount * 2,
                                            user: Routes.user,
                                          )),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              alignment: Alignment.centerRight,
                              height: 50,
                              //padding:  EdgeInsets.symmetric(horizontal: 10,vertical:20),
                              //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(41)),
                              child: Center(
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? "Continue"
                                      : "Ø§Ø³ØªÙ…Ø±",
                                  style: fontStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.sp),
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                PositionedDirectional(
                  top: 4,
                  start: 10,
                  child: _buildFilterToggleButton(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: UmraDetails.isbusforumra
          ? SizedBox()
          : Navigationbottombar(
              currentIndex: 0,
            ),
    );
  }

  void _handleFilterListState(TimesTripsStates state) {
    if (state is LoadedRecommendedList &&
        state.recommendedModel.status != "failed") {
      final items = state.recommendedModel.message ?? [];
      setState(() {
        _recommendedFilterItems
          ..clear()
          ..addAll(items.map((e) => LanguageClass.isEnglish
              ? e.textEn.toString()
              : e.textAr.toString()));
        _recommendedFilterIds
          ..clear()
          ..addEntries(items.map((e) => MapEntry(
                LanguageClass.isEnglish
                    ? e.textEn.toString()
                    : e.textAr.toString(),
                e.id,
              )));
      });
    } else if (state is LoadedCompaniesList &&
        state.compaiesModel.status != "failed") {
      final items = state.compaiesModel.message ?? [];
      setState(() {
        _companyFilterItems
          ..clear()
          ..addAll(items.map((e) => e.Name.toString()));
        _companyFilterIds
          ..clear()
          ..addEntries(
              items.map((e) => MapEntry(e.Name.toString(), e.CompanyID)));
      });
    }
  }

  Widget _buildFilterToggleButton() {
    return InkWell(
      onTap: () {
        final willShowFilters = !_showFilters;
        setState(() {
          _showFilters = willShowFilters;
        });
        if (willShowFilters) {
          _scrollSelectedDayToCenter();
        }
      },
      borderRadius: BorderRadius.circular(22),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        scale: _showFilters ? 1.08 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: _showFilters ? _primaryColor : AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            turns: _showFilters ? -0.12 : 0,
            child: Icon(
              _showFilters ? Icons.filter_alt_off : Icons.filter_list,
              color: _showFilters ? AppColors.white : AppColors.blackColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTimesTripsState(BuildContext context, TimesTripsStates state) {
    _handleFilterListState(state);

    if (state is LoadingTimesTrips) {
      Constants.showLoadingDialog(context);
    } else if (state is LoadedTimesTrips) {
      Constants.hideLoadingDialog(context);

      timeSlotsGo = state.timesTripsResponse.message?.timeSlotsGo;
      timeSlotsBack = state.timesTripsResponse.message?.timeSlotsBack;
      print("${state.timesTripsResponse.message!.tripList.length} list");
      print(
          "${state.timesTripsResponse.message!.tripListBack.length} back list");

      if (state.timesTripsResponse.message!.tripList.isNotEmpty) {
        setState(() {
          _keepSelectedDayVisible();
          widget.tripList = state.timesTripsResponse.message!.tripList;

          widget.tripTypeId = '1';
          if (widget.tripTypeId == '1') {
            widget.tripListBack?.clear();
            widget.tripTypeId = '1';
          }
          print(widget.tripTypeId.toString());
          if (state.timesTripsResponse.message!.tripListBack.isNotEmpty) {
            widget.tripTypeId = '2';
            widget.tripListBack =
                state.timesTripsResponse.message!.tripListBack;
          }
        });

        Reservationtimer.stoptimer();

        Ticketreservation.Seatsnumbers1.clear();
        Ticketreservation.Seatsnumbers2.clear();
      } else {
        setState(() {
          _keepSelectedDayVisible();
          widget.tripList.clear();
          widget.tripListBack?.clear();
          timeSlotsGo = state.timesTripsResponse.message?.timeSlotsGo;
          timeSlotsBack = state.timesTripsResponse.message?.timeSlotsBack;
        });
        Constants.showDefaultSnackBar(
          context: context,
          text: LanguageClass.isEnglish
              ? "No trips in this date"
              : "Ã™â€žÃ˜Â§ Ã™Å Ã™Ë†Ã˜Â¬Ã˜Â¯ Ã™â€¦Ã™Ë†Ã˜Â§Ã˜Â¹Ã™Å Ã˜Â¯ Ã™ÂÃ™Å  Ã™â€¡Ã˜Â°Ã˜Â§ Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â¹Ã˜Â¯",
        );
      }
    } else if (state is ErrorTimesTrips) {
      widget.tripList.clear();
      setState(() {});
      Constants.hideLoadingDialog(context);
      Constants.showDefaultSnackBar(context: context, text: state.msg);
    }
  }

  final now = DateTime.now();
  int selectedIndex = 0;

  Widget _buildTimeWidget(String day, String time) {
    final locale = LanguageClass.isEnglish ? 'en' : 'ar';
    List<TimeSlots>? times = _isShowingBackTrips ? timeSlotsBack : timeSlotsGo;

    return SizedBox(
      height: 30,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: times!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final date = widget.tripList.length > 0
              ? widget.tripList.first.accessDate!.add(Duration(days: index))
              : now.add(Duration(days: index));

          final fromTime = intl.DateFormat(
            'h a',
            locale,
          ).format(date.add(Duration(hours: index))).toLowerCase();
          final toTime = intl.DateFormat(
            'h a',
            locale,
          ).format(date.add(Duration(hours: index + 1))).toLowerCase();

          final isSelected = selectedIndex == index;
          final start = intl.DateFormat(
            'HH',
            locale,
          ).format(
            date.add(Duration(hours: index)),
          );

          final end = intl.DateFormat(
            'HH',
            locale,
          ).format(date.add(Duration(hours: index + 1))).toLowerCase();

          return times[index].hasTrips == true
              ? GestureDetector(
                  onTap: () {
                    startTime = times[index].startTime;
                    endTime = times[index].endTime;
                    _fetchTripsForSelectedDay();
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 0,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //   child: Text(
                        //     dayText,
                        //     style: fontStyle(
                        //         fontSize: 10.sp,
                        //         color: const Color(0xff383838),
                        //         // fontWeight: FontWeight.w800,
                        //         fontFamily: FontFamily.regular),
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(
                            left: (LanguageClass.isEnglish) ? 10 : 0,
                            right: (LanguageClass.isEnglish) ? 0 : 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: isSelected
                                ? _primaryColor
                                : const Color(0xfff3f3f3),
                            // color: isSelected ? null : const Color(0xfff3f3f3),
                            // gradient: isSelected
                            //     ? const LinearGradient(
                            //         colors: [
                            //           Color(0xfffd634f),
                            //           Color(0xffff9976),
                            //         ],
                            //       )
                            //     : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${times[index].display}',
                                textDirection: locale == 'ar'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                style: fontStyle(
                                  fontSize: 8.sp,
                                  fontFamily: FontFamily.regular,
                                  fontWeight: FontWeight.w700,
                                  color: times[index].hasTrips == true
                                      ? isSelected
                                          ? Colors.white
                                          : Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox();
        },
      ),
    );
  }

  void _changeDay(int value) {
    _selectDay(selectedDate.add(Duration(days: value)));
    _scrollSelectedDayToCenter();
    _fetchTripsForSelectedDay();
  }

  void _selectDay(DateTime date) {
    final locale = LanguageClass.isEnglish ? 'en' : 'ar';

    setState(() {
      selectedDate = date;
      selectedIndexDay = intl.DateFormat('EEE, d MMM', locale).format(date);

      DateGo = intl.DateFormat(
        'yyyy-MM-dd',
        locale,
      ).format(date);

      DateBack = intl.DateFormat(
        'yyyy-MM-dd',
        locale,
      ).format(date);
    });
  }

  void _keepSelectedDayVisible() {
    final locale = LanguageClass.isEnglish ? 'en' : 'ar';
    selectedIndexDay =
        intl.DateFormat('EEE, d MMM', locale).format(selectedDate);
  }

  void _clearRecommendedFilter() {
    if (recommendedvalue == null && recommendeID == null) return;

    setState(() {
      recommendedvalue = null;
      recommendeID = null;
      isRecommended = false;
    });
    _fetchTripsForSelectedDay();
  }

  void _clearCompanyFilter() {
    if (companeyvalue == null && companyID == null) return;

    setState(() {
      companeyvalue = null;
      companyID = null;
      showCompanies = false;
    });
    _fetchTripsForSelectedDay();
  }

  void _fetchTripsForSelectedDay() {
    _timesTripsCubit.getTimes(
      tripType: _hasBackTrips ? "2" : widget.tripTypeId.toString(),
      fromStationID: _isShowingBackTrips
          ? widget.toStationID.toString()
          : widget.fromStationID.toString(),
      toStationID: _isShowingBackTrips
          ? widget.fromStationID.toString()
          : widget.toStationID.toString(),
      dateGo: _isShowingBackTrips ? DateBack : DateGo,
      dateBack: _isShowingBackTrips ? DateGo : DateBack,
      startTime: startTime,
      endTime: endTime,
      companeyid: companyID,
      recommendeID: recommendeID,
    );
  }

  Widget _buildDayWidget() {
    final locale = LanguageClass.isEnglish ? 'en' : 'ar';

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          /// Previous Button
          IconButton(
            onPressed: () => _changeDay(-1),
            icon: const Icon(Icons.chevron_left),
          ),

          /// Days List
          Expanded(
            child: ListView.builder(
              controller: _dayScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: 11,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final date = selectedDate.add(
                  Duration(days: index - 5),
                );

                final isSelected = date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;

                final dayText =
                    intl.DateFormat('EEE, d MMM', locale).format(date);

                return GestureDetector(
                  onTap: () {
                    _selectDay(date);
                    _scrollSelectedDayToCenter();
                    _fetchTripsForSelectedDay();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: isSelected ? 105 : 90,
                        margin: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: isSelected ? 6 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _primaryColor
                              : const Color(0xffF3F3F3),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _primaryColor.withOpacity(0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: isSelected ? 1.05 : 0.95,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayText,
                                style: TextStyle(
                                  fontSize: isSelected ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// Next Button
          IconButton(
            onPressed: () => _changeDay(1),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  // Widget _buildDayWidget(String day, String time) {
  //   return SizedBox(
  //     height: 50,
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         /// Previous days button
  //         IconButton(
  //           onPressed: () {
  //             setState(() {
  //               startOffset--;
  //             });
  //           },
  //           icon: const Icon(Icons.chevron_left),
  //         ),

  //         /// Days list
  //         Expanded(
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             controller: _dayScrollController,
  //             itemCount: 10,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (context, index) {
  //               DateTime date;

  //               Ticketreservation.Seatsnumbers1.isNotEmpty
  //                   ? date = widget.tripListBack!.isNotEmpty
  //                       ? widget.tripListBack!.first.accessDate!
  //                           .add(Duration(days: startOffset + index))
  //                       : now.add(Duration(days: startOffset + index))
  //                   : date = widget.tripList.isNotEmpty
  //                       ? widget.tripList.first.accessDate!
  //                           .add(Duration(days: startOffset + index))
  //                       : now.add(Duration(days: startOffset + index));

  //               final dayText = intl.DateFormat(
  //                 'EEE, d MMM',
  //                 LanguageClass.isEnglish ? 'en' : 'ar',
  //               ).format(date);

  //               final fromTime = intl.DateFormat(
  //                 'h a',
  //                 LanguageClass.isEnglish ? 'en' : 'ar',
  //               ).format(date.add(Duration(hours: index))).toLowerCase();

  //               final toTime = intl.DateFormat(
  //                 'h a',
  //                 LanguageClass.isEnglish ? 'en' : 'ar',
  //               ).format(date.add(Duration(hours: index + 1))).toLowerCase();

  //               final isSelected = selectedIndexDay == dayText;

  //               return GestureDetector(
  //                 onTap: () {
  //                   setState(() {
  //                     selectedIndexDay = dayText;

  //                     DateGo = intl.DateFormat(
  //                       'yyyy-MM-dd',
  //                       LanguageClass.isEnglish ? 'en' : 'ar',
  //                     ).format(date);

  //                     DateBack = intl.DateFormat(
  //                       'yyyy-MM-dd',
  //                       LanguageClass.isEnglish ? 'en' : 'ar',
  //                     ).format(date);

  //                     context.read<TimesTripsCubit>().getTimes(
  //                           tripType: widget.tripTypeId.toString(),
  //                           fromStationID: widget.fromStationID.toString(),
  //                           toStationID: widget.toStationID.toString(),
  //                           dateGo: DateGo,
  //                           dateBack: DateBack,
  //                           startTime: startTime,
  //                           endTime: endTime,
  //                           companeyid: companyID,
  //                           recommendeID: recommendeID,
  //                         );
  //                   });
  //                 },
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     AnimatedContainer(
  //                       duration: const Duration(milliseconds: 200),
  //                       width: 90,
  //                       margin: EdgeInsets.only(
  //                         left: (LanguageClass.isEnglish) ? 10 : 0,
  //                         right: (LanguageClass.isEnglish) ? 0 : 20,
  //                       ),
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 14,
  //                         vertical: 0,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(15),
  //                         color: isSelected
  //                             ? _primaryColor
  //                             : const Color(0xfff3f3f3),
  //                       ),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             dayText,
  //                             textDirection: LanguageClass.isEnglish
  //                                 ? TextDirection.rtl
  //                                 : TextDirection.ltr,
  //                             style: fontStyle(
  //                               fontSize: 8.sp,
  //                               fontFamily: FontFamily.regular,
  //                               fontWeight: FontWeight.w700,
  //                               color: isSelected ? Colors.white : Colors.black,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 4),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),

  //         /// Next days button
  //         IconButton(
  //           onPressed: () {
  //             setState(() {
  //               startOffset++;
  //             });
  //           },
  //           icon: const Icon(Icons.chevron_right),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFilterCard({
  //   required VoidCallback onTap,
  //   required IconData icon,
  //   required String title,
  //   bool iconCustom = false,
  //   Widget? widget,
  //   Color? iconColor,
  //   EdgeInsetsGeometry? padding,
  //   TextStyle? textStyle,
  // }) {
  //   return SizedBox(
  //     height: 40,
  //     child: GestureDetector(
  //       onTap: onTap,
  //       child: Card(
  //         elevation: 0.0,
  //         // color: Color(0xfff3f3f3),
  //         color: AppColors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(6),
  //         ),
  //         child: Padding(
  //           padding: padding ??
  //               const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             spacing: 3,
  //             children: [
  //               if (iconCustom) widget ?? SizedBox.shrink(),
  //               Text(
  //                 title,
  //                 style: textStyle ??
  //                     fontStyle(
  //                         color: Color(0xff717171),
  //                         fontFamily: FontFamily.regular,
  //                         fontSize: 12.sp),
  //               ),
  //               (iconCustom)
  //                   ? SizedBox.shrink()
  //                   : Icon(
  //                       icon,
  //                       color: iconColor ?? AppColors.blackColor,
  //                       size: 15,
  //                     ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCachedCompanyFilterCard() {
    return _buildFilterCard(
      onTap: () {},
      isRadiusActive: showCompanies,
      title: companeyvalue != null
          ? companeyvalue!
          : LanguageClass.isEnglish
              ? "Companies"
              : "الشركات",
      hasSelection: companeyvalue != null,
      onClearSelection: _clearCompanyFilter,
      dropdownItems: _companyFilterItems,
      onItemSelected: (p0) {
        setState(() {
          companeyvalue = p0;
        });
        companyID = _companyFilterIds[p0];
        _fetchTripsForSelectedDay();
      },
      onOpenChanged: (isOpen) {
        setState(() {
          showCompanies = isOpen;
          if (isOpen) {
            isRecommended = false;
          }
        });
      },
      icon: Icons.keyboard_arrow_down_rounded,
    );
  }

  Widget _buildFilterCard({
    required String title,
    required IconData icon,
    List<String>? dropdownItems,
    Function(dynamic)? onItemSelected,
    VoidCallback? onTap,
    bool iconCustom = false,
    Widget? widget,
    ValueChanged<bool>? onOpenChanged,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    bool isRadiusActive = false,
    bool hasSelection = false,
    VoidCallback? onClearSelection,
  }) {
    if (dropdownItems != null && dropdownItems.isNotEmpty) {
      return FilterDropdownCard(
        icon: icon,
        title: title,
        items: dropdownItems,
        onItemSelected: onItemSelected ?? (_) {},
        iconCustom: iconCustom,
        widget: widget,
        iconColor: iconColor,
        onTap: onTap,
        padding: padding,
        isOpen: isRadiusActive,
        onOpenChanged: onOpenChanged,
        textStyle: textStyle,
        hasSelection: hasSelection,
        onClearSelection: onClearSelection,
      );
    }

    return SizedBox(
      height: 40,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: (isRadiusActive == true)
                ? BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  )
                : BorderRadius.circular(6),
          ),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 3,
              children: [
                if (iconCustom) widget ?? SizedBox.shrink(),
                Text(
                  title,
                  style: textStyle ??
                      TextStyle(
                        color: Color(0xff717171),
                        fontSize: 12,
                      ),
                ),
                if (!iconCustom)
                  Expanded(
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.blackColor,
                      size: 15,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripToggleHintIcon() {
    const green = Color(0xff14A44D);

    if (!_hasBackTrips) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        child: Icon(
          Icons.sync_alt_rounded,
          color: Color(0xff717171),
          size: 15,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: AnimatedBuilder(
        animation: _roundTripHintAnimation,
        builder: (context, child) {
          final value = _roundTripHintAnimation.value;

          return Transform.scale(
            scale: 1 + (value * 0.12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.16 + (value * 0.18),
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: const BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: green.withValues(alpha: 0.25 + (value * 0.2)),
                        blurRadius: 6 + (value * 5),
                        spreadRadius: value * 1.5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sync_alt_rounded,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FilterDropdownCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  final Function(dynamic) onItemSelected;
  final bool iconCustom;
  final Widget? widget;
  final Color? iconColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final ValueChanged<bool>? onOpenChanged;
  final bool isOpen;
  final bool hasSelection;
  final VoidCallback? onClearSelection;
  const FilterDropdownCard({
    required this.icon,
    required this.title,
    required this.items,
    required this.onItemSelected,
    this.iconCustom = false,
    this.widget,
    this.iconColor,
    this.onTap,
    this.padding,
    this.textStyle,
    this.onOpenChanged,
    this.isOpen = false,
    this.hasSelection = false,
    this.onClearSelection,
  });

  @override
  State<FilterDropdownCard> createState() => _FilterDropdownCardState();
}

class _FilterDropdownCardState extends State<FilterDropdownCard> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void didUpdateWidget(covariant FilterDropdownCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isOpen && _isOpen) {
      _hideDropdown(notifyParent: false);
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
    widget.onTap?.call();
  }

  void _showDropdown() {
    if (_isOpen) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
    widget.onOpenChanged?.call(true);
  }

  void _hideDropdown({bool notifyParent = true}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }

    if (notifyParent) {
      widget.onOpenChanged?.call(false);
    }
  }

  void _clearSelection() {
    _hideDropdown();
    widget.onClearSelection?.call();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: size.width - 8.5,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(4, size.height - 3.4),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: _isOpen
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            )
                          : BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 5),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          widget.items.length + (widget.hasSelection ? 1 : 0),
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        thickness: 0.5,
                        endIndent: 10,
                        indent: 10,
                        color: Color(0xfff65702),
                        // color: Color(0xFFE0E0E0),
                      ),
                      itemBuilder: (context, index) {
                        if (widget.hasSelection && index == 0) {
                          return InkWell(
                            onTap: _clearSelection,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 7,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close_rounded,
                                    color: Color(0xfff65702),
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      LanguageClass.isEnglish
                                          ? "Clear selection"
                                          : "إلغاء الاختيار",
                                      overflow: TextOverflow.ellipsis,
                                      style: widget.textStyle ??
                                          TextStyle(
                                            color: Color(0xfff65702),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final itemIndex =
                            widget.hasSelection ? index - 1 : index;
                        return InkWell(
                          onTap: () {
                            _hideDropdown();
                            widget.onItemSelected(widget.items[itemIndex]);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 5,
                            ),
                            child: Text(
                              widget.items[itemIndex],
                              style: widget.textStyle ??
                                  TextStyle(
                                    color: Color(0xff717171),
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: 40,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: Card(
            elevation: 0.0,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(6),
              borderRadius: widget.isOpen
                  ? BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    )
                  : BorderRadius.circular(6),
            ),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.iconCustom) widget.widget ?? SizedBox.shrink(),
                  if (widget.iconCustom) SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: widget.textStyle ??
                          TextStyle(
                            color: Color(0xff717171),
                            fontSize: 12,
                          ),
                    ),
                  ),
                  SizedBox(width: 3),
                  if (widget.hasSelection && widget.onClearSelection != null)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _clearSelection,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.close_rounded,
                          color: Color(0xfff65702),
                          size: 15,
                        ),
                      ),
                    ),
                  if (widget.hasSelection && widget.onClearSelection != null)
                    SizedBox(width: 3),
                  if (!widget.iconCustom)
                    Icon(
                      _isOpen ? Icons.keyboard_arrow_up : widget.icon,
                      color: widget.iconColor ?? AppColors.blackColor,
                      size: 15,
                    ),
                  SizedBox(width: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }
}
