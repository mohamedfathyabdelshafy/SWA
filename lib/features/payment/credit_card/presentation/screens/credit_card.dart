import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/styles.dart';


class AddCreditCard extends StatefulWidget {
  const AddCreditCard({super.key});

  @override
  State<AddCreditCard> createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController cardNumberController = TextEditingController();

  TextEditingController monthController = TextEditingController();

  TextEditingController cvvController = TextEditingController();

  TextEditingController cardHolderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor:Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:Colors.black,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
            size: 34,
          ),
        ),
      ),
      body:Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 55),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: SizedBox(
              height: sizeHeight * 0.9,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "Add Card",
                    style: fontStyle(color: AppColors.white,fontSize: 34,fontFamily: FontFamily.bold),
                  ),
                  const SizedBox(height: 37,),
                  Row(
                    children: [
                      Container(
                        height:sizeHeight * 0.07,
                        width: 1,
                        decoration: BoxDecoration(
                            color:AppColors.primaryColor
                        ),
                      ),
                      const SizedBox(width: 5,),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Card Number",
                              style: fontStyle(
                                  fontFamily: FontFamily.regular,
                                  fontSize: 21,
                                  color: AppColors.white
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset("assets/images/Repeat Grid 1.svg",color: AppColors.primaryColor,),
                                const SizedBox(width: 5,),
                                SizedBox(
                                  // color: Colors.red,
                                  height: sizeHeight * 0.065,
                                  width:sizeWidth * 0.54,
                                  child: TextFormField(
                                    maxLength: 19,
                                    style: const TextStyle(color: Colors.white, fontSize: 18),
                                    cursorColor: AppColors.white,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(16),
                                      CreditCardFormat(number: 4,char: " ")
                                    ],
                                    validator: (value){
                                      if(value == null ||value.isEmpty ){
                                        return  "Enter number card";
                                      }
                                      return null;
                                    },
                                    controller: cardNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(

                                        errorStyle: fontStyle(color: Colors.red, fontSize: 12),
                                        border: InputBorder.none,
                                        alignLabelWithHint: true,
                                        hintText: "Card Number",
                                        hintStyle: fontStyle(
                                            fontSize: 21,
                                            fontFamily: FontFamily.regular,
                                            color: const Color(0xffCCCCCC)
                                        )
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.info_rounded,
                                  color: Color(0xff616B80),
                                  size: 20,
                                )
                              ],
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizeHeight*0.02,),
                  SizedBox(

                    height: sizeHeight * 0.07,
                    width:  sizeWidth * 0.4,
                    //color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: sizeHeight * 0.03,
                          width: 1,
                          decoration: BoxDecoration(
                              color:AppColors.primaryColor

                          ),
                        ),
                        const SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  // color: Colors.red,
                                  height: sizeHeight * 0.065,
                                  width:sizeWidth *0.3,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white, fontSize: 18),

                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      CreditCardFormat(
                                          number: 2,
                                          char: "/"
                                      )
                                    ],
                                    maxLength: 5,
                                    validator: (value){
                                      if(value == null ||value.isEmpty  ){
                                        return "Enter month and year ";
                                      }
                                      return null;
                                    },
                                    controller: monthController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        alignLabelWithHint: true,
                                        hintText: "MM/YY" ,
                                        hintStyle: fontStyle(
                                            fontSize: 21,
                                            fontFamily: FontFamily.regular,
                                            color: const Color(0xffCCCCCC)
                                        )
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.info_rounded,
                                  color: Color(0xff616B80),
                                  size: 20,
                                )
                              ],
                            ),


                          ],
                        ),
                        Row(

                          children: [

                            const SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    SizedBox(
                                      // color: Colors.red,
                                      height: sizeHeight * 0.065,
                                      width:100,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        maxLength: 3,
                                        style: const TextStyle(color: Colors.white, fontSize: 18),

                                        validator: (value){
                                          if(value == null ||value.isEmpty ){
                                            return "Enter CVV" ;
                                          }
                                          return null;
                                        },
                                        controller: cvvController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            alignLabelWithHint: true,
                                            hintText: "CVV",
                                            hintStyle: fontStyle(
                                                fontSize: 21,
                                                fontFamily: FontFamily.regular,
                                                color: const Color(0xffCCCCCC)
                                            )
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.info_rounded,
                                      color: Color(0xff616B80),
                                      size: 20,
                                    )
                                  ],
                                ),


                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 1,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 5,),
                              SizedBox(
                                // color: Colors.red,
                                height: 50,
                                width:sizeWidth *0.54,
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null ||value.isEmpty ){
                                      return "Enter card holder";
                                    }
                                    return null;
                                  },

                                  controller: cardHolderController,
                                  style: const TextStyle(color: Colors.white, fontSize: 18),

                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      alignLabelWithHint: true,
                                      hintText: "Card Holder",
                                      hintStyle: fontStyle(
                                          fontSize: 21,
                                          fontFamily: FontFamily.regular,
                                          color: const Color(0xffCCCCCC)
                                      )
                                  ),
                                ),
                              ),
                              const SizedBox(width: 26),
                              const Icon(
                                Icons.info_rounded,
                                color: Color(0xff616B80),
                                size: 20,
                              )
                            ],
                          ),


                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Your payment information will be stores securely"
                    ,
                    style: fontStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 11,
                        color: const Color(0xff39A85B)
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const AddCreditCard();
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding:  const EdgeInsets.symmetric(horizontal: 20,vertical:20),
                        //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                        decoration:BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10)
                        ) ,
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,)

                ],
              ),
            ),
          ),
        ),
      ) ,

    );
  }
}

class CreditCardFormat extends TextInputFormatter{
  int number;
  String char;
  CreditCardFormat(
      {
        required this.number,
        required this.char
      }
      );
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }

    String enteredData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for(int i = 0 ; i <enteredData.length ; i++){
      buffer.write(enteredData[i]);
      int index = i+1;
      if(index % number == 0 && enteredData.length != index){
        buffer.write(char);
      }

    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length)
    );
  }

}