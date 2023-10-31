import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/core/utilts/My_Colors.dart';
import 'package:swa/core/utilts/styles.dart';
import 'package:swa/ui/component/custom_Button.dart';
import 'package:swa/ui/screen/payment/add_card.dart';

class MyCredit extends StatelessWidget {
  const MyCredit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: MyColors.primaryColor,
            size: 30,
          ),
        ),
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.black,

      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text(
             "My wallet",
              style: fontStyle(color: MyColors.white,fontSize: 34,fontFamily: FontFamily.bold),
            ),
            Spacer(flex: 1,),
            Text(
              "Your Credit" ,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 20,
                color: MyColors.darkGrey
              ),
            ),
            Text(
              "EGP2,343",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 31,
                color: MyColors.white
              ),),
            Spacer(flex: 7,),

        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AddCreditCard();
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding:  EdgeInsets.symmetric(horizontal: 20,vertical:20),
              //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
              decoration:BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(10)
              ) ,
              child: Center(
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: MyColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),
                ),
              ),
            ),
          ),
        )
            //Spacer(flex: 7,)

          ],
        ),

      ),
    );
  }
}
