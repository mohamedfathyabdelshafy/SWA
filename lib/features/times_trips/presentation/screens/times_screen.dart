import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/media_query_values.dart';

import '../../../../core/utils/app_colors.dart';
import '../widgets/trip_details.dart';

class TimesScreen extends StatelessWidget {
  const TimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;

    return Scaffold(
      body: Container(
        color: Colors.black,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             Stack(
               children: [
                 SizedBox(
                   width: double.infinity, // Take the full width of the screen
                   child: Image.asset(
                     "assets/images/oranaa.agency_85935_Ein_Sokhna_Sunset_5f6b0765-1585-4ef7-bb6a-484963505b20.png",
                     fit: BoxFit.cover,
                     // Maintain the aspect ratio
                   ),
                 ),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     SizedBox(height:sizeHeight *0.10 ,),
                     SvgPicture.asset(
                       "assets/images/Swa Logo.svg",
                       height: sizeHeight * 0.06,
                       width: sizeWidth *0.06,
                     ),
                     SizedBox(height:sizeHeight * 0.15,),

                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                       child: Row(
                         children: [
                           Column(
                             children: [
                               Row(
                                 children: [
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

                           Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(
                                   "03h 20m",
                                   style: TextStyle(color: AppColors.white,fontSize: 20 )),
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 20),
                                 width:sizeWidth *0.5 ,
                                 child: const Divider(
                                   color: Colors.white,
                                   thickness: 2, // Adjust the thickness of the divider
                                  // height: 100,
                                   // Adjust the height of the divider
                                 ),
                               ),
                             ],
                           ),
                           Column(
                             children: [
                               Row(
                                 children: [
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
                   ],
                 )
               ],

             ),

           ],
         ),
      ),
    );
  }
}
