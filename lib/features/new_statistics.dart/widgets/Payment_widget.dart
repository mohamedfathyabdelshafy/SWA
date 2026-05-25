import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:intl/intl.dart' as intl;

import 'package:swa/features/new_statistics.dart/model/All_statics_model.dart';
import 'package:swa/features/payment/select_payment/presentation/screens/select_payment.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';

Widget paymentWidget(
    {required AllStaticsModel allStatics,
    required String walletbalance,
    required BuildContext context}) {
  return StatefulBuilder(builder: (context, setState) {
    AllStaticsModel allStaticsModel = allStatics;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryColor,
                )),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                      child: SvgPicture.asset(
                        "assets/images/wallet.svg",
                        color: AppColors.primaryColor,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      LanguageClass.isEnglish
                          ? "Current Balance"
                          : "رصيد المحفظة الحالي",
                      style: fontStyle(
                          fontSize: 14.sp,
                          fontFamily: FontFamily.bold,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor),
                    )
                  ],
                ),
                10.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "$walletbalance ${Routes.curruncy}",
                    style: fontStyle(
                        fontSize: 16.sp,
                        fontFamily: FontFamily.bold,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    " ${LanguageClass.isEnglish ? "Last update of the day" : "اخر تحديث اليوم"}",
                    style: fontStyle(
                        fontSize: 12.sp,
                        fontFamily: FontFamily.regular,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor),
                  ),
                ),
                10.verticalSpace,
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlocProvider<ReservationCubit>(
                                    create: (context) => ReservationCubit(),
                                    child:
                                        SelectPaymentScreen(user: Routes.user),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green),
                                child: Text(
                                  LanguageClass.isEnglish
                                      ? "charge  +"
                                      : "شحن  +",
                                  style: fontStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.w600),
                                )))),
                  ],
                ),
              ],
            ),
          ),
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.trending_up_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LanguageClass.isEnglish
                                ? "Total Deposits"
                                : "اجمالي الايداعات",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyle(
                              color: Colors.blue,
                              fontSize: 12.sp,
                              fontFamily: FontFamily.regular,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${allStaticsModel.message!.payments!.fold(0.0, (double previousValue, Payment element) => previousValue + (element.statusId == 22 ? element.amount! : 0))}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyle(
                              color: Colors.blue,
                              fontSize: 16.sp,
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            Routes.curruncy.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyle(
                              color: Colors.blue,
                              fontSize: 12.sp,
                              fontFamily: FontFamily.regular,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
              10.horizontalSpace,
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.brown[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.trending_down_outlined,
                        color: Colors.brown,
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LanguageClass.isEnglish
                                ? "Total Withdrawals"
                                : "اجمالي المسحوبات",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyle(
                              color: Colors.brown,
                              fontSize: 12.sp,
                              fontFamily: FontFamily.regular,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${allStaticsModel.message!.refunds!.fold(0.0, (double previousValue, Refund element) => previousValue + element.amount!)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyle(
                              color: Colors.brown,
                              fontSize: 16.sp,
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            Routes.curruncy.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyle(
                              color: Colors.brown,
                              fontSize: 12.sp,
                              fontFamily: FontFamily.regular,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
          20.verticalSpace,
          // Container(
          //   padding: EdgeInsets.all(10.w),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(8),
          //     border: Border.all(color: Colors.grey),
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Container(
          //             width: 20.w,
          //             child: SvgPicture.asset(
          //               "assets/images/Filter-24px.svg",
          //             ),
          //           ),
          //           5.horizontalSpace,
          //           Text(
          //             LanguageClass.isEnglish ? "Transaction Period" : "فترة المعاملات",
          //             style: fontStyle(
          //                 fontSize: 14.sp,
          //                 fontFamily: FontFamily.bold,
          //                 fontWeight: FontWeight.w600,
          //                 color: AppColors.blackColor),
          //           )
          //         ],
          //       ),
          //       10.verticalSpace,
          //       TextFormField(
          //           decoration: InputDecoration(
          //               prefixIcon: Icon(Icons.search_rounded),
          //               hintText: LanguageClass.isEnglish ? "Search in transactions" : "البحث في المعاملات",
          //               border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey)))),
          //       10.verticalSpace,
          //       Container(
          //           alignment: Alignment.center,
          //           child: DropDownTextField(
          //               padding: EdgeInsets.zero,
          //               initialValue: "${LanguageClass.isEnglish ? "All Types " : "جميع الانواع"}",
          //               onChanged: (value) {
          //                 print(value);

          //                 if (value.value == "Deposit") {
          //                   allStaticsModel.message!.payments =
          //                       allStatics.message!.payments?.where((element) => element.statusId == 22).toList();
          //                 } else if (value.value == "Withdrawal") {
          //                   allStaticsModel.message!.payments = allStatics.message!.payments
          //                       ?.where((element) =>
          //                           element.statusId == 23 || element.statusId == 27 || element.statusId == 25)
          //                       .toList();
          //                 } else {
          //                   allStaticsModel.message!.payments = allStatics.message!.payments!;
          //                 }

          //                 print(allStatics.message!.payments!.length);
          //                 setState(() {});

          //                 // allStaticsModel.message.payments.where(test)
          //               },
          //               autovalidateMode: AutovalidateMode.onUserInteraction,
          //               textFieldDecoration: InputDecoration(
          //                 fillColor: Colors.white,
          //                 enabledBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(8),
          //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
          //                 disabledBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(8),
          //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
          //                 border: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(8),
          //                     borderSide: BorderSide(color: Colors.grey, width: 1)),
          //                 filled: true,
          //                 iconColor: Colors.red,
          //                 contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 25),
          //                 suffixIcon: Icon(
          //                   Icons.keyboard_arrow_down_rounded,
          //                   color: Color(0xff898989),
          //                 ),
          //                 hintText: '${LanguageClass.isEnglish ? "All Types " : "جميع الانواع"}',
          //                 errorStyle: fontStyle(
          //                     fontSize: 10.sp,
          //                     fontFamily: FontFamily.regular,
          //                     fontWeight: FontWeight.w500,
          //                     color: Colors.red),
          //                 hintStyle: fontStyle(
          //                   color: Color(0xffA2A2A2),
          //                   fontFamily: FontFamily.medium,
          //                   height: 1.2,
          //                   fontSize: 14.sp,
          //                   fontWeight: FontWeight.normal,
          //                 ),
          //               ),
          //               readOnly: true,
          //               validator: (value) {
          //                 return null;
          //               },
          //               listTextStyle: fontStyle(
          //                 color: Colors.black,
          //                 fontFamily: FontFamily.medium,
          //                 height: 1.2,
          //                 fontSize: 14.sp,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //               textStyle: fontStyle(
          //                 color: Colors.black,
          //                 fontFamily: FontFamily.medium,
          //                 height: 1.2,
          //                 fontSize: 14.sp,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //               dropDownList: [
          //                 DropDownValueModel(
          //                     name: LanguageClass.isEnglish ? "All Types" : "جميع الانواع", value: "All Types"),
          //                 DropDownValueModel(name: LanguageClass.isEnglish ? "Deposit" : "الدفع", value: "Deposit"),
          //                 DropDownValueModel(
          //                     name: LanguageClass.isEnglish ? "Withdrawal" : "السحب", value: "Withdrawal"),
          //               ])),
          //     ],
          //   ),
          // ),
          // 10.verticalSpace,
          Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          LanguageClass.isEnglish
                              ? "Transactions"
                              : "سجل المعاملات",
                          style: fontStyle(
                              fontSize: 14.sp,
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor),
                        ),
                        5.horizontalSpace,
                        Text(
                          "(${allStaticsModel.message!.payments!.length})",
                          style: fontStyle(
                              fontSize: 14.sp,
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor),
                        )
                      ],
                    ),
                    10.verticalSpace,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: allStaticsModel.message!.payments!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: Offset(0, 0),
                                    blurRadius: 10,
                                    spreadRadius: 0)
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 25.w,
                                height: 25.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[350]),
                                child: SvgPicture.asset(
                                    "assets/images/DollarSign-24px.svg"),
                              ),
                              5.horizontalSpace,
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allStaticsModel
                                          .message!.payments![index].description
                                          .toString(),
                                      style: fontStyle(
                                          color: AppColors.blackColor
                                              .withOpacity(0.6),
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    5.verticalSpace,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          intl.DateFormat('dd-MM-yyyy hh:mm a')
                                              .format(allStaticsModel
                                                  .message!
                                                  .payments![index]
                                                  .creationDate!)
                                              .toString(),
                                          style: fontStyle(
                                              fontSize: 12.sp,
                                              fontFamily: FontFamily.medium,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    allStaticsModel
                                        .message!.payments![index].amount!
                                        .toString(),
                                    style: fontStyle(
                                        fontSize: 14.sp,
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                  Text(
                                    Routes.curruncy!,
                                    style: fontStyle(
                                        fontSize: 12.sp,
                                        fontFamily: FontFamily.medium,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.7)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ]))
        ],
      ),
    );
  });
}
