import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/package_payment.dart';

class selectpackageScreen extends StatefulWidget {
  selectpackageScreen({
    super.key,
  });

  @override
  State<selectpackageScreen> createState() => _selectpackageScreenState();
}

class _selectpackageScreenState extends State<selectpackageScreen> {
  TextEditingController _promocodetext = new TextEditingController(text: '');
  List<TextEditingController> _controllers = [];

  String StudentPromoCodeID = '';
  String Stationfrom = '';
  String stationfromid = '';
  bool ispersentage = false;
  String stationto = '';
  String stationtoid = '';

  String cityname = '';
  String cityID = '';

  List pins = [];

  String packagname = '';
  String packageprice = '0';
  String afterdiscount = '0';
  String linename = '';
  String lineID = '';

  String accpointid = '';
  String accesspoinname = '';
  bool isfreind = false;
  String packageID = '';
  String discount = '0';

  int taped = 0;
  int taped2 = -1;

  bool promocode = false;

  PackagesBloc _packageBloc = new PackagesBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _promocodetext.text = '';
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: BlocListener(
          bloc: _packageBloc,
          listener: (context, PackagesState state) {
            if (state.promocodemodel?.status == 'success') {
              discount = state.promocodemodel!.message!.discount.toString();
              var finalprice;

              Routes.PromoCodeID =
                  state.promocodemodel!.message!.promoCodeId.toString();
              ispersentage = state.promocodemodel!.message!.isPrecentage!;
              if (state.promocodemodel!.message!.isPrecentage == true) {
                var minusdiscount = (double.parse(packageprice) *
                        state.promocodemodel!.message!.discount!) /
                    100;

                finalprice = double.parse(packageprice) - minusdiscount;
              } else {
                finalprice = double.parse(packageprice) -
                    state.promocodemodel!.message!.discount!;
              }

              afterdiscount = finalprice.toString();
            } else if (state.promocodemodel?.status == 'failed') {
              Constants.showDefaultSnackBar(
                  color: Colors.red,
                  context: context,
                  text: state.promocodemodel!.errormessage!);
            }
            if (state.stationfromModel?.status == 'success') {
              showGeneralDialog(
                  context: context,
                  pageBuilder: (BuildContext buildContext,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return StatefulBuilder(builder: (context, setStater) {
                      return Material(
                        color: Colors.transparent,
                        child: Directionality(
                          textDirection: LanguageClass.isEnglish
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          child: Container(
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: sizeHeight * 0.08,
                                ),
                                Container(
                                  alignment: LanguageClass.isEnglish
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      taped2 = -1;
                                    },
                                    child: Icon(
                                      Icons.arrow_back_rounded,
                                      color: AppColors.primaryColor,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    LanguageClass.isEnglish
                                        ? "Select City"
                                        : "اختر مدينة",
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "meduim"),
                                  ),
                                ),
                                SizedBox(
                                  height: sizeHeight * 0.01,
                                ),
                                Expanded(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        final item =
                                            state.stationfromModel!.message;
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setStater(() {
                                                  taped2 = index;
                                                });

                                                print(taped2);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  item![index].cityName!,
                                                  style: TextStyle(
                                                      fontFamily: "meduim",
                                                      color: taped2 == index
                                                          ? AppColors
                                                              .primaryColor
                                                          : Color(0xffA3A3A3),
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            taped2 == index
                                                ? Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    child: ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      itemCount: state
                                                          .stationfromModel!
                                                          .message![index]
                                                          .stationList!
                                                          .length,
                                                      shrinkWrap: true,
                                                      physics: ScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index2) {
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            if (taped == 1) {
                                                              Stationfrom = item[
                                                                      index]
                                                                  .stationList![
                                                                      index2]
                                                                  .stationName!;
                                                              stationfromid = item[
                                                                      index]
                                                                  .stationList![
                                                                      index2]
                                                                  .stationId
                                                                  .toString();
                                                            } else {
                                                              stationto = item[
                                                                      index]
                                                                  .stationList![
                                                                      index2]
                                                                  .stationName!;
                                                              stationtoid = item[
                                                                      index]
                                                                  .stationList![
                                                                      index2]
                                                                  .stationId
                                                                  .toString();
                                                            }
                                                            taped2 = -1;

                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Text(
                                                              item![index]
                                                                  .stationList![
                                                                      index2]
                                                                  .stationName!,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "roman",
                                                                  color: Color(
                                                                      0xffA3A3A3),
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          color: Colors.black,
                                        );
                                      },
                                      itemCount: state.stationfromModel!.message
                                              ?.length ??
                                          0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      ;
                    });
                  });
            }
          },
          child: BlocBuilder(
              bloc: _packageBloc,
              builder: (context, PackagesState state) {
                if (state.isloading == true) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(left: 30, right: 30, top: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: sizeHeight * 0.08,
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
                              color: AppColors.primaryColor,
                              size: 35,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            LanguageClass.isEnglish ? "Packages" : "الباقات",
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 38,
                                fontWeight: FontWeight.w600,
                                fontFamily: "roman"),
                          ),
                        ),
                        SizedBox(
                          height: sizeHeight * 0.01,
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            InkWell(
                              onTap: () {
                                _packageBloc.add(stationfromEvent());
                                taped = 1;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Color(0xffDEDEDE),
                                    borderRadius: BorderRadius.circular(33),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xffa7a7a7)
                                              .withOpacity(0.1),
                                          blurRadius: 3,
                                          offset: Offset(0, 3))
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LanguageClass.isEnglish
                                              ? 'From'
                                              : "من",
                                          style: TextStyle(
                                              color: Color(0xff969696),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          Stationfrom,
                                          style: TextStyle(
                                              color: Color(0xff969696),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                    Stationfrom == ''
                                        ? Icon(
                                            Icons.arrow_circle_down_rounded,
                                            color: Color(0xffA3A3A3),
                                          )
                                        : Container(
                                            width: 25,
                                            height: 25,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                                'assets/images/Icon ionic-md-checkm.png'),
                                          )
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            ///////////////////////////////// city //////////////

                            InkWell(
                              onTap: () {
                                if (stationfromid == '') {
                                  Constants.showDefaultSnackBar(
                                      color: Colors.red,
                                      context: context,
                                      text: LanguageClass.isEnglish
                                          ? 'Please Select From station first'
                                          : '  من فضلك اختر محطة الذهاب اولا');
                                } else {
                                  _packageBloc.add(
                                      stationtoEvent(stationid: stationfromid));
                                  setState(() {
                                    taped = 2;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Color(0xffDEDEDE),
                                    borderRadius: BorderRadius.circular(33),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xffa7a7a7)
                                              .withOpacity(0.1),
                                          blurRadius: 3,
                                          offset: Offset(0, 3))
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LanguageClass.isEnglish
                                              ? 'To'
                                              : " الي",
                                          style: TextStyle(
                                              color: Color(0xff969696),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          stationto,
                                          style: TextStyle(
                                              color: Color(0xff969696),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                    stationto == ''
                                        ? Icon(
                                            Icons.arrow_circle_down_rounded,
                                            color: Color(0xffA3A3A3),
                                          )
                                        : Container(
                                            width: 25,
                                            height: 25,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                                'assets/images/Icon ionic-md-checkm.png'),
                                          )
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

//                           ///////////////////////////////// package //////////////

                            InkWell(
                              onTap: () {
                                if (stationfromid == '' || stationtoid == '') {
                                  Constants.showDefaultSnackBar(
                                      color: Colors.red,
                                      context: context,
                                      text: LanguageClass.isEnglish
                                          ? 'Please Select  stations first'
                                          : ' من فضلك اختر المحطات');
                                } else {
                                  _packageBloc.add(packagesEvent(
                                      stationfromid: stationfromid,
                                      stationtoid: stationtoid));
                                  setState(() {
                                    taped = taped == 3 ? 0 : 3;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Color(0xffDEDEDE),
                                    borderRadius: taped == 3
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(33),
                                            topRight: Radius.circular(33))
                                        : BorderRadius.circular(33),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xffa7a7a7)
                                              .withOpacity(0.1),
                                          blurRadius: 3,
                                          offset: Offset(0, 3))
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LanguageClass.isEnglish
                                              ? 'Select Package'
                                              : "اختر الباقة",
                                          style: TextStyle(
                                              color: Color(0xff969696),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          packagname,
                                          style: TextStyle(
                                              color: Color(0xff969696),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                    packagname == ''
                                        ? Icon(
                                            Icons.arrow_circle_down_rounded,
                                            color: Color(0xffA3A3A3),
                                          )
                                        : Container(
                                            width: 25,
                                            height: 25,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                                'assets/images/Icon ionic-md-checkm.png'),
                                          )
                                  ],
                                ),
                              ),
                            ),
                            taped == 3
                                ? state.isloading == true
                                    ? Container(
                                        color: Colors.transparent,
                                        child: SpinKitCircle(
                                          color: AppColors.yellow,
                                          size: 50.0,
                                        ),
                                      )
                                    : Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffDEDEDE),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20))),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        height: 100,
                                        width: double.infinity,
                                        child: state.packagemodel!.message == []
                                            ? Container(
                                                child: Text(
                                                  state.packagemodel!
                                                      .errormessage!,
                                                  style: TextStyle(
                                                      fontFamily: "regular",
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                              )
                                            : ListView.separated(
                                                itemBuilder: (context, index) {
                                                  final item = state
                                                      .packagemodel!.message;
                                                  return InkWell(
                                                    onTap: () {
                                                      packagname = item[index]
                                                          .packageName!;
                                                      packageprice = item[index]
                                                          .packagePrice
                                                          .toString()!;

                                                      afterdiscount =
                                                          packageprice;
                                                      packageID = item[index]
                                                          .packageId!
                                                          .toString();
                                                      taped = -1;
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            item![index]
                                                                .packageName!,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "regular",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            LanguageClass
                                                                    .isEnglish
                                                                ? "${item![index].tripCount!} trips"
                                                                : "${item![index].tripCount!} رحلات",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "regular",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            " ${item![index].packagePrice.toString()} ${Routes.curruncy}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "regular",
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return Divider(
                                                    color: Colors.black,
                                                  );
                                                },
                                                itemCount: state.packagemodel!
                                                        .message?.length ??
                                                    0),
                                      )
                                : Container(),

                            SizedBox(
                              height: 50,
                            ),

//                           InkWell(

//                           SizedBox(
//                             height: 15,
//                           ),

                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageClass.isEnglish
                                        ? 'Total Price'
                                        : "السعر الكلي",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${packageprice} ${Routes.curruncy}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Container(
                              height: 44,
                              decoration: BoxDecoration(
                                  color: Color(0xffDEDEDE),
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xffa7a7a7).withOpacity(0.1),
                                        blurRadius: 3,
                                        offset: Offset(0, 3))
                                  ]),
                              child: TextField(
                                controller: _promocodetext,
                                style: TextStyle(
                                    color: Color(0xff969696),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: 'I have a Promocode !',
                                  hintStyle: TextStyle(
                                      color: Color(0xff969696),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      if (stationfromid == '') {
                                        Constants.showDefaultSnackBar(
                                            color: Colors.red,
                                            context: context,
                                            text: LanguageClass.isEnglish
                                                ? 'Please Select  stations from'
                                                : ' من فضلك اختر المحطات');
                                      } else if (stationtoid == '') {
                                        Constants.showDefaultSnackBar(
                                            color: Colors.red,
                                            context: context,
                                            text: LanguageClass.isEnglish
                                                ? 'Please Select  stations to'
                                                : ' من فضلك اختر المحطات');
                                      } else if (packageID == '') {
                                        Constants.showDefaultSnackBar(
                                            color: Colors.red,
                                            context: context,
                                            text: LanguageClass.isEnglish
                                                ? 'Please select package  '
                                                : 'من فضلك اختر الباقة ');
                                      } else {
                                        if (_promocodetext.text != "") {
                                          _packageBloc.add(PromocodeEvent(
                                              promocode: _promocodetext.text,
                                              packageid: packageID));
                                        } else {
                                          Constants.showDefaultSnackBar(
                                              color: Colors.red,
                                              context: context,
                                              text: LanguageClass.isEnglish
                                                  ? 'Please enter code'
                                                  : 'من فضلك  ادخل الكود ');
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Color(0xffFF5D4B),
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                      padding: EdgeInsets.only(left: 0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        LanguageClass.isEnglish
                                            ? 'Redeem'
                                            : "تطبيق",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageClass.isEnglish
                                        ? 'Disscount'
                                        : "خصم",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${discount} ${ispersentage ? '%' : Routes.curruncy}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 30,
                            ),

                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageClass.isEnglish
                                        ? 'Total Price'
                                        : "السعر الكلي",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${afterdiscount} ${Routes.curruncy}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

//                           Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   LanguageClass.isEnglish ? 'Disscount' : "خصم",
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 14),
//                                 ),
//                                 Text(
//                                   discount,
//                                   style: TextStyle(
//                                       color: Colors.red, fontSize: 14),
//                                 )
//                               ],
//                             ),
//                           ),

//                           SizedBox(
//                             height: 15,
//                           ),

//                           Divider(
//                             color: Colors.black,
//                             thickness: 0.5,
//                             indent: 0.3,
//                           ),

//                           SizedBox(
//                             height: 15,
//                           ),

//                           Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   LanguageClass.isEnglish
//                                       ? 'Total Price'
//                                       : "السعر الكلي",
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 14),
//                                 ),
//                                 Text(
//                                   afterdiscount,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold),
//                                 )
//                               ],
//                             ),
//                           ),

//                           SizedBox(
//                             height: 20,
//                           ),

                            InkWell(
                              onTap: () {
                                if (stationtoid == '' ||
                                    stationto == '' ||
                                    packageID == '') {
                                  Constants.showDefaultSnackBar(
                                      color: Colors.red,
                                      context: context,
                                      text: LanguageClass.isEnglish
                                          ? 'Please Select all fields'
                                          : 'الرجاء تحديد كافة الملفات');
                                } else {
                                  showGeneralDialog(
                                    context: context,
                                    pageBuilder: (BuildContext buildContext,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.all(20),
                                          padding: EdgeInsets.all(30),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        Icon(Icons.arrow_back),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    packagname,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Expanded(
                                                  child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? 'Terms and conditions regarding to packages'
                                                        : "الشروط والأحكام الخاصة بالباقات",
                                                    textDirection:
                                                        LanguageClass.isEnglish
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 23,
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? '''1.) Review the purchase process before confirming.
2.) Select the appropriate package based on the number of days intended for attending the university.
3.) The term package offers the lowest cost for the trip, featuring a discount rate of over 50%.
4.) The count of trips refers to the round trip, not the number of days.
5.) If the package concludes, it is possible to purchase another one.
6.) The package expires either when the specified number of trips is completed or at the end of a semester.
7.) Subsidiary schedules have a priority for reservation through the application, where your seat is always available in the main schedules without reservation, with a fine applied for not making a prior reservation.
8.) It is possible to modify routes and schedules on exceptional school days, and more than one university can be included on the same bus route.
9.) Subscription is canceled immediately in case of violating company rules without prior warning, and accountability is based on the number of trips under the daily payment system
        '''
                                                        : ''' ١.) قم بمراجعة عملية الشراء قبل التأكيد.
٢.) اختر الباقة المناسبة بناءً على عدد الأيام المخصصة لحضور الجامعة.
٣.) تقدم باقة الفصل الدراسي التكلفة الأدنى للرحلة، بخصم يتجاوز 50٪.
٤.) يشير عدد الرحلات إلى رحلة الذهاب والعودة، وليس عدد الأيام.
٥.) في حال انتهاء الباقة، يمكن شراء باقة أخرى.
٦.) تنتهي صلاحية الباقة إما عند استكمال العدد المحدد من الرحلات أو في نهاية الفصل الدراسي.
٧.) تحظى المواعيد الفرعية بأولوية الحجز عبر التطبيق، حيث يظل مقعدك متوفرًا دائمًا في المواعيد الرئيسية بدون حجز وتُطبق غرامة في حال عدم الحجز المسبق.
٨.) يُمكن تعديل الخطوط والمواعيد في الأيام الدراسية الاستثنائية، ويُمكن ضم أكثر من جامعة على نفس مسار الأتوبيس.
٩.) يتم إلغاء الاشتراك فورًا في حالة مخالفة قواعد الشركة دون إنذار مسبق، وتُحاسب على عدد الرحلات بنظام الدفع اليومي.
        ''',
                                                    textDirection:
                                                        LanguageClass.isEnglish
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff818181),
                                                        fontSize: 14,
                                                        fontFamily: "regular"),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? 'Return and Exchange Policy'
                                                        : " سياسة الارجاع وتبديل الباقات",
                                                    textDirection:
                                                        LanguageClass.isEnglish
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: "bold"),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? '''1.) If there is a desire to exchange for another package or obtain a refund for the package, the cancellation must be initiated within a maximum of 14 days from the date of purchasing the package.
2.) Package can not be canceled after using.
3.) There will be a 2.5% discount upon cancellation for administrative fees
        '''
                                                        : ''' ١.) إذا كان هناك رغبة في التبديل لباقة أخرى أو الحصول على استرداد للباقة، يجب أن يتم الإلغاء في فترة أقصاها 14 يومًا من تاريخ شراء الباقة.
٢.) لا يجوز إلغاء الباقة بعد بداية الإستخدام
٣.) يتم هناك خصم 2.5% عند الإلغاء مصاريف ادارية
        ''',
                                                    textDirection:
                                                        LanguageClass.isEnglish
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff818181),
                                                        fontSize: 14,
                                                        fontFamily: "regular"),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? 'Penalties are imposed in the following cases'
                                                        : "تُفرض الغرامات في الحالات التالية",
                                                    textDirection:
                                                        LanguageClass.isEnglish
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: "bold"),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    LanguageClass.isEnglish
                                                        ? '''1.) Boarding the bus without a prior reservation.
2.) Making a prior reservation and not boarding the bus without modification or cancellation of the reservation.

        '''
                                                        : '''١.) استقلال الأتوبيس دون حجز مسبق.
٢.) إجراء حجز مسبق وعدم استقلال الأتوبيس دون تعديل أو إلغاء الحجز.

        ''',
                                                    textDirection:
                                                        LanguageClass.isEnglish
                                                            ? TextDirection.ltr
                                                            : TextDirection.rtl,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff818181),
                                                        fontSize: 14,
                                                        fontFamily: "regular"),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Routes.Amount =
                                                          afterdiscount;
                                                      Routes.ToStationID =
                                                          stationtoid;

                                                      Routes.PackageID =
                                                          packageID;

                                                      Routes.FromStationID =
                                                          stationfromid;
                                                      Navigator.pop(context);

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  packagePaymentScreen()));
                                                    },
                                                    child: Container(
                                                      height: 65,
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff1752D3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        LanguageClass.isEnglish
                                                            ? 'Agree and save'
                                                            : 'موافقة وحفظ',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 24,
                                                            fontFamily: "bold"),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    barrierDismissible: true,
                                    barrierLabel:
                                        MaterialLocalizations.of(context)
                                            .modalBarrierDismissLabel,
                                    barrierColor: Colors.black.withOpacity(0.1),
                                    transitionDuration:
                                        const Duration(milliseconds: 0),
                                  );
                                }
                              },
                              child: Container(
                                height: 65,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(41),
                                ),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? 'Subscribe'
                                      : "اشتراك",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ))
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
