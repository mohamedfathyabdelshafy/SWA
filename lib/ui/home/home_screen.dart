import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/utilts/My_Colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.darkPurple,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor:MyColors.primaryColor, // Color for the selected tab icon and label
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          color: MyColors.primaryColor
        ),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/Icon awesome-bus.svg",
            ),
            label: "Book Now"
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/Icon awesome-ticket-alt.svg",
            ),
            label: "Ticket"
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/images/Icon material-person-outline.svg",
              ),
              label: "Account",

          ),BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/images/Group 175.svg",
                ),
              ),
              label: "More"
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              //fit:BoxFit,
              children: [
                Container(

                  width: double.infinity, // Take the full width of the screen
                  child: Image.asset(
                    "assets/images/oranaa.agency_85935_luxor_landscape_and_sky_with_ballons_on_sky_e8ecb03c-2e93-4118-abed-39447bd055c9.png",
                    fit: BoxFit.cover,
                    // Maintain the aspect ratio
                  ),
                ),
                Center(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height:sizeHeight *0.10 ,),
                      SvgPicture.asset(
                        "assets/images/Swa Logo.svg",
                        height: sizeHeight * 0.06,
                        width: sizeWidth *0.06,
                      ),
                      SizedBox(height:sizeHeight * 0.06,),
                      Row(
                        children: [
                          Container(
                            height:sizeHeight *0.12,
                            width: sizeWidth * 0.45,
                            decoration: BoxDecoration(
                              color:MyColors.darkPurple,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/arrow_one_way.svg",
                                ),
                                SizedBox(height: 10,),
                                Text("One way",
                                style: TextStyle(
                                  color: MyColors.white,
                                  fontSize: 18,

                                ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: sizeWidth *0.02,),
                          Container(
                            height:sizeHeight *0.12,
                            width: sizeWidth * 0.45,
                            decoration: BoxDecoration(
                                color:MyColors.primaryColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/bus.svg",
                                ),
                                SizedBox(height: 10,),
                                Text("Round Trip",
                                  style: TextStyle(
                                    color: MyColors.white,
                                    fontSize: 18,

                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),

              ],
            ),


          ],
        ),
      ),
    );
  }
}
