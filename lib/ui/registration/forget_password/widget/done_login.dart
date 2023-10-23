import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utilts/My_Colors.dart';
import 'package:swa/ui/component/custom_Button.dart';

class DoneLogin extends StatelessWidget {
  const DoneLogin({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height:sizeHeight * 0.15),
            SvgPicture.asset("assets/images/Swa Logo.svg"),
            SizedBox(height:sizeHeight * 0.15),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColors.yellow,
                shape: BoxShape.circle,
              ),
                child: Icon(Icons.check,size: 40,color: MyColors.primaryColor,)),
            SizedBox(height:sizeHeight * 0.15),
            CustomBottun(text: "Login"),


          ],
        ),
      ),
    );
  }
}
