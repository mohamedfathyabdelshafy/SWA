import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/lines_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/Select_package.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/main.dart';
import '../../../../../../../../config/routes/app_routes.dart';
import '../../../../../../../../core/utils/constants.dart';

class packagesScreen extends StatefulWidget {
  packagesScreen({super.key});

  @override
  State<packagesScreen> createState() => _packagesScreenState();
}

class _packagesScreenState extends State<packagesScreen> {
  MoreRepo moreRepo = MoreRepo(sl());
  LinesModel linesModel = LinesModel();

  PackagesBloc _packagesBloc = new PackagesBloc();
  @override
  void initState() {
    super.initState();

    _packagesBloc.add(GetactivepackageEvent());
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
          bloc: _packagesBloc,
          builder: (context, PackagesState state) {
            if (state.isloading == true) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          color: AppColors.primaryColor,
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
                        LanguageClass.isEnglish ? "Packages" : "الباقات",
                        style: fontStyle(
                            color: AppColors.blackColor,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: FontFamily.bold),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight * 0.05,
                    ),
                    state.activePackagemodel!.status == 'success'
                        ? Container(
                            padding: EdgeInsets.all(15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.activePackagemodel!.message!
                                            .packageName ??
                                        ' ',
                                    style: fontStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontFamily: FontFamily.medium),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        LanguageClass.isEnglish
                                            ? 'Available Trips : '
                                            : ' الرحلات المتاحة: ',
                                        style: fontStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontFamily: FontFamily.medium),
                                      ),
                                      Text(
                                        state.activePackagemodel!.message!
                                            .remaingTrip
                                            .toString(),
                                        style: fontStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontFamily: FontFamily.medium),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ]),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            selectpackageScreen()));
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.primaryColor),
                                child: Text(
                                    LanguageClass.isEnglish
                                        ? "Add Package"
                                        : 'أضف باقة',
                                    style: fontStyle(
                                        color: AppColors.white,
                                        fontSize: 16.sp,
                                        fontFamily: FontFamily.bold)),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
