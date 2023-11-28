import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/widgets/customized_field.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/model/personal_info_response.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/data/repo/personal_info_repo.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/PLOH/personal_info_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/PLOH/personal_info_states.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/main.dart';

class PersonalInfoScreen extends StatefulWidget {
   PersonalInfoScreen({super.key,required this.user});
User user;
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  PersonalInfoRepo personalInfoRepo = PersonalInfoRepo(sl());
  PersonalInfoResponse? personalInfoResponse;
  TextEditingController nameController =TextEditingController();

  TextEditingController emailController =TextEditingController();

  TextEditingController mobilController =TextEditingController();
@override
  void initState() {
get();

    super.initState();
  }
 void get()async{
  personalInfoResponse = await personalInfoRepo.getPersonalInfo(customerId: widget.user.customerId!);
  nameController.text = personalInfoResponse!.personalInfo!.name!;
  emailController.text = personalInfoResponse!.personalInfo!.email!;
  mobilController.text = personalInfoResponse!.personalInfo!.mobile!;
  setState(() {});
  print("personalInfoResponse${personalInfoResponse!.personalInfo!.name!}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
            size: 34,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Personal Information" ,
              style: TextStyle(color: AppColors.white,fontSize: 34,fontFamily: "bold"),
            ),
            SizedBox(height: 15,),
            CustomizedField(
              isPassword: false,
              obscureText: false,
              colorText: AppColors.greyLight,
              controller:nameController ,
              validator: (validator){},
              color:Colors.white.withOpacity(0.2),
              labelText: "Name",
            ),
           const SizedBox(height: 15,),
            CustomizedField(
              isPassword: false,
              obscureText: false,
              colorText: AppColors.greyLight,
              controller:emailController ,
              validator: (validator){},
              color:Colors.white.withOpacity(0.2),
              labelText: "Mobile",
            ),
            const SizedBox(height: 15,),
            CustomizedField(
              isPassword: false,
              obscureText: false,
              colorText: AppColors.greyLight,
              controller:mobilController ,
              validator: (validator){},
              color:Colors.white.withOpacity(0.2),
              labelText: "Email",
            ),
            Spacer(),
            BlocListener<PersonalInfoCubit,PersonalInfoStates>(
              listener: (contex,state){
                if(state is PersonalInfoLoading){
                  Constants.showLoadingDialog(context);
                }if(state is PersonalInfoLoaded){
                  Constants.hideLoadingDialog(context);
                  Constants.showDefaultSnackBar(context: context, text: state.personalInfoResponse.message!);
                }if(state is PersonalInfoError ){
                  Constants.hideLoadingDialog(context);
                  Constants.showDefaultSnackBar(context: context, text: state.msg);

                }
              },
              child: InkWell(
                onTap: (){
                BlocProvider.of<PersonalInfoCubit>(context).getPersonalInfoEdit(
                    customerId: widget.user.customerId!,
                    name: nameController.text,
                    mobile: mobilController.text,
                    email: emailController.text,
                  userLoginId: widget.user.userId!
                );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Constants.customButton(text: "Save",color: AppColors.primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
