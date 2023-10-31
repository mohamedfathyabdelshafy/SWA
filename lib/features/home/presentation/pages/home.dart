import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/widgets/custom_drop_down_list.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTabbed = false;
  int currentIndex = 0;
  DateTime selectedDayFrom = DateTime.now();
  DateTime selectedDayTo = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: Container(
        height: sizeHeight * 0.09,
        child: Theme(
          data:Theme.of(context).copyWith(
            canvasColor: AppColors.darkPurple,),
          child: BottomNavigationBar(
            onTap: (index){
              setState(() {
                currentIndex =index;

              });
            },
            currentIndex: currentIndex,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedItemColor:AppColors.primaryColor, // Color for the selected tab icon and label
            unselectedItemColor: AppColors.darkGrey,
            selectedLabelStyle: TextStyle(
                color: AppColors.primaryColor
            ),
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/Icon awesome-bus.svg",
                    color:currentIndex == 0?AppColors.primaryColor:AppColors.darkGrey ,
                  ),
                  label: "Book Now"
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/images/Icon awesome-ticket-alt.svg",
                    color:currentIndex == 1 ?AppColors.primaryColor:AppColors.darkGrey ,
                  ),

                  label: "Ticket"
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/Icon material-person-outline.svg",
                  color:currentIndex == 2?AppColors.primaryColor:AppColors.darkGrey ,
                ),
                label: "Account",

              ),BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/images/Group 175.svg",
                      color:currentIndex == 3?AppColors.primaryColor:AppColors.darkGrey ,
                    ),
                  ),
                  label: "More"
              ),
            ],
          ),
        ),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          InkWell(
                            onTap: (){
                              setState(() {
                                isTabbed = !isTabbed;

                              });
                            },
                            child: Container(
                              height:sizeHeight *0.12,
                              width: sizeWidth * 0.45,
                              decoration: BoxDecoration(
                                  color:isTabbed?AppColors.darkPurple:AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/arrow_one_way.svg",
                                  ),
                                  const SizedBox(height: 10,),
                                  Text("One way",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18,

                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: sizeWidth *0.02,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                isTabbed = !isTabbed;

                              });
                            },
                            child: Container(
                              height:sizeHeight *0.12,
                              width: sizeWidth * 0.45,
                              decoration: BoxDecoration(
                                  color:isTabbed?AppColors.primaryColor:AppColors.darkPurple,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/bus.svg",
                                  ),
                                  const SizedBox(height: 10,),
                                  Text("Round Trip",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18,

                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: sizeHeight *0.02,),
                      const Padding(
                        padding:EdgeInsets.zero,
                        child: Text(
                          "From",
                          style: TextStyle(color: Colors.white,
                              fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const CustomDropDownList(hint: "Select",),
                      SizedBox(height: sizeHeight*0.07,),
                      const Padding(
                        padding:EdgeInsets.zero,
                        child: Text(
                          "To",
                          style: TextStyle(color: Colors.white,
                              fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const CustomDropDownList(hint: "Select",),
                      SizedBox(height: sizeHeight*0.03,),
                      Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.date_range_outlined,color: AppColors.white,size: 16,),
                                    SizedBox(width: sizeWidth * 0.01,),
                                    Text("DEPART ON",
                                      style: TextStyle(color: AppColors.white,fontSize:12 ),)
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    showMyDatePicker(selectedDayFrom);
                                    setState(() {
                                      selectedDayFrom;
                                    });
                                  },
                                  child: Text(
                                      "${selectedDayFrom.day}/${selectedDayFrom.month}/${selectedDayFrom.year}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.white,fontSize: 20 )),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.date_range_outlined,color: AppColors.white,size: 16,),
                                    SizedBox(width: sizeWidth * 0.01,),
                                    Text("DEPART ON",
                                      style: TextStyle(color: AppColors.white,fontSize:12 ),)
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    showMyDatePicker(selectedDayTo);
                                    setState(() {
                                      selectedDayTo;
                                    });
                                  },
                                  child: Text(
                                      "${selectedDayTo.day}/${selectedDayTo.month}/${selectedDayTo.year}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.white,fontSize: 20 )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        //padding:  EdgeInsets.symmetric(horizontal: 10,vertical:20),
                        //margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 5),
                        decoration:BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(15)
                        ) ,
                        child: Center(
                          child: Text(
                            "Search Bus",
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 20
                            ),
                          ),
                        ),
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
  void showMyDatePicker(DateTime selectedDay) async {
    DateTime? newSelectedDay = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newSelectedDay != null) {
      setState(() {
        if (selectedDay == selectedDayFrom) {
          selectedDayFrom = newSelectedDay;
        } else if (selectedDay == selectedDayTo) {
          selectedDayTo = newSelectedDay;
        }
      });
    }
  }
}
