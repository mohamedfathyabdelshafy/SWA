import 'package:flutter/material.dart';
import 'package:swa/core/utils/media_query_values.dart';

import '../../../../core/utils/app_colors.dart';

class TripDetails extends StatelessWidget {
  const TripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Scaffold(
      body: Container(
        height: 100,
        width: 200,
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range_outlined,color: AppColors.white,size: 16,),
                    SizedBox(width: sizeWidth * 0.01,),
                    Text("Zagazig",
                      style: TextStyle(color: AppColors.white,fontSize:12 ),)
                  ],
                ),
                Text(
                    "10:00 AM",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.white,fontSize: 20 )),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range_outlined,color: AppColors.white,size: 16,),
                    SizedBox(width: sizeWidth * 0.01,),
                    Text("Ein Sokhna",
                      style: TextStyle(color: AppColors.white,fontSize:12 ),)
                  ],
                ),
                InkWell(

                  child: Text(
                      "01:20 AM",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.white,fontSize: 20 )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
