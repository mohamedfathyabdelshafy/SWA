import 'dart:developer';
import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:indexed/indexed.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/hex_color.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/Swa_umra/Screens/payment/Electronic_Wallet.dart';
import 'package:swa/features/Swa_umra/Screens/payment/card_payment.dart';
import 'package:swa/features/Swa_umra/Screens/payment/fawry_screen.dart';
import 'package:swa/features/Swa_umra/Screens/umra_reservation_screen/5_select_payment.dart';

import 'package:swa/features/Swa_umra/bloc/umra_bloc.dart';
import 'package:swa/features/Swa_umra/Screens/payment/fawry_screen.dart';
import 'package:swa/features/Swa_umra/models/campainlistmodel.dart';
import 'package:swa/features/Swa_umra/models/payment_type_model.dart';
import 'package:swa/features/Swa_umra/models/programs_model.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/Swa_umra/models/umral_trip_model.dart';
import 'package:swa/features/Swa_umra/repository/Umra_repository.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/payment_packages/cardpayment_packages.dart';
import 'package:swa/features/payment/wallet/data/model/my_wallet_response_model.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/sign_in/presentation/screens/login.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';

class ReservationScreen extends StatefulWidget {
  int typeid, selectedpackage;
  int? umrahReservationID;

  ReservationScreen(
      {super.key,
      required this.selectedpackage,
      required this.typeid,
      this.umrahReservationID});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen>
    with TickerProviderStateMixin {
  final UmraBloc _umraBloc = UmraBloc();

  int selectedpackage = 0;
  double transportationprice = 0;
  double programsprice = 0;
  TextEditingController _promocodetext = new TextEditingController(text: '');
  double discount = 0;
  double afterdiscount = 0;
  String promocodid = '';
  double accomidationprice = 0;
  List<ListElement>? listcampains = [];
  List<bool> checkvalueacomidation = [];
  List<bool> checkvalueTransportation = [];
  List<bool> checkvaluePrograms = [];
  bool accept = false;
  bool usewallet = false;
  double balance = 0;
  Curruncylist? curruncylist;

  double diffrence = 0;

  paymentbody? paymentpage = paymentbody(
      description: '',
      hasWalletBalance: false,
      image: 'https://api.swabus.com/Image/Payment/Card.png',
      isComingSoon: false,
      orderIndex: 1,
      pageId: 2,
      pageName: LanguageClass.isEnglish
          ? 'Debit or Credit card'
          : 'بطاقة الخصم او الائتمان');

  bool accomidatioisopen = true;
  bool transportatioisopen = true;
  bool programisopen = true;

  getwalllet() async {
    MyWalletResponseModel? wallet =
        await MyWalletRepo(sl()).getMyWallet(customerId: Routes.customerid!);
    setState(() {
      balance = wallet!.message!;
    });

    var responce = await PackagesRespo().GetallCurrency();
    if (responce is Curruncylist) {
      curruncylist = responce;
    }
  }

  calculateAccomidation() {
    accomidationprice = 0;
    UmraDetails.finalaccomidationRoom.clear();
    for (int i = 0; i < UmraDetails.accomidation!.length; i++) {
      if (checkvalueacomidation[i] == true) {
        UmraDetails.finalaccomidationRoom.add(UmraDetails.accomidationRoom[i]);

        for (int j = 0; j < UmraDetails.accomidationRoom[i].room.length; j++) {
          accomidationprice = accomidationprice +
              (UmraDetails.accomidationRoom[i].room[j].price *
                  UmraDetails.accomidationRoom[i].customernumbers[j]);
        }
      }
    }
    print(UmraDetails.finalaccomidationRoom.length);

    afterdiscount = (accomidationprice + programsprice + transportationprice);
    if (widget.umrahReservationID != null) {
      diffrence = afterdiscount - UmraDetails.totalBokkedprice;
    }
    UmraDetails.promocode = '';
    UmraDetails.promocodid = '';
    _promocodetext.text = '';
    discount = 0;
    setState(() {});
  }

  calculateprograms() {
    programsprice = 0;
    UmraDetails.finalprogramslist.clear();
    UmraDetails.finalcustomersprograms.clear();

    for (int i = 0; i < UmraDetails.umraprograms.length; i++) {
      if (checkvaluePrograms[i] == true) {
        programsprice = programsprice +
            (UmraDetails.umraprograms[i].price * UmraDetails.programsNumber[i]);

        UmraDetails.finalprogramslist.add(UmraDetails.umraprograms[i]);
        UmraDetails.finalcustomersprograms.add(UmraDetails.programsNumber[i]);
      }
    }

    print(UmraDetails.finalprogramslist.length.toString());
    afterdiscount = (accomidationprice + programsprice + transportationprice);

    if (widget.umrahReservationID != null) {
      diffrence = afterdiscount - UmraDetails.totalBokkedprice;
    }
    UmraDetails.promocode = '';
    UmraDetails.promocodid = '';
    _promocodetext.text = '';
    discount = 0;
    setState(() {});
  }

  calculateTransportation() {
    transportationprice = 0;
    UmraDetails.finaltransportation!.clear();

    for (int i = 0; i < UmraDetails.transportList!.length; i++) {
      if (checkvalueTransportation[i] == true) {
        transportationprice = transportationprice +
            UmraDetails.reservedseats.firstWhere((element) {
              return element.tripid == UmraDetails.transportList![i].tripId;
            },
                orElse: () => TransportationsSeats(
                    seatsnumber: [], totalprice: 0, tripid: 0)).totalprice;

        if (UmraDetails.reservedseats.firstWhere((element) {
              return element.tripid == UmraDetails.transportList![i].tripId;
            },
                orElse: () => TransportationsSeats(
                    seatsnumber: [], totalprice: 0, tripid: 0)).tripid ==
            UmraDetails.transportList![i].tripId) {
          UmraDetails.finaltransportation!.add(UmraDetails.transportList![i]);
        }
      }
    }

    afterdiscount = (accomidationprice + programsprice + transportationprice);
    if (widget.umrahReservationID != null) {
      diffrence = afterdiscount - UmraDetails.totalBokkedprice;
    }
    UmraDetails.promocode = '';
    UmraDetails.promocodid = '';
    _promocodetext.text = '';
    discount = 0;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedpackage = widget.selectedpackage;
    _umraBloc.add(GetCompainListEvent());
    checkvalueacomidation =
        List<bool>.filled(UmraDetails.accomidation!.length, true);
    checkvalueTransportation =
        List<bool>.filled(UmraDetails.transportList!.length, true);
    checkvaluePrograms =
        List<bool>.filled(UmraDetails.umraprograms.length, true);
    calculateAccomidation();
    calculateTransportation();
    calculateprograms();

    afterdiscount = (accomidationprice + programsprice + transportationprice);
    UmraDetails.afterdiscount = afterdiscount;

    UmraDetails.totalPriceUmrah = 0;
    UmraDetails.totlaPriceTransport = 0;
    UmraDetails.totlaPriceResidence = 0;
    UmraDetails.totlaPriceProgram = 0;

    UmraDetails.tripUmrahID = widget.typeid;

    if (widget.umrahReservationID != null) {
      diffrence = afterdiscount - UmraDetails.totalBokkedprice;
    }

    if (Routes.user != null) {
      getwalllet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener(
          bloc: _umraBloc,
          listener: (context, UmraState state) {
            if (state.reservationResponseElectronicModel?.status == 'success' &&
                paymentpage!.pageId == 4) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        Text(state.reservationResponseElectronicModel!.text!),
                      ],
                    ),
                    titleTextStyle: fontStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.bold,
                        color: Colors.black,
                        fontSize: 20),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LanguageClass.isEnglish ? 'Amount: ' : "القيمة",
                              style: fontStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              UmraDetails.afterdiscount
                                  .toStringAsFixed(2)
                                  .toString(),
                              style: fontStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LanguageClass.isEnglish
                                  ? 'Reference Number: '
                                  : ': رقم المرجعي',
                              style: fontStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              state.reservationResponseElectronicModel!.message!
                                  .referenceNumber
                                  .toString(),
                              style: fontStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                      ],
                    ),
                    actionsOverflowButtonSpacing: 20,
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.umraticket,
                              (route) => false,
                            );
                          },
                          child: Container(
                            // padding: const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                            // margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                            decoration: BoxDecoration(
                                // color: color ?? AppColors.darkRed,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                              child: Text(
                                LanguageClass.isEnglish ? 'OK' : "موافقة",
                                style: fontStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                            ),
                          )),
                    ],
                  );
                },
              );
            } else if (state.reservationResponseElectronicModel?.status ==
                'success') {
              Constants.showDoneConfirmationDialog(context, isError: false,
                  callback: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.umraticket,
                  (route) => false,
                );
              },
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LanguageClass.isEnglish ? 'Amount: ' : "القيمة",
                            style: fontStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(UmraDetails.afterdiscount.toStringAsFixed(2))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reference Number: ',
                            style: fontStyle(
                                color: Colors.black,
                                fontFamily: FontFamily.bold,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Constants.showDefaultSnackBar(
                                        context: context,
                                        text: 'Reference Number copied');
                                    await Clipboard.setData(ClipboardData(
                                        text: state
                                            .reservationResponseElectronicModel!
                                            .message!
                                            .referenceNumber
                                            .toString()));
                                  },
                                  child: Container(
                                      width: 15,
                                      height: 15,
                                      child: Icon(
                                        Icons.copy_outlined,
                                        size: 14,
                                      )),
                                ),
                                Expanded(
                                  child: Text(
                                    state.reservationResponseElectronicModel!
                                        .message!.referenceNumber
                                        .toString(),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  message:
                      "You will get a notification by applying your wallet \n In order to agree to pay");
            } else if (state.reservationResponseElectronicModel?.status ==
                'failed') {
              Constants.showDefaultSnackBar(
                  context: context,
                  text:
                      state.reservationResponseElectronicModel!.errormessage!);
            } else if (state.reservationResponseCreditCard?.status ==
                'success') {
              showDoneConfirmationDialog(context,
                  callbackTitle: "Go to OTP",
                  message: 'Complete the payment process', callback: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ConfirmPayWebView(
                            webViewLink: state.reservationResponseCreditCard!
                                .message!.nextAction!.redirectUrl!)));
              });
            } else if (state.reservationResponseCreditCard?.status ==
                'failed') {
              Constants.showDefaultSnackBar(
                  context: context,
                  color: AppColors.umragold,
                  text: state.reservationResponseCreditCard!.errormessage
                      .toString());
            } else if (state.reservationResponseMyWalletModel?.status ==
                'failed') {
              Constants.showDefaultSnackBar(
                  color: AppColors.umragold,
                  context: context,
                  text: state.reservationResponseMyWalletModel!.message ?? ' ');
            } else if (state.reservationResponseMyWalletModel?.status ==
                'success') {
              Constants.showDefaultSnackBar(
                  color: AppColors.umragold,
                  context: context,
                  text: state.reservationResponseMyWalletModel!.message ?? ' ');
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.umraticket,
                (route) => false,
              );
            } else if (state.campainlistmodel?.status == "success") {
              listcampains = state.campainlistmodel!.message!.list;
            } else if (state.promocodemodel?.status == 'success') {
              discount = state.promocodemodel!.message!.discount!;

              promocodid =
                  state.promocodemodel!.message!.promoCodeId.toString();

              UmraDetails.promocodid = promocodid;
              UmraDetails.promocode = _promocodetext.text;

              if (state.promocodemodel!.message!.isPrecentage == true) {
                discount =
                    (accomidationprice + programsprice + transportationprice) *
                        state.promocodemodel!.message!.discount! /
                        100;

                UmraDetails.dicount = discount;
                afterdiscount =
                    (accomidationprice + programsprice + transportationprice) -
                        discount;
                UmraDetails.afterdiscount = afterdiscount;
              } else {
                discount = state.promocodemodel!.message!.discount!;
                UmraDetails.dicount = discount;
                afterdiscount =
                    (accomidationprice + programsprice + transportationprice) -
                        discount;
                UmraDetails.afterdiscount = afterdiscount;
              }

              if (widget.umrahReservationID != null) {
                diffrence = afterdiscount - UmraDetails.totalBokkedprice;
              }
            } else if (state.promocodemodel?.status == 'failed') {
              _promocodetext.text = '';
              afterdiscount =
                  (accomidationprice + programsprice + transportationprice);
              if (widget.umrahReservationID != null) {
                diffrence = afterdiscount - UmraDetails.totalBokkedprice;
              }
              UmraDetails.afterdiscount = afterdiscount;
              discount = 0;
              UmraDetails.dicount = discount;
              UmraDetails.promocodid = '';
              Constants.showDefaultSnackBar(
                  color: AppColors.umragold,
                  context: context,
                  text: state.promocodemodel!.errormessage ?? ' ');
            } else if (state.policyticketmodel?.status == 'success') {
              showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.2),
                  useRootNavigator: true,
                  builder: (context) {
                    return StatefulBuilder(builder: (buildContext,
                        StateSetter setStater /*You can rename this!*/) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        content: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10.w),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                  color: Color(0xff707070), width: 2),
                              borderRadius: BorderRadius.circular(16)),
                          child: Scrollbar(
                            thickness: 10,
                            trackVisibility: true,
                            interactive: true,
                            scrollbarOrientation: LanguageClass.isEnglish
                                ? ScrollbarOrientation.right
                                : ScrollbarOrientation.left,
                            radius: Radius.circular(12),
                            thumbVisibility: true,
                            child: ListView(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              children: [
                                20.verticalSpace,
                                Text(
                                  LanguageClass.isEnglish
                                      ? 'Terms and conditions '
                                      : "الشروط والأحكام",
                                  textAlign: LanguageClass.isEnglish
                                      ? TextAlign.left
                                      : TextAlign.right,
                                  textDirection: LanguageClass.isEnglish
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  style: fontStyle(
                                    color: Colors.black,
                                    fontFamily: FontFamily.medium,
                                    fontSize: 29.sp,
                                  ),
                                ),
                                20.verticalSpace,
                                ListView.builder(
                                  itemCount:
                                      state.policyticketmodel!.message!.length,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding:
                                      EdgeInsets.only(left: 12.w, right: 12.w),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        margin: EdgeInsets.only(top: 15.h),
                                        child: Text(
                                            "${state.policyticketmodel!.message![index]}",
                                            textAlign: TextAlign.justify,
                                            textDirection:
                                                LanguageClass.isEnglish
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                            style: fontStyle(
                                                fontSize: 14.sp,
                                                fontFamily: FontFamily.medium,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black)));
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.w, vertical: 10.h),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        accept = true;
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Constants.customButton(
                                        borderradias: 30,
                                        text: LanguageClass.isEnglish
                                            ? "Accept"
                                            : "اوافق",
                                        color: AppColors.umragold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  });
            }
          },
          child: BlocBuilder(
              bloc: _umraBloc,
              builder: (context, UmraState state) {
                if (state.isloading == true) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.umragold,
                    ),
                  );
                } else {
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
                                margin: EdgeInsets.only(
                                    left: LanguageClass.isEnglish ? 55 : 0,
                                    right: LanguageClass.isEnglish ? 0 : 55),
                                alignment: LanguageClass.isEnglish
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? 'Packages'
                                      : 'الحملات',
                                  style: fontStyle(
                                      color: Colors.black,
                                      fontSize: 24.sp,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                width: double.infinity,
                                height: 50,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  scrollDirection: Axis.horizontal,
                                  physics: ScrollPhysics(),
                                  children: [
                                    Indexer(
                                        alignment: Alignment.centerLeft,
                                        reversed: true,
                                        children: List.generate(
                                            listcampains!.length,
                                            (index) => Indexed(
                                                  index: index,
                                                  key: UniqueKey(),
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: AnimatedContainer(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              selectedpackage ==
                                                                      index
                                                                  ? 30
                                                                  : 5,
                                                          right: 5),
                                                      margin: EdgeInsets.only(
                                                          left: index * 80),
                                                      decoration: BoxDecoration(
                                                          boxShadow:
                                                              selectedpackage ==
                                                                      index
                                                                  ? [
                                                                      BoxShadow(
                                                                          offset: Offset(4,
                                                                              0),
                                                                          color: Colors.black.withOpacity(
                                                                              0.4),
                                                                          blurRadius:
                                                                              4,
                                                                          spreadRadius:
                                                                              0)
                                                                    ]
                                                                  : [
                                                                      BoxShadow(
                                                                          offset: Offset(4,
                                                                              0),
                                                                          color: Colors.black.withOpacity(
                                                                              0.2),
                                                                          blurRadius:
                                                                              2,
                                                                          spreadRadius:
                                                                              0)
                                                                    ],
                                                          color: HexColor(
                                                              listcampains![
                                                                          index]
                                                                      .bgColor ??
                                                                  '#AEAEAE'),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      13)),
                                                      width: selectedpackage ==
                                                              index
                                                          ? 148
                                                          : 100,
                                                      height: 47,
                                                      duration: Duration(
                                                          microseconds: 100),
                                                      curve: Curves.linear,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                              child: Text(
                                                                listcampains![
                                                                        index]
                                                                    .name!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: fontStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )).toList()),
                                  ],
                                )),
                            10.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Container(
                                    width: 27,
                                    height: 27,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2,
                                            color: AppColors.umragold),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.umragold,
                                          border: Border.all(
                                              color: AppColors.umragold),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: AppColors.umragold,
                                    ),
                                  )),
                                  Container(
                                      child: Container(
                                    width: 27,
                                    height: 27,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2,
                                            color: AppColors.umragold),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.umragold,
                                          border: Border.all(
                                              color: AppColors.umragold),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: AppColors.umragold,
                                    ),
                                  )),
                                  Container(
                                      child: Container(
                                    width: 27,
                                    height: 27,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2,
                                            color: AppColors.umragold),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.umragold,
                                          border: Border.all(
                                              color: AppColors.umragold),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: AppColors.umragold,
                                    ),
                                  )),
                                  Container(
                                      child: Container(
                                    width: 27,
                                    height: 27,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2,
                                            color: AppColors.umragold),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.umragold,
                                          border: Border.all(
                                              color: AppColors.umragold),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: AppColors.umragold),
                                  )),
                                  Container(
                                      child: Container(
                                    width: 27,
                                    height: 27,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2,
                                            color: AppColors.umragold),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.umragold,
                                          border: Border.all(
                                              color: AppColors.umragold),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            6.verticalSpace,
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          LanguageClass.isEnglish
                                              ? 'Packages'
                                              : 'الحملات',
                                          textAlign: TextAlign.center,
                                          style: fontStyle(
                                              fontFamily: FontFamily.bold,
                                              fontSize: 9.sp,
                                              height: 1.2,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'Transportation'
                                            : 'الانتقالات',
                                        textAlign: TextAlign.center,
                                        style: fontStyle(
                                            fontFamily: FontFamily.bold,
                                            fontSize: 9.sp,
                                            height: 1.2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'Accommodation'
                                            : 'الإقامة',
                                        textAlign: TextAlign.center,
                                        style: fontStyle(
                                            fontFamily: FontFamily.bold,
                                            fontSize: 9.sp,
                                            height: 1.2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? 'Program'
                                                : 'البرنامج',
                                            textAlign: TextAlign.center,
                                            style: fontStyle(
                                                fontFamily: FontFamily.bold,
                                                fontSize: 9.sp,
                                                height: 1.2,
                                                color: Colors.black),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'Reservation'
                                            : "الحجز",
                                        textAlign: TextAlign.center,
                                        style: fontStyle(
                                            fontFamily: FontFamily.bold,
                                            fontSize: 9.sp,
                                            height: 1.2,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                children: [
                                  UmraDetails.accomidation!.isEmpty
                                      ? SizedBox()
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  RotationTransition(
                                                    turns: accomidatioisopen
                                                        ? AlwaysStoppedAnimation(
                                                            360)
                                                        : new AlwaysStoppedAnimation(
                                                            180 / 360),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (accomidatioisopen) {
                                                          accomidatioisopen =
                                                              false;

                                                          setState(() {});
                                                        } else {
                                                          accomidatioisopen =
                                                              true;

                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 18.w,
                                                        height: 16.w,
                                                        alignment:
                                                            Alignment.center,
                                                        child: SvgPicture.asset(
                                                            'assets/images/arrowdown.svg'),
                                                      ),
                                                    ),
                                                  ),
                                                  10.horizontalSpace,
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? 'Accommodation'
                                                        : 'الإقامة',
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontSize: 22.sp,
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        height: 1.2,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '${Routes.curruncy} ${accomidationprice.toStringAsFixed(2)}',
                                                    style: fontStyle(
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            10.verticalSpace,
                                            accomidatioisopen
                                                ? Flexible(
                                                    child: ListView.builder(
                                                      itemCount: UmraDetails
                                                          .accomidation!.length,
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      physics: ScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      5.h),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: UmraDetails.accomidation![index].isRequired ==
                                                                            true
                                                                        ? () {}
                                                                        : () {
                                                                            setState(() {
                                                                              checkvalueacomidation[index] = !checkvalueacomidation[index];
                                                                            });

                                                                            calculateAccomidation();
                                                                          },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          20.w,
                                                                      height:
                                                                          20.w,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              0),
                                                                          border: Border.all(
                                                                              width: 2,
                                                                              color: Color(0xff707070))),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              2),
                                                                      child: checkvalueacomidation[
                                                                              index]
                                                                          ? Container(
                                                                              width: double.infinity,
                                                                              height: double.infinity,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Color(0xff707070)),
                                                                            )
                                                                          : SizedBox(),
                                                                    ),
                                                                  ),
                                                                  4.horizontalSpace,
                                                                  Text(
                                                                    UmraDetails
                                                                        .accomidation![
                                                                            index]
                                                                        .cityName!,
                                                                    style:
                                                                        fontStyle(
                                                                      fontSize:
                                                                          17.sp,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      height:
                                                                          1.2,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .medium,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                "${UmraDetails.accomidation![index].numberNights} ${LanguageClass.isEnglish ? 'Nights' : 'ليالي'}",
                                                                style:
                                                                    fontStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.2,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                ),
                                                              ),
                                                              Text(
                                                                "${UmraDetails.accomidation![index].accommodationType}",
                                                                style:
                                                                    fontStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.2,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                ),
                                                              ),
                                                              Text(
                                                                "${UmraDetails.accomidation![index].accessDate}",
                                                                style:
                                                                    fontStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.2,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : SizedBox(),
                                            10.verticalSpace,
                                            Divider(
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                  UmraDetails.reservedseats.isEmpty == true
                                      ? SizedBox()
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  RotationTransition(
                                                    turns: transportatioisopen
                                                        ? AlwaysStoppedAnimation(
                                                            360)
                                                        : new AlwaysStoppedAnimation(
                                                            180 / 360),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (transportatioisopen) {
                                                          transportatioisopen =
                                                              false;

                                                          setState(() {});
                                                        } else {
                                                          transportatioisopen =
                                                              true;

                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 18.w,
                                                        height: 16.w,
                                                        alignment:
                                                            Alignment.center,
                                                        child: SvgPicture.asset(
                                                            'assets/images/arrowdown.svg'),
                                                      ),
                                                    ),
                                                  ),
                                                  10.horizontalSpace,
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? 'Transportation'
                                                        : 'الانتقالات',
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontSize: 22.sp,
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        height: 1.2,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '${Routes.curruncy} ${transportationprice.toStringAsFixed(2)}',
                                                    style: fontStyle(
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            10.verticalSpace,
                                            transportatioisopen
                                                ? Flexible(
                                                    child: ListView.builder(
                                                      itemCount: UmraDetails
                                                          .transportList!
                                                          .length,
                                                      shrinkWrap: true,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      physics: ScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return UmraDetails
                                                                .reservedseats
                                                                .firstWhere(
                                                                    (element) {
                                                                  return element
                                                                          .tripid ==
                                                                      UmraDetails
                                                                          .transportList![
                                                                              index]
                                                                          .tripId;
                                                                },
                                                                    orElse: () => TransportationsSeats(
                                                                        seatsnumber: [],
                                                                        totalprice:
                                                                            0,
                                                                        tripid:
                                                                            0))
                                                                .seatsnumber
                                                                .isNotEmpty
                                                            ? Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5.h),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    InkWell(
                                                                      // onTap: () {
                                                                      //   _umraBloc.add(GetSeatsEvent(
                                                                      //       tripId: UmraDetails
                                                                      //           .transportList![
                                                                      //               index]
                                                                      //           .tripId));
                                                                      // },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                checkvalueTransportation[index] = !checkvalueTransportation[index];
                                                                              });

                                                                              calculateTransportation();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 20.w,
                                                                              height: 20.w,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), border: Border.all(width: 2, color: Color(0xff707070))),
                                                                              padding: EdgeInsets.all(2),
                                                                              child: checkvalueTransportation[index]
                                                                                  ? Container(
                                                                                      width: double.infinity,
                                                                                      height: double.infinity,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Color(0xff707070)),
                                                                                    )
                                                                                  : SizedBox(),
                                                                            ),
                                                                          ),
                                                                          4.horizontalSpace,
                                                                          Text(
                                                                            UmraDetails.reservedseats
                                                                                .firstWhere((element) {
                                                                                  return element.tripid == UmraDetails.transportList![index].tripId;
                                                                                }, orElse: () => TransportationsSeats(seatsnumber: [], totalprice: 0, tripid: 0))
                                                                                .seatsnumber
                                                                                .length
                                                                                .toString(),
                                                                            style:
                                                                                fontStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 17.sp,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontFamily: FontFamily.medium,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            LanguageClass.isEnglish
                                                                                ? ' Seats'
                                                                                : ' المقاعد',
                                                                            style:
                                                                                fontStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 17.sp,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontFamily: FontFamily.medium,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    18.horizontalSpace,
                                                                    Expanded(
                                                                      child: Transform
                                                                          .flip(
                                                                        flipX: index
                                                                            .isOdd,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: UmraDetails.transportList![index].from == null
                                                                                  ? SizedBox()
                                                                                  : Transform.flip(
                                                                                      flipX: index.isOdd,
                                                                                      child: Container(
                                                                                        height: 20.h,
                                                                                        child: ListView(
                                                                                          shrinkWrap: true,
                                                                                          padding: EdgeInsets.zero,
                                                                                          physics: ScrollPhysics(),
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          children: [
                                                                                            Text(
                                                                                              UmraDetails.transportList![index].from!,
                                                                                              style: fontStyle(
                                                                                                color: Colors.black,
                                                                                                fontSize: 14.sp,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontFamily: FontFamily.medium,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                            16.horizontalSpace,
                                                                            RotationTransition(
                                                                              turns: LanguageClass.isEnglish ? AlwaysStoppedAnimation(360) : new AlwaysStoppedAnimation(180 / 360),
                                                                              child: Container(
                                                                                alignment: Alignment.center,
                                                                                child: Image.asset('assets/images/longarrow.png'),
                                                                              ),
                                                                            ),
                                                                            16.horizontalSpace,
                                                                            Expanded(
                                                                              child: UmraDetails.transportList![index].to == null
                                                                                  ? SizedBox()
                                                                                  : Transform.flip(
                                                                                      flipX: index.isOdd,
                                                                                      child: Container(
                                                                                        height: 20.h,
                                                                                        child: ListView(
                                                                                          shrinkWrap: true,
                                                                                          padding: EdgeInsets.zero,
                                                                                          physics: ScrollPhysics(),
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          children: [
                                                                                            Text(
                                                                                              UmraDetails.transportList![index].to!,
                                                                                              style: fontStyle(
                                                                                                color: Colors.black,
                                                                                                fontSize: 14.sp,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontFamily: FontFamily.medium,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    16.horizontalSpace,
                                                                    Text(
                                                                      UmraDetails
                                                                          .transportList![
                                                                              index]
                                                                          .tripDate!,
                                                                      style:
                                                                          fontStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            FontFamily.medium,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox();
                                                      },
                                                    ),
                                                  )
                                                : SizedBox(),
                                            10.verticalSpace,
                                            Divider(
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                  UmraDetails.umraprograms.isEmpty == true
                                      ? SizedBox()
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  RotationTransition(
                                                    turns: programisopen
                                                        ? AlwaysStoppedAnimation(
                                                            360)
                                                        : new AlwaysStoppedAnimation(
                                                            180 / 360),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (programisopen) {
                                                          programisopen = false;

                                                          setState(() {});
                                                        } else {
                                                          programisopen = true;

                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 18.w,
                                                        height: 16.w,
                                                        alignment:
                                                            Alignment.center,
                                                        child: SvgPicture.asset(
                                                            'assets/images/arrowdown.svg'),
                                                      ),
                                                    ),
                                                  ),
                                                  10.horizontalSpace,
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? 'Program'
                                                        : 'البرنامج',
                                                    style: fontStyle(
                                                        color: Colors.black,
                                                        fontSize: 22.sp,
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        height: 1.2,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '${Routes.curruncy} ${programsprice.toStringAsFixed(2)}',
                                                    style: fontStyle(
                                                        fontFamily:
                                                            FontFamily.medium,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            10.verticalSpace,
                                            programisopen
                                                ? Flexible(
                                                    child: ListView.builder(
                                                      itemCount: UmraDetails
                                                          .umraprograms.length,
                                                      shrinkWrap: true,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      physics: ScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          width:
                                                              double.infinity,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      5.h),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: UmraDetails.umraprograms[index].isRequired ==
                                                                              true
                                                                          ? () {}
                                                                          : () {
                                                                              setState(() {
                                                                                checkvaluePrograms[index] = !checkvaluePrograms[index];
                                                                              });
                                                                              calculateprograms();
                                                                            },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            20.w,
                                                                        height:
                                                                            20.w,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(0),
                                                                            border: Border.all(width: 2, color: Color(0xff707070))),
                                                                        padding:
                                                                            EdgeInsets.all(2),
                                                                        child: checkvaluePrograms[index]
                                                                            ? Container(
                                                                                width: double.infinity,
                                                                                height: double.infinity,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Color(0xff707070)),
                                                                              )
                                                                            : SizedBox(),
                                                                      ),
                                                                    ),
                                                                    10.horizontalSpace,
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        UmraDetails
                                                                            .umraprograms[index]
                                                                            .title!,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            fontStyle(
                                                                          fontSize:
                                                                              16.sp,
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          height:
                                                                              1.2,
                                                                          fontFamily:
                                                                              FontFamily.medium,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Text(
                                                                "${UmraDetails.umraprograms[index].price * UmraDetails.programsNumber[index]} ${Routes.curruncy}",
                                                                style:
                                                                    fontStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.2,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .medium,
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
                                  10.verticalSpace,
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: DottedLine(
                                      direction: Axis.horizontal,
                                      dashColor: Colors.black,
                                      dashRadius: 100,
                                      dashLength: 1,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Text(
                                      '${LanguageClass.isEnglish ? 'Total' : 'الإجمالي'} ${(accomidationprice + transportationprice + programsprice).toStringAsFixed(2)} ${Routes.curruncy}',
                                      style: fontStyle(
                                        color: Colors.black,
                                        fontSize: 17.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Container(
                                    height: 44,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25.w),
                                    decoration: BoxDecoration(
                                        color: Color(0xffDEDEDE),
                                        borderRadius: BorderRadius.circular(22),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xffa7a7a7)
                                                  .withOpacity(0.1),
                                              blurRadius: 3,
                                              offset: Offset(0, 3))
                                        ]),
                                    child: TextField(
                                      controller: _promocodetext,
                                      style: fontStyle(
                                          color: Color(0xff969696),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: LanguageClass.isEnglish
                                            ? 'I have a Promo Code !'
                                            : 'لدي كود خصم',
                                        hintStyle: fontStyle(
                                            color: Color(0xff969696),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            if (Routes.user == null) {
                                              Constants.showDefaultSnackBar(
                                                  color: AppColors.umragold,
                                                  context: context,
                                                  text: LanguageClass.isEnglish
                                                      ? 'Please login first'
                                                      : 'الرجاء تسجيل الدخول أولا');
                                            } else {
                                              if (_promocodetext.text != "") {
                                                UmraDetails.totalPriceUmrah =
                                                    afterdiscount;
                                                UmraDetails
                                                        .totlaPriceTransport =
                                                    transportationprice;
                                                UmraDetails
                                                        .totlaPriceResidence =
                                                    accomidationprice;
                                                UmraDetails.totlaPriceProgram =
                                                    programsprice;
                                                _umraBloc.add(
                                                    CheckpromcodeEvent(
                                                        code: _promocodetext
                                                            .text));
                                              } else {
                                                Constants.showDefaultSnackBar(
                                                    color: AppColors.umragold,
                                                    context: context,
                                                    text: LanguageClass
                                                            .isEnglish
                                                        ? 'Please enter code'
                                                        : 'من فضلك  ادخل الكود ');
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: AppColors.umragold,
                                                borderRadius:
                                                    BorderRadius.circular(22)),
                                            padding: EdgeInsets.only(left: 0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              LanguageClass.isEnglish
                                                  ? 'Redeem'
                                                  : "تطبيق",
                                              style: fontStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 35.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          LanguageClass.isEnglish
                                              ? 'Disscount'
                                              : 'خصم',
                                          style: fontStyle(
                                              fontFamily: FontFamily.regular,
                                              fontSize: 14.sp,
                                              height: 1,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blackColor),
                                        ),
                                        Text(
                                          discount
                                              .toStringAsFixed(2)
                                              .toString(),
                                          style: fontStyle(
                                              fontFamily: FontFamily.medium,
                                              fontSize: 14,
                                              height: 1,
                                              fontWeight: FontWeight.w600,
                                              color: HexColor('#FF0000')),
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  widget.umrahReservationID != null &&
                                          !diffrence.isNegative
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left:
                                                        LanguageClass.isEnglish
                                                            ? 20.w
                                                            : 0,
                                                    right:
                                                        LanguageClass.isEnglish
                                                            ? 0
                                                            : 20.w),
                                                child: Text(
                                                  LanguageClass.isEnglish
                                                      ? 'Remaining payment'
                                                      : 'المتبقي للدفع',
                                                  style: fontStyle(
                                                      fontFamily:
                                                          FontFamily.regular,
                                                      fontSize: 12.sp,
                                                      height: 1,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.blackColor),
                                                ),
                                              ),
                                              Text(
                                                "${diffrence.toStringAsFixed(2)} ${Routes.curruncy}",
                                                style: fontStyle(
                                                    fontFamily: FontFamily.bold,
                                                    fontSize: 14.sp,
                                                    height: 1,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                            ],
                                          ),
                                        )
                                      : widget.umrahReservationID != null &&
                                              diffrence.isNegative
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: LanguageClass
                                                                .isEnglish
                                                            ? 20.w
                                                            : 0,
                                                        right: LanguageClass
                                                                .isEnglish
                                                            ? 0
                                                            : 20.w),
                                                    child: Text(
                                                      LanguageClass.isEnglish
                                                          ? 'Receive in wallet'
                                                          : 'استلام في المحفظة',
                                                      style: fontStyle(
                                                          fontFamily: FontFamily
                                                              .regular,
                                                          fontSize: 12.sp,
                                                          height: 1,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .blackColor),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${diffrence.toString().replaceAll('-', '')} ${Routes.curruncy}",
                                                    style: fontStyle(
                                                        fontFamily:
                                                            FontFamily.bold,
                                                        fontSize: 14.sp,
                                                        height: 1,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .primaryColor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : 0.verticalSpace,
                                  5.verticalSpace,
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: LanguageClass.isEnglish
                                                  ? 20.w
                                                  : 0,
                                              right: LanguageClass.isEnglish
                                                  ? 0
                                                  : 20.w),
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? 'Total Price'
                                                : 'السعر الاجمالي',
                                            style: fontStyle(
                                                fontFamily: FontFamily.regular,
                                                fontSize: 14.sp,
                                                height: 1,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.blackColor),
                                          ),
                                        ),
                                        Text(
                                          "${afterdiscount.toStringAsFixed(2)} ${Routes.curruncy}",
                                          style: fontStyle(
                                              fontFamily: FontFamily.bold,
                                              fontSize: 21.sp,
                                              height: 1,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                        left: 15.w, right: 15.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                            value: accept,
                                            hoverColor: Colors.black,
                                            checkColor: AppColors.umragold,
                                            focusColor: Colors.black,
                                            activeColor: Colors.black,
                                            fillColor: MaterialStatePropertyAll(
                                                Colors.white),
                                            onChanged: (value) {
                                              setState(() {
                                                accept = value!;
                                              });

                                              if (accept == true) {
                                                _umraBloc.add(Getpolicyevent(
                                                    type: 'PloicyTrip'));
                                              }
                                            }),
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: RichText(
                                              textAlign: TextAlign.justify,
                                              text: TextSpan(
                                                  text: LanguageClass.isEnglish
                                                      ? 'I read and accept Swa Umrah '
                                                      : ' لقد قرأت ووافقت على',
                                                  style: fontStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.2,
                                                    fontFamily:
                                                        FontFamily.medium,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: LanguageClass
                                                              .isEnglish
                                                          ? ' terms and conditions'
                                                          : ' شروط وأحكام سوا عمرة  ',
                                                      style: fontStyle(
                                                          color: AppColors
                                                              .umragold,
                                                          fontSize: 14.sp,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontFamily:
                                                              FontFamily.medium,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  50.verticalSpace,
                                  widget.umrahReservationID == null
                                      ? Column(
                                          children: [
                                            accept
                                                ? Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15.h,
                                                            horizontal: 15.w),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xfff5f5f5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 7.h),
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                            color: Colors.grey,
                                                          ))),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    width: 50.w,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Image
                                                                        .network(
                                                                      paymentpage!
                                                                          .image!,
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                    ),
                                                                  ),
                                                                  11.horizontalSpace,
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        LanguageClass.isEnglish
                                                                            ? 'Payment method'
                                                                            : 'طريقة الدفع',
                                                                        style: fontStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 10.sp,
                                                                            fontFamily: FontFamily.medium,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                      2.verticalSpace,
                                                                      Text(
                                                                        paymentpage!
                                                                            .pageName!,
                                                                        style: fontStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15.sp,
                                                                            fontFamily: FontFamily.regular,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  if (Routes
                                                                          .user ==
                                                                      null) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              MultiBlocProvider(
                                                                            providers: [
                                                                              BlocProvider<LoginCubit>(
                                                                                create: (context) => sl<LoginCubit>(),
                                                                              ),
                                                                            ],
                                                                            child:
                                                                                LoginScreen(
                                                                              isback: true,
                                                                            ),
                                                                          ),
                                                                        ));
                                                                  } else {
                                                                    UmraDetails
                                                                            .afterdiscount =
                                                                        afterdiscount;
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        childCurrent:
                                                                            ReservationScreen(
                                                                          selectedpackage:
                                                                              selectedpackage,
                                                                          typeid:
                                                                              widget.typeid,
                                                                        ),
                                                                        duration:
                                                                            Duration(milliseconds: 300),
                                                                        type: PageTransitionType
                                                                            .bottomToTop,
                                                                        child:
                                                                            SelectPaymentumra(
                                                                          umrahReservationID:
                                                                              widget.umrahReservationID,
                                                                        ),
                                                                      ),
                                                                    ).then(
                                                                        (value) {
                                                                      if (value
                                                                          is paymentbody) {
                                                                        setState(
                                                                            () {
                                                                          paymentpage =
                                                                              value;
                                                                        });
                                                                      }
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 57.w,
                                                                  height: 16.h,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .umragold,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(3),
                                                                  ),
                                                                  child: Text(
                                                                    LanguageClass
                                                                            .isEnglish
                                                                        ? 'Change'
                                                                        : 'تغيير',
                                                                    style: fontStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 10
                                                                            .sp,
                                                                        fontFamily:
                                                                            FontFamily
                                                                                .medium,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 24.w,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          'assets/images/wallet2.svg'),
                                                                ),
                                                                25.horizontalSpace,
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      LanguageClass
                                                                              .isEnglish
                                                                          ? 'Use wallet Ballance'
                                                                          : 'استخدام رصيد المحفظة',
                                                                      style: fontStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 15
                                                                              .sp,
                                                                          fontFamily: FontFamily
                                                                              .medium,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    Text(
                                                                      '$balance ${Routes.curruncy}',
                                                                      style: fontStyle(
                                                                          color: Color(
                                                                              0xff23c956),
                                                                          fontSize: 10
                                                                              .sp,
                                                                          fontFamily: FontFamily
                                                                              .bold,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            Switch.adaptive(
                                                              // Don't use the ambient CupertinoThemeData to style this switch.
                                                              applyCupertinoTheme:
                                                                  false,
                                                              activeColor:
                                                                  AppColors
                                                                      .umragold,
                                                              inactiveTrackColor:
                                                                  Color(
                                                                      0xffd8d8d8),
                                                              value: usewallet,
                                                              onChanged:
                                                                  (bool value) {
                                                                setState(() {
                                                                  usewallet =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            5.verticalSpace,
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        height: 35,
                                                        width: 70,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5.w,
                                                                vertical: 2.h),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xffecb959),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        41)),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? "previous"
                                                                : 'السابق',
                                                            style: fontStyle(
                                                                fontFamily:
                                                                    FontFamily
                                                                        .bold,
                                                                fontSize: 18.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: accept
                                                          ? () {
                                                              if (Routes.user ==
                                                                  null) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MultiBlocProvider(
                                                                        providers: [
                                                                          BlocProvider<
                                                                              LoginCubit>(
                                                                            create: (context) =>
                                                                                sl<LoginCubit>(),
                                                                          ),
                                                                        ],
                                                                        child:
                                                                            LoginScreen(
                                                                          isback:
                                                                              true,
                                                                        ),
                                                                      ),
                                                                    ));
                                                              } else {
                                                                UmraDetails
                                                                        .totalPriceUmrah =
                                                                    afterdiscount;
                                                                UmraDetails
                                                                        .totlaPriceTransport =
                                                                    transportationprice;
                                                                UmraDetails
                                                                        .totlaPriceResidence =
                                                                    accomidationprice;
                                                                UmraDetails
                                                                        .totlaPriceProgram =
                                                                    programsprice;

                                                                if (usewallet) {
                                                                  _umraBloc.add(WalletdetactionEvent(
                                                                      PaymentMethodID:
                                                                          4,
                                                                      paymentTypeID:
                                                                          67));
                                                                } else if (paymentpage!
                                                                        .pageId ==
                                                                    2) {
                                                                  UmraDetails
                                                                          .curruncy =
                                                                      Routes
                                                                          .curruncy!;

                                                                  if (UmraDetails
                                                                          .cardModel
                                                                          .cardNumber !=
                                                                      '') {
                                                                    _umraBloc.add(
                                                                        cardpaymentEvent(
                                                                      PaymentMethodID:
                                                                          4,
                                                                      paymentTypeID:
                                                                          68,
                                                                      cvv: UmraDetails
                                                                          .cvv
                                                                          .toString(),
                                                                      cardNumber: UmraDetails
                                                                          .cardModel
                                                                          .cardNumber!
                                                                          .toString()
                                                                          .replaceAll(
                                                                              " ",
                                                                              ""),
                                                                      cardExpiryYear: UmraDetails
                                                                          .cardModel
                                                                          .month!
                                                                          .substring(
                                                                            3,
                                                                          )
                                                                          .toString(),
                                                                      cardExpiryMonth: UmraDetails
                                                                          .cardModel
                                                                          .month!
                                                                          .substring(
                                                                              0,
                                                                              2)
                                                                          .toString(),
                                                                    ));
                                                                  } else {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Umracardpay(
                                                                          umrahReservationID:
                                                                              widget.umrahReservationID,
                                                                          index:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                } else if (paymentpage!
                                                                        .pageId ==
                                                                    3) {
                                                                  _umraBloc.add(FawrypayEvent(
                                                                      PaymentMethodID:
                                                                          2,
                                                                      paymentTypeID:
                                                                          68));
                                                                } else if (paymentpage!
                                                                        .pageId ==
                                                                    4) {
                                                                  _umraBloc.add(ElectronicwalletEvent(
                                                                      PaymentMethodID:
                                                                          5,
                                                                      paymentTypeID:
                                                                          68,
                                                                      phone: UmraDetails
                                                                          .phonenumber));
                                                                }
                                                              }
                                                            }
                                                          : () {},
                                                      child: Container(
                                                        height: 40.h,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.w),
                                                        decoration: BoxDecoration(
                                                            color: accept
                                                                ? Colors.black
                                                                : Colors
                                                                    .grey[300],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        41)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            usewallet
                                                                ? Container(
                                                                    width: 35.w,
                                                                    height:
                                                                        35.w,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/images/wallet2.svg',
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: 35.w,
                                                                    height:
                                                                        35.w,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Image
                                                                        .network(
                                                                      paymentpage!
                                                                          .image!,
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Image.asset(
                                                                            'assets/images/icons8-open-wallet-78.png');
                                                                      },
                                                                    ),
                                                                  ),
                                                            2.horizontalSpace,
                                                            FittedBox(
                                                              child: Text(
                                                                LanguageClass
                                                                        .isEnglish
                                                                    ? 'Pay'
                                                                    : 'ادفع',
                                                                style:
                                                                    fontStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            diffrence.isNegative && accept ||
                                                    diffrence == 0 && accept
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.w),
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            UmraDetails
                                                                    .totalPriceUmrah =
                                                                afterdiscount;
                                                            UmraDetails
                                                                    .totlaPriceTransport =
                                                                transportationprice;
                                                            UmraDetails
                                                                    .totlaPriceResidence =
                                                                accomidationprice;
                                                            UmraDetails
                                                                    .totlaPriceProgram =
                                                                programsprice;

                                                            UmraDetails
                                                                    .differentPrice =
                                                                diffrence;

                                                            _umraBloc.add(EditReservationEvent(
                                                                reservationID:
                                                                    widget
                                                                        .umrahReservationID!,
                                                                paymentMethodID:
                                                                    4,
                                                                paymentTypeID:
                                                                    67));
                                                          },
                                                          child: Container(
                                                            height: 40.h,
                                                            width: 100.w,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.w),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            41)),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                FittedBox(
                                                                  child: Text(
                                                                    LanguageClass
                                                                            .isEnglish
                                                                        ? 'Save'
                                                                        : 'حفظ',
                                                                    style:
                                                                        fontStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .medium,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                                : !diffrence.isNegative &&
                                                        accept
                                                    ? Column(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.w),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        15.h,
                                                                    horizontal:
                                                                        15.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xfff5f5f5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              7.h),
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                  ))),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                50.w,
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Image.network(
                                                                              paymentpage!.image!,
                                                                              fit: BoxFit.fitWidth,
                                                                            ),
                                                                          ),
                                                                          11.horizontalSpace,
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                LanguageClass.isEnglish ? 'Payment method' : 'طريقة الدفع',
                                                                                style: fontStyle(color: Colors.black, fontSize: 10.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.normal),
                                                                              ),
                                                                              2.verticalSpace,
                                                                              Text(
                                                                                paymentpage!.pageName!,
                                                                                style: fontStyle(color: Colors.black, fontSize: 15.sp, fontFamily: FontFamily.regular, fontWeight: FontWeight.normal),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (Routes.user ==
                                                                              null) {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => MultiBlocProvider(
                                                                                    providers: [
                                                                                      BlocProvider<LoginCubit>(
                                                                                        create: (context) => sl<LoginCubit>(),
                                                                                      ),
                                                                                    ],
                                                                                    child: LoginScreen(
                                                                                      isback: true,
                                                                                    ),
                                                                                  ),
                                                                                ));
                                                                          } else {
                                                                            Navigator.push(
                                                                              context,
                                                                              PageTransition(
                                                                                alignment: Alignment.center,
                                                                                childCurrent: ReservationScreen(
                                                                                  selectedpackage: selectedpackage,
                                                                                  typeid: widget.typeid,
                                                                                ),
                                                                                duration: Duration(milliseconds: 300),
                                                                                type: PageTransitionType.bottomToTop,
                                                                                child: SelectPaymentumra(
                                                                                  umrahReservationID: widget.umrahReservationID,
                                                                                ),
                                                                              ),
                                                                            ).then((value) {
                                                                              if (value is paymentbody) {
                                                                                setState(() {
                                                                                  paymentpage = value;
                                                                                });
                                                                              }
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              57.w,
                                                                          height:
                                                                              16.h,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                AppColors.umragold,
                                                                            borderRadius:
                                                                                BorderRadius.circular(3),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            LanguageClass.isEnglish
                                                                                ? 'Change'
                                                                                : 'تغيير',
                                                                            style: fontStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 10.sp,
                                                                                fontFamily: FontFamily.medium,
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              24.w,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              SvgPicture.asset('assets/images/wallet2.svg'),
                                                                        ),
                                                                        25.horizontalSpace,
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              LanguageClass.isEnglish ? 'Use wallet Ballance' : 'استخدام رصيد المحفظة',
                                                                              style: fontStyle(color: Colors.black, fontSize: 15.sp, fontFamily: FontFamily.medium, fontWeight: FontWeight.normal),
                                                                            ),
                                                                            Text(
                                                                              '${balance.toStringAsFixed(3)} ${Routes.curruncy}',
                                                                              style: fontStyle(color: Color(0xff23c956), fontSize: 10.sp, fontFamily: FontFamily.bold, fontWeight: FontWeight.normal),
                                                                            )
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Switch
                                                                        .adaptive(
                                                                      // Don't use the ambient CupertinoThemeData to style this switch.
                                                                      applyCupertinoTheme:
                                                                          false,
                                                                      activeColor:
                                                                          AppColors
                                                                              .umragold,
                                                                      inactiveTrackColor:
                                                                          Color(
                                                                              0xffd8d8d8),
                                                                      value:
                                                                          usewallet,
                                                                      onChanged:
                                                                          (bool
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          usewallet =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          /// edit payment

                                                          5.verticalSpace,

                                                          Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20.w),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          35,
                                                                      width: 70,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 5
                                                                              .w,
                                                                          vertical:
                                                                              2.h),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffecb959),
                                                                          borderRadius:
                                                                              BorderRadius.circular(41)),
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Text(
                                                                          LanguageClass.isEnglish
                                                                              ? "previous"
                                                                              : 'السابق',
                                                                          style: fontStyle(
                                                                              fontFamily: FontFamily.bold,
                                                                              fontSize: 25.sp,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  InkWell(
                                                                    onTap: accept
                                                                        ? () {
                                                                            UmraDetails.differentPrice =
                                                                                diffrence;
                                                                            if (Routes.user ==
                                                                                null) {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => MultiBlocProvider(
                                                                                      providers: [
                                                                                        BlocProvider<LoginCubit>(
                                                                                          create: (context) => sl<LoginCubit>(),
                                                                                        ),
                                                                                      ],
                                                                                      child: LoginScreen(
                                                                                        isback: true,
                                                                                      ),
                                                                                    ),
                                                                                  ));
                                                                            } else {
                                                                              UmraDetails.totalPriceUmrah = afterdiscount;
                                                                              UmraDetails.totlaPriceTransport = transportationprice;
                                                                              UmraDetails.totlaPriceResidence = accomidationprice;
                                                                              UmraDetails.totlaPriceProgram = programsprice;

                                                                              if (usewallet) {
                                                                                _umraBloc.add(EditReservationEvent(reservationID: widget.umrahReservationID!, paymentMethodID: 4, paymentTypeID: 67));
                                                                              } else if (paymentpage!.pageId == 2) {
                                                                                UmraDetails.curruncy = Routes.curruncy!;

                                                                                if (UmraDetails.cardModel.cardNumber != '') {
                                                                                  _umraBloc.add(cardEditReservationEvent(
                                                                                    PaymentMethodID: 4,
                                                                                    paymentTypeID: 68,
                                                                                    umrareservationid: widget.umrahReservationID,
                                                                                    cvv: UmraDetails.cvv.toString(),
                                                                                    cardNumber: UmraDetails.cardModel.cardNumber!.toString().replaceAll(" ", ""),
                                                                                    cardExpiryYear: UmraDetails.cardModel.month!
                                                                                        .substring(
                                                                                          3,
                                                                                        )
                                                                                        .toString(),
                                                                                    cardExpiryMonth: UmraDetails.cardModel.month!.substring(0, 2).toString(),
                                                                                  ));
                                                                                } else {
                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => Umracardpay(
                                                                                        index: 1,
                                                                                        umrahReservationID: widget.umrahReservationID,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              } else if (paymentpage!.pageId == 3) {
                                                                                _umraBloc.add(FawryEditEvent(PaymentMethodID: 2, umrareservationid: widget.umrahReservationID, paymentTypeID: 68));
                                                                              } else if (paymentpage!.pageId == 4) {
                                                                                _umraBloc.add(EditElectronicwalletEvent(umrahReservationID: widget.umrahReservationID, PaymentMethodID: 5, paymentTypeID: 68, phone: UmraDetails.phonenumber));
                                                                              }
                                                                            }
                                                                          }
                                                                        : () {},
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40.h,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.w),
                                                                      decoration: BoxDecoration(
                                                                          color: accept
                                                                              ? Colors.black
                                                                              : Colors.grey[300],
                                                                          borderRadius: BorderRadius.circular(41)),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          usewallet
                                                                              ? Container(
                                                                                  width: 35.w,
                                                                                  height: 35.w,
                                                                                  alignment: Alignment.center,
                                                                                  child: SvgPicture.asset(
                                                                                    'assets/images/wallet2.svg',
                                                                                  ),
                                                                                )
                                                                              : Container(
                                                                                  width: 35.w,
                                                                                  height: 35.w,
                                                                                  alignment: Alignment.center,
                                                                                  child: Image.network(
                                                                                    paymentpage!.image!,
                                                                                    errorBuilder: (context, error, stackTrace) {
                                                                                      return Image.asset('assets/images/icons8-open-wallet-78.png');
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                          2.horizontalSpace,
                                                                          FittedBox(
                                                                            child:
                                                                                Text(
                                                                              LanguageClass.isEnglish ? 'Pay' : 'ادفع',
                                                                              style: fontStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 16.sp,
                                                                                fontFamily: FontFamily.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                                    : SizedBox()
                                          ],
                                        ),
                                  10.verticalSpace,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }
              }),
        ),
        bottomNavigationBar: Navigationbottombar(
          currentIndex: 0,
        ));
  }
}
