import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
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
  TermsAndConditionModel  termsAndConditionModel  =TermsAndConditionModel();
  @override
  void initState() {
    get();
    super.initState();
  }
  void get()async{
    await BlocProvider.of<MoreCubit>(context).getTermsAndCondition();

    termsAndConditionModel = (await moreRepo.getTermsCondition())!;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Directionality(
      textDirection: LanguageClass.isEnglish?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text(
            LanguageClass.isEnglish? "Terms And Conditions":"الأحكام والشروط",
            style: TextStyle(
                color: AppColors.white,
                fontSize: 25,
                fontFamily: "bold"),
          ),
        ),
        backgroundColor: Colors.black,
        body: BlocBuilder(
          bloc: BlocProvider.of<MoreCubit>(context),
          builder: (context,state)  {
            if(state is LoadingTermsAndCondition){
              return  Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor,),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: sizeHeight * 0.05,
                  ),
                  SizedBox(
                    height: sizeHeight * 0.8,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  termsAndConditionModel.message![index].title!,
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontFamily: "bold",
                                      fontSize: 20
                                  ),
                                ),
                                Text(
                                  termsAndConditionModel.message![index].description!,
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontFamily: "regular",
                                      fontSize: 15
                                  ),
                                ),

                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.white,
                            thickness: 1,
                          );
                        },
                        itemCount: termsAndConditionModel.message?.length??0),
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
