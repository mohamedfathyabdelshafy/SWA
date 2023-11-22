import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/media_query_values.dart';
import '../../../../../core/local_cache_helper.dart';
import '../../../../../core/utils/constants.dart';
import '../../../electronic_wallet/presentation/cubit/eWallet_cubit.dart';
import '../../../fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import '../../model/card_model.dart';
import 'credit_card.dart';


class CreditCardPayView extends StatefulWidget {
 int index;

 CreditCardPayView({super.key, required this.index});

   @override
  State<CreditCardPayView> createState() => _CreditCardPayViewState();
}

class _CreditCardPayViewState extends State<CreditCardPayView> {
  final price =CacheHelper.getDataToSharedPref(key: 'price');

  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  List<CardModel> cards=[];
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showCardBack = false;
  int  selectedIndex = 0;
  FocusNode cardHolderNameNode = FocusNode();
  FocusNode cardNumberNode = FocusNode();
  FocusNode amountNode = FocusNode();
  FocusNode cardDateNode = FocusNode();
  FocusNode cvvNode = FocusNode();

  @override
  void initState() {
    // final jsonData = json.decode(CacheHelper.getDataToSharedPref(key: 'cards'));
    final jsonData = CacheHelper.getDataToSharedPref(key: 'cards');
    print(jsonData.runtimeType);
    print(jsonData);
    print("EEeeeeeeeeeeeeeeeeeeeeeeeee");

    if(jsonData != null &&jsonData is String) {
      cards = json.decode(jsonData).map<CardModel>((e) => CardModel.fromJsom(e)).toList();
    }
    print("cached cards ${cards}");
    super.initState();
  }


  @override
  void dispose() {
    cardHolderName.dispose();
    cardNumberNode.dispose();
    amountNode.dispose();
    cardDateNode.dispose();
    cvvNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = context.height;

        return Scaffold(
backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:  Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryColor,
                  size: 32,
                )),

          ),
          body: Form(
                  key: formKey,
                  child: SizedBox(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 35),
                                child: SingleChildScrollView(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.85,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Payment',
                                          style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 30,
                                              fontFamily: "bold"),
                                        ),
                                        const SizedBox(height: 40),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: AppColors.white,
                                              border: Border.all(color: AppColors.grey),
                                             borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/master_card.png',
                                                height: 11,
                                                width: 17,
                                                fit: BoxFit.fitWidth,
                                              ),
                                              const  SizedBox(width: 5,),
                                              (widget.index >= 0 && cards.isNotEmpty)?
                                              InkWell(
                                                onTap: () {
                                                  showModalBottomSheet(

                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(30),
                                                        child: Container(
                                                          height: 270,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                 'Choose Card',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: "bold",
                                                                    color: AppColors.blackColor
                                                                ),
                                                              ),
                                                              const SizedBox(height: 5,),
                                                              Divider(thickness:0.5,color: AppColors.grey),
                                                              Column(
                                                                children: List<Widget>.generate(cards.length, (index) {
                                                                  return Column(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () {
                                                                          Navigator.pop(context);
                                                                          setState(() {
                                                                            widget.index = index;
                                                                          });
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Checkbox(
                                                                                value:
                                                                                widget.index==index?true :false,
                                                                                activeColor: Colors.yellow,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(100)
                                                                                ),
                                                                                onChanged: (value) {},
                                                                            ),
                                                                            Image.asset(
                                                                              'assets/images/master_card.png',
                                                                              height: 11,
                                                                              width: 17,
                                                                              fit: BoxFit.fitWidth,
                                                                            ),

                                                                            Text(
                                                                              "XXXX-XXXX-XXXX-${cards[index].cardNumber!.substring(cards[index].cardNumber!.length - 4)}",
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontFamily:"regular",
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  if (index >= 0 && index < cards.length) {
                                                                                    cards.removeAt(index);
                                                                                  }
                                                                                  // cards.removeAt(index);
                                                                                  CacheHelper.setDataToSharedPref(
                                                                                    key:"cards",
                                                                                    value:json.encode(
                                                                                      cards.map((e) => e.toJson()).toList(),
                                                                                    ),
                                                                                  );
                                                                                  Navigator.pop(context);
                                                                                  //  Navigator.pop(context);
                                                                                });
                                                                                CacheHelper.setDataToSharedPref(
                                                                                  key:"cards",
                                                                                  value:json.encode(
                                                                                    cards.map((e) => e.toJson()).toList(),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: Icon(Icons.delete),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                }),
                                                              ),
                                                              Divider(thickness:0.5,color: AppColors.grey),
                                                              Row(
                                                                children: [
                                                                  SizedBox(width: sizeWidth * 0.03,),
                                                                  Container(
                                                                      decoration:BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: AppColors.grey
                                                                      ),
                                                                      child:const Icon(Icons.add,color:Colors.lightGreen,size: 20,)),
                                                                  SizedBox(width: sizeWidth * 0.03,),
                                                                  InkWell(
                                                                    onTap: ()async{
                                                                      Navigator.pop(context);
                                                                      final card = await Navigator.push<CardModel>(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) {
                                                                            return const AddCreditCard(
                                                                            );
                                                                          },
                                                                        ),
                                                                      );
                                                                      if (card is CardModel) {
                                                                        cards.add(card);
                                                                        setState(() {});
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                       'Add New Card',
                                                                      style: TextStyle(
                                                                          fontSize: 15.45,
                                                                          fontFamily: "bold",
                                                                          color: AppColors.blackColor
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      (widget.index >= 0 && widget.index < cards.length)
                                                          ? "XXXX-XXXX-XXXX-${cards[widget.index].cardNumber!.substring(cards[widget.index].cardNumber!.length - 4)}"
                                                          : "Choose Card",
                                                      style:const TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:"regular",
                                                          color: Colors.black),
                                                    ),
                                                  const  SizedBox(width: 15,),
                                                    const Icon(Icons.keyboard_arrow_down_outlined,size: 30,)
                                                  ],
                                                ),
                                              ):
                                              InkWell(
                                                onTap: ()async{
                                                  //Navigator.pop(context);
                                                  final card = await Navigator.push<CardModel>(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return AddCreditCard(
                                                        );
                                                      },
                                                    ),
                                                  );
                                                  if (card is CardModel) {
                                                    cards.add(card);
                                                    setState(() {});
                                                  }
                                                },
                                                child: Text(
                                                  'Add credit Card',
                                                  style: TextStyle(
                                                      fontSize: 15.45,
                                                      fontFamily: "bold",
                                                      color: AppColors.blackColor
                                                  ),
                                                ),
                                              )


                                            ],
                                          ),
                                        ),


                                        const  SizedBox(
                                          height: 20,
                                        ),
                                        (widget.index >= 0 && cards.isNotEmpty)?
                                        PayField(
                                          height: 20,
                                          width: 1,
                                          color:const Color(0xff47A9EB) ,
                                          hint: 'CVV',
                                          textInputType: TextInputType.number,
                                          onChange: (value) {
                                            setState(() {
                                              showCardBack = true;
                                              cvv = value;
                                            });
                                          },
                                          focusNode: cvvNode,
                                          maxLength: 3,
                                          onFieldSubmitted: (value) {
                                            setState(() {
                                              showCardBack = false;
                                              amountNode.requestFocus();
                                            });
                                          },
                                        ):const SizedBox(),
                                        (widget.index >= 0 && cards.isNotEmpty)?
                                        Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 1,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xffD865A4)
                                              ),
                                            ),
                                            Container(
                                                height:sizeHeight * 0.07,
                                                width:300,
                                                padding:
                                                const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                                                decoration: const BoxDecoration(
                                                  // border: Border.all(
                                                  //   color: AppColors.blue,
                                                  //   width: 0.3,
                                                  // ),
                                                  // borderRadius:
                                                  // const BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text(
                                                      "amount",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "bold",
                                                          color: AppColors.greyLight
                                                      ),
                                                    ),
                                                    Text(
                                                      price.toString(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontFamily: "bold",
                                                          color: AppColors.primaryColor
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          ],
                                        )
                                            :const SizedBox(),
                                        const Spacer(),
                                        BlocListener(
                                          bloc: BlocProvider.of<FawryReservation>(context),
                                          listener: (context, state) {
                                            if(state is EWalletLoadingState){
                                              Constants.showLoadingDialog(context);
                                            }else if (state is EWalletLoadedState) {
                                              Constants.hideLoadingDialog(context);
                                              Constants.showDefaultSnackBar(context: context, text: state.paymentMessageResponse.paymentMessage!.statusDescription);

                                            }else if (state is EWalletErrorState) {
                                              Constants.hideLoadingDialog(context);
                                              Constants.showDefaultSnackBar(context: context, text: state.error.toString());
                                            }
                                          },
                                          child: InkWell(
                                            onTap: () {
                                              print( cards[widget.index].cardNumber!.toString().replaceAll(" ", ""));
                                              if (formKey.currentState!.validate()) {
                                                final tripOneId = CacheHelper.getDataToSharedPref(key: 'tripOneId');
                                                final tripRoundId = CacheHelper.getDataToSharedPref(key: 'tripRoundId');
                                                final seatIdsOneTrip = CacheHelper.getDataToSharedPref(key: 'countSeats')?.map((e) => int.tryParse(e) ?? 0).toList();
                                                final seatIdsRoundTrip = CacheHelper.getDataToSharedPref(key: 'countSeats2')?.map((e) => int.tryParse(e) ?? 0).toList();
                                                final price =CacheHelper.getDataToSharedPref(key: 'price');

                                                print("tripOneId${tripOneId}==tripOneId${tripRoundId }=====${seatIdsOneTrip}===${seatIdsRoundTrip}==$price");

                                                // if(_user != null && formKey.currentState!.validate()) {
                                                BlocProvider.of<FawryReservation>(context).addReservation(
                                                  seatIdsOneTrip:seatIdsOneTrip ,
                                                  custId: 4,
                                                  oneTripID:tripOneId.toString(),
                                                  paymentMethodID: 4,
                                                  paymentTypeID: 68,
                                                  seatIdsRoundTrip:seatIdsRoundTrip??[],
                                                  roundTripID:tripRoundId.toString(),
                                                  amount:price.toStringAsFixed(2).toString(),
                                                  cvv:cvv.toString() ,
                                                  cardNumber: cards[widget.index].cardNumber!.toString().replaceAll(" ", "") ,
                                                  cardExpiryYear: cards[widget.index].month!.substring(0, 2).toString(),
                                                  cardExpiryMonth: cards[widget.index].month!.substring(3,).toString() ,
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(25),
                                              child: Container(
                                                width: 200,
                                                height:70,
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                ),
                                                child: Container(
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.primaryColor,
                                                      borderRadius: BorderRadius.circular(15)),
                                                  child:const Center(
                                                    child: Padding(
                                                      padding:  EdgeInsets.all(8.0),
                                                      child: Text(
                                                         'Charge',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold
                                                            ,fontFamily: "bold"  ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
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
                    ),
                  ),
                ),
              );

  }
}

class PayField extends StatelessWidget {
   PayField(
      {
      required this.hint,
      required this.onChange,
      this.ctr,
      this.maxLength,
      this.focusNode,
      this.textInputType,
      this.onFieldSubmitted,
      this.height,
        required this.color,
        this.width
      });
  final TextEditingController? ctr;
  final String hint;
  final Function onChange;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final Function? onFieldSubmitted;
  final double? height;
  final double? width;
  final Color color;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: color

          ),
        ),
        const SizedBox(width: 5,),
         SizedBox(
          height: 60,
          width: 265,

          child: TextFormField(
              controller: ctr,
              keyboardType: textInputType,
              // style: fontStyle(color: MyColors.blue, fontSize: 14),
              // cursorColor: MyColors.blue,
              decoration: InputDecoration(
                hintText: hint,

                border: InputBorder.none,
               // errorStyle: fontStyle(color: Colors.red, fontSize: 12),
                hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontFamily: "bold"),
                labelStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontFamily: "bold"),
                // contentPadding: const EdgeInsets.symmetric(
                //   horizontal: 10,
                //   vertical: 5,
                // ),
               // counterText: "",
              ),
              maxLength: maxLength ?? 16,
              onChanged: (value) => onChange(value),
              focusNode: focusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This Field is Required';
                } else {
                  return null;
                }
              },
              onFieldSubmitted: (value) {
                if (onFieldSubmitted != null) {
                  onFieldSubmitted!(value);
                }
              }),
        ),
        const Icon(
          Icons.info_rounded,
          color: Color(0xff616B80),
          size: 2,
        )      ],
    );
  }
}




