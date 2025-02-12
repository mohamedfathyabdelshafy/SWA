import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_classes_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/bus_Images_screen.dart';
import 'package:swa/main.dart';

class BusClasses extends StatefulWidget {
  BusClasses({super.key});

  @override
  State<BusClasses> createState() => _BusClassesState();
}

class _BusClassesState extends State<BusClasses> {
  MoreRepo moreRepo = MoreRepo(sl());
  BusClassesModel busClasses = BusClassesModel();
  @override
  void initState() {
    get();
    super.initState();
  }

  void get() async {
    await BlocProvider.of<MoreCubit>(context).getBusClass();
    busClasses = (await moreRepo.getBusClasses())!;
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
            if (state is LoadingBussClass) {
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
                      LanguageClass.isEnglish
                          ? "Bus Classes"
                          : "انواع الاتوبيس",
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
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BlocProvider(
                                    create: (context) => MoreCubit(),
                                    child: BusImageClasses(
                                      typeClasses: busClasses
                                          .message![index].title
                                          .toString(),
                                      id: busClasses.message![index].id
                                          .toString(),
                                    ));
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    busClasses.message![index].title ?? "",
                                    style: fontStyle(
                                        color: AppColors.blackColor,
                                        fontFamily: FontFamily.medium,
                                        fontSize: 18.sp),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Color(0xffA3A3A3),
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.greyLight,
                            thickness: 1,
                          );
                        },
                        itemCount: busClasses.message?.length ?? 0),
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
