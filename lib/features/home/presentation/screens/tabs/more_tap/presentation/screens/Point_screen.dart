import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/Acess_point_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/main.dart';

class PointScreens extends StatefulWidget {
  String lineid;
  PointScreens({super.key, required this.lineid});

  @override
  State<PointScreens> createState() => _PointScreensState();
}

class _PointScreensState extends State<PointScreens> {
  MoreRepo moreRepo = MoreRepo(sl());

  Accesspontmodel linesModel = Accesspontmodel();

  @override
  void initState() {
    get();
    super.initState();
  }

  void get() async {
    linesModel = (await moreRepo.getPoints(lineid: widget.lineid))!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Directionality(
      textDirection:
          LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder(
          bloc: BlocProvider.of<MoreCubit>(context),
          builder: (context, state) {
            if (state is LoadingStations) {
              return Center(
                child: CircularProgressIndicator(
                  color: Routes.isomra
                      ? AppColors.umragold
                      : AppColors.primaryColor,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: sizeHeight * 0.08,
                  ),
                  Container(
                    alignment: LanguageClass.isEnglish
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Routes.isomra
                            ? AppColors.umragold
                            : AppColors.primaryColor,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      LanguageClass.isEnglish ? "Stations" : "المحطات",
                      style: fontStyle(
                          color: AppColors.blackColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: FontFamily.bold),
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight * 0.01,
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ExpansionTile(
                            collapsedIconColor: Routes.isomra
                                ? AppColors.umragold
                                : AppColors.primaryColor,
                            iconColor: Routes.isomra
                                ? AppColors.umragold
                                : AppColors.primaryColor,
                            title: Text(
                              linesModel.message!.cityList![index].cityName!,
                              style: fontStyle(
                                  color: AppColors.blackColor,
                                  fontFamily: FontFamily.medium,
                                  fontSize: 14.sp),
                            ),
                            children: linesModel
                                .message!.cityList![index].stationList!
                                .map((e) => ListTile(
                                      title: Text(
                                        e.stationName!,
                                        style: fontStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 13.sp,
                                            fontFamily: FontFamily.regular),
                                      ),
                                    ))
                                .toList(),
                          );

                          // Container(
                          //   margin: EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          //   child: Text(
                          //     linesModel.message!.cityList![index]!
                          //         .stationList![index2].stationName!,
                          //     style: fontStyle(
                          //         color: AppColors.blackColor,
                          //         fontFamily: FontFamily.regular,
                          //         fontSize: 13.sp),
                          //   ),
                          // );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.greyLight,
                            thickness: 1,
                          );
                        },
                        itemCount: linesModel.message?.cityList?.length ?? 0),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
