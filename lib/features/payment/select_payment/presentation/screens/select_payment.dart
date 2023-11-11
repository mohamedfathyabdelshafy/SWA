import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/features/payment/credit_card/presentation/screens/credit_card.dart';
import 'package:swa/features/payment/electronic_wallet/presentation/screens/electronic_screens.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';


class SelectPaymentScreen extends StatefulWidget {
  const SelectPaymentScreen({super.key});

  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              "Select payment" ,
              style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily: "bold"),
            ),
            const SizedBox(height: 37,),


            const SizedBox(height: 17,),
            InkWell(
              onTap: () async {
                // // itemcount ++;
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) {
                //     return CreditCardPayView(
                //       index: 1,
                //     );
                //   },
                // ));


                // name = await Navigator.push<String>(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return AddCreditCard();
                //     },
                //   ),
                // );
                // month = await Navigator.push<String>(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return AddCreditCard();
                //     },
                //   ),
                // );
                // cardHolder = await Navigator.push<String>(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return AddCreditCard();
                //     },
                //   ),
                // );

                // if (card is CardModel) {
                //  cards.add(card);
                //   setState(() {});
                // }

                Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return const AddCreditCard();
                    }));

              },
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/visa.png',
                    height: 50,
                    width: 45,
                    fit: BoxFit.fitWidth,
                  ),
                  Image.asset(
                    'assets/images/master_card.png',
                    height: 50,
                    width: 45,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  customText("Debit or credit card")
                ],
              ),
            ),
            const SizedBox(height: 17,),
            InkWell(
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return FawryScreen();
                    }));
              },
              child: Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: AppColors.yellow2,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color:const Color(0xff4587FF))
                    ),
                    child: SvgPicture.asset(
                      'assets/images/Group 97.svg',
                      // height: 60,
                      // width: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  customText("Pay Fawry")
                ],
              ),
            ),
            const SizedBox(height: 17,),

            // const Divider(
            //   color: Colors.black54,
            // ),

            // const Divider(
            //   color: Colors.black54,
            // ),
            InkWell(
              onTap: () {
                //Navigator.pop(context);


                Navigator.push(context, MaterialPageRoute(builder: (contex){
                  return const ElectronicScreen();
                }));
              },
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/icons8-open-wallet-78.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  customText("Electronic wallet")
                ],
              ),
            ),
            // SizedBox(height: 17,),
            // InkWell(
            //   onTap: () {
            //     // Navigator.push(context, MaterialPageRoute(builder: (context){
            //     //   return InstallmentScreen();
            //     // }));
            //   },
            //   child: Row(
            //     children: [
            //       SizedBox(width: 7,),
            //       Container(
            //         height : 30,
            //         width: 30,
            //         child: SvgPicture.asset(
            //           'assets/images/CreditCard.svg',
            //           fit: BoxFit.fitWidth,
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 10,
            //       ),
            //       customText("Installment")
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }


  Widget customText(text){
    return Text(
      text,
      style: const TextStyle
        (
          color: Colors.white,
          fontSize: 21,
          fontFamily:"regular"
      ),
    );
  }
}