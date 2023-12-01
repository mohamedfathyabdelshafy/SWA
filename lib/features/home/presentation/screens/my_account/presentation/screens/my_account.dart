import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/PLOH/change_password_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/change_password/presentation/screen/change_password.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/PLOH/personal_info_cubit.dart';
import 'package:swa/features/home/presentation/screens/my_account/presentation/screens/personal_info/presentation/screen/personal_info.dart';
import 'package:swa/features/sign_in/data/data_sources/login_local_data_source.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/dete_respo.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';

class MyAccountScreen extends StatelessWidget {
  MyAccountScreen({
    super.key,
    required this.user,
    required this.loginLocalDataSource,
  });
  User user;

  Userdeleterespo userdelete = new Userdeleterespo();

  final LoginLocalDataSource loginLocalDataSource;

  @override
  Widget build(BuildContext context) {
    print("_user${user?.customerId ?? 0}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Account",
              style: TextStyle(
                  color: AppColors.white, fontSize: 34, fontFamily: "bold"),
            ),
            const SizedBox(
              height: 37,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BlocProvider<PersonalInfoCubit>(
                            create: (context) => PersonalInfoCubit(),
                            child: PersonalInfoScreen(
                              user: user,
                            ));
                      }));
                    },
                    child: customText("Personal Info")),
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BlocProvider<ChangePasswordCubit>(
                          create: (context) => ChangePasswordCubit(),
                          child: ChangePassword(
                            user: user,
                          ),
                        );
                      }));
                    },
                    child: customText("Change Password")),
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                    onTap: () {
                      loginLocalDataSource.clearUserData();

                      Navigator.pushNamed(
                        context,
                        Routes.signInRoute,
                      );
                    },
                    child: customText("Logout")),
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                    onTap: () {
                      userdelete.deleteuserfun(user.customerId!);

                      Navigator.pushNamed(
                        context,
                        Routes.signInRoute,
                      );
                    },
                    child: customText("Delete account")),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget customText(text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontSize: 21, fontFamily: "bold"),
    );
  }
}
