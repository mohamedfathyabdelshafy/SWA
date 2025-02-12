import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/terms_and_condition_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/main.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  MoreRepo moreRepo = MoreRepo(sl());
  TermsAndConditionModel termsAndConditionModel = TermsAndConditionModel();
  @override
  void initState() {
    get();
    super.initState();
  }

  void get() async {
    await BlocProvider.of<MoreCubit>(context).getTermsAndCondition();

    termsAndConditionModel = (await moreRepo.getTermsCondition())!;
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
            if (state is LoadingTermsAndCondition) {
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
                          ? "Terms And Conditions"
                          : "الأحكام والشروط",
                      style: fontStyle(
                          color: AppColors.blackColor,
                          fontSize: 38,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.medium),
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight * 0.01,
                  ),
                  Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  termsAndConditionModel.message![index].title!,
                                  style: fontStyle(
                                      color: AppColors.blackColor,
                                      fontFamily: FontFamily.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  termsAndConditionModel
                                      .message![index].description!,
                                  style: fontStyle(
                                      color: AppColors.blackColor,
                                      fontFamily: FontFamily.regular,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.greyLight,
                            thickness: 1,
                          );
                        },
                        itemCount: termsAndConditionModel.message?.length ?? 0),
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
