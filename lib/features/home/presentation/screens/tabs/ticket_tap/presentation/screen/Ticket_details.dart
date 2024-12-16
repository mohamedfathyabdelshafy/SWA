import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';

import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Ticketdetails_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/repo/ticket_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_state.dart';
import 'package:swa/main.dart';

class TicketdetailsScreen extends StatefulWidget {
  Message ticketdetails;
  TicketdetailsScreen({super.key, required this.ticketdetails});
  @override
  State<TicketdetailsScreen> createState() => _TicketdetailsScreenState();
}

class _TicketdetailsScreenState extends State<TicketdetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryColor,
                    size: 34,
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "${widget.ticketdetails.serviceType!}  #${widget.ticketdetails.ticketNumber!}",
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontFamily: "bold"),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          LanguageClass.isEnglish
                              ? "Customer Name"
                              : "اسم العميل",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontFamily: "bold"),
                        ),
                      ),
                      Text(
                        widget.ticketdetails.customerName!,
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontFamily: "regular"),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          LanguageClass.isEnglish ? "Phone" : " دقم الهاتف",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontFamily: "bold"),
                        ),
                      ),
                      Text(
                        widget.ticketdetails.customerPhone!,
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontFamily: "regular"),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          LanguageClass.isEnglish ? "From" : " من",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontFamily: "bold"),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.ticketdetails.from!,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: "regular"),
                        ),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          LanguageClass.isEnglish ? "To" : " الي",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontFamily: "bold"),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.ticketdetails.to!,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: "regular"),
                        ),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          LanguageClass.isEnglish
                              ? "Trip date"
                              : " تاريخ الرحلة",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontFamily: "bold"),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.ticketdetails.tripDate!,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: "regular"),
                        ),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          LanguageClass.isEnglish ? "Trip time" : " وقت الرحلة",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontFamily: "bold"),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.ticketdetails.accessBusTime!,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: "regular"),
                        ),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          LanguageClass.isEnglish
                              ? "Seat Numbers"
                              : "رقم الكراسي",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontFamily: "bold"),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.ticketdetails.seatNumbers.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: "regular"),
                        ),
                      ),
                    ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          LanguageClass.isEnglish ? "Price" : "السعر",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontFamily: "bold"),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.ticketdetails.price.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: "regular"),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.darkGrey),
                        child: Text(
                          LanguageClass.isEnglish ? "Policy" : "الخصوصية",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: "bold"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.darkPurple),
                        child: Text(
                          LanguageClass.isEnglish ? "Download" : "تنزيل",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: "bold"),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
