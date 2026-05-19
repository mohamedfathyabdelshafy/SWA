import 'dart:developer';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/Timer_widget.dart';
import 'package:swa/features/Swa_umra/models/umra_detail.dart';
import 'package:swa/features/bus_reservation_layout/presentation/PLOH/bus_layout_reservation_states.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/payment/wallet/data/model/my_wallet_response_model.dart';
import 'package:swa/features/payment/wallet/data/repo/my_wallet_repo.dart';
import 'package:swa/features/reusable_payment/presentation/screens/reusable_payment_screen.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/trip_reservartion_model.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/screens/credit_card_pay_viewd.dart';
import 'package:swa/select_payment2/presentation/screens/electronic_screens.dart';
import 'package:swa/select_payment2/presentation/screens/fawry.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/local_cache_helper.dart';
import '../../../../../core/utils/constants.dart';
import '../../../config/routes/app_routes.dart';

class SelectPaymentScreen2 extends StatefulWidget {
  const SelectPaymentScreen2(
      {super.key,
      this.user,
      required this.promcodeid,
      required this.discount,
      this.totalAmount});
  final User? user;
  final String promcodeid;
  final String discount;
  final String? totalAmount;
  @override
  State<SelectPaymentScreen2> createState() => _SelectPaymentScreen2State();
}

class _SelectPaymentScreen2State extends State<SelectPaymentScreen2> {
  var countryid;
  double balance = 0;

  getwalllet() async {
    MyWalletResponseModel? wallet =
        await MyWalletRepo(sl()).getMyWallet(customerId: Routes.customerid!);
    setState(() {
      balance = wallet!.message!;
    });
  }

  @override
  void initState() {
    super.initState();
    countryid = CacheHelper.getDataToSharedPref(
      key: 'countryid',
    );
    getwalllet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReservationCubit(),
      child: BlocListener<ReservationCubit, ReservationStates>(
        listener: _handleListenner,
        child: ReusablePaymentMethodSelectionScreen(
          countryid: countryid,
          onBackPressed: (context) => Navigator.pop(context),
          onElectronicWalletPressed: _onElectronicWalletPressed,
          onVisaPaymentPressed: _onVisaPaymentPressed,
          onFawryPressed: _onFawryPaymentPressed,
          onWalletPaymentPressed: _onWalletPaymentPressed,
          hasWalletPayment: true,
          shouldHideOtherPaymentMethodsIfWalletSelected: true,
          hasTimer: true,
          walletBalance: balance,
          totalAmount: widget.totalAmount,
        ),
      ),
    );
  }

  void _handleListenner(BuildContext context, state) {
    if (state is LoadingMyWalletState) {
      Constants.showLoadingDialog(context);
    }
    if (state is LoadedMyWalletState) {
      Constants.hideLoadingDialog(context);
      Constants.showDefaultSnackBar(
          context: context,
          color: state.reservationResponseMyWalletModel.status == 'success'
              ? Colors.green
              : Colors.red,
          text: state.reservationResponseMyWalletModel.message!);
      if (state.reservationResponseMyWalletModel.status == 'success') {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false,
            arguments: Routes.isomra);
      }
    }
    if (state is ErrorMyWalletState) {
      Constants.hideLoadingDialog(context);
      Constants.showDefaultSnackBar(context: context, text: state.error);
    }
    if (state is ImageMyWalletState) {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStater) {
            return Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Image.network(
                            state.message,
                            height: MediaQuery.of(context).size.height / 1.4,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ).then((value) {
        // This block will execute when the dialog is dismissed
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false,
            arguments: Routes.isomra);
      });
    } else if (state is ImageWithGiftMyWalletState) {
      late ConfettiController _controllerTopCenter;
      _controllerTopCenter =
          ConfettiController(duration: const Duration(seconds: 3));

      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStater) {
            _controllerTopCenter.play();

            return Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Image.network(
                            state.message,
                            height: MediaQuery.of(context).size.height / 1.4,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConfettiWidget(
                            shouldLoop: false,
                            confettiController: _controllerTopCenter,
                            blastDirection: pi,
                            maxBlastForce: 2, // set a lower max blast force
                            minBlastForce: 1, // set a lower min blast force
                            emissionFrequency: 0.05,
                            blastDirectionality: BlastDirectionality.explosive,
                            numberOfParticles: 20, // a lot of particles at once
                            gravity: 0.2,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.umragold
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ).then((value) {
        // This block will execute when the dialog is dismissed
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false,
            arguments: Routes.isomra);
      });
    } else if (state is ImageElectronicWalletState) {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStater) {
            return Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Image.network(
                            state.message,
                            height: MediaQuery.of(context).size.height / 1.4,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ).then((value) {
        // This block will execute when the dialog is dismissed
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false,
            arguments: Routes.isomra);
      });
    } else if (state is ImageWithGiftElectronicWalletState) {
      late ConfettiController _controllerTopCenter;
      _controllerTopCenter =
          ConfettiController(duration: const Duration(seconds: 3));

      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStater) {
            _controllerTopCenter.play();

            return Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Image.network(
                            state.message,
                            height: MediaQuery.of(context).size.height / 1.4,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConfettiWidget(
                            shouldLoop: false,
                            confettiController: _controllerTopCenter,
                            blastDirection: pi,
                            maxBlastForce: 2, // set a lower max blast force
                            minBlastForce: 1, // set a lower min blast force
                            emissionFrequency: 0.05,
                            blastDirectionality: BlastDirectionality.explosive,
                            numberOfParticles: 20, // a lot of particles at once
                            gravity: 0.2,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.umragold
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ).then((value) {
        // This block will execute when the dialog is dismissed
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false,
            arguments: Routes.isomra);
      });
    } else if (state is ImageCreditCardState) {
      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStater) {
            return Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Image.network(
                            state.message,
                            height: MediaQuery.of(context).size.height / 1.4,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ).then((value) {
        // This block will execute when the dialog is dismissed
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false,
            arguments: Routes.isomra);
      });
    } else if (state is ImageWithGiftCreditCardState) {
      late ConfettiController _controllerTopCenter;
      _controllerTopCenter =
          ConfettiController(duration: const Duration(seconds: 3));

      showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setStater) {
            _controllerTopCenter.play();

            return Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Image.network(
                            state.message,
                            height: MediaQuery.of(context).size.height / 1.4,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConfettiWidget(
                            shouldLoop: false,
                            confettiController: _controllerTopCenter,
                            blastDirection: pi,
                            maxBlastForce: 2, // set a lower max blast force
                            minBlastForce: 1, // set a lower min blast force
                            emissionFrequency: 0.05,
                            blastDirectionality: BlastDirectionality.explosive,
                            numberOfParticles: 20, // a lot of particles at once
                            gravity: 0.2,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.umragold
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ).then((value) {
        // This block will execute when the dialog is dismissed
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false,
            arguments: Routes.isomra);
      });
    }
  }

  void _onFawryPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
          create: (context) => ReservationCubit(),
          child: FawryScreenReservation(user: widget.user!),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrlOrBase64,
      {String? linkApi, VoidCallback? onCloseCallback}) {
    // Removed hasGift as it's not needed for the core style
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // Ensure it's not dismissed by tapping outside
      transitionDuration: const Duration(
          milliseconds: 200), // Optional: Add a transition duration
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(builder: (context, setStater) {
          return Container(
            color: Colors
                .transparent, // Transparent background for the dialog area
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              color: Colors
                  .transparent, // Transparent material to allow InkWell effect
              elevation: 0,
              child: InkWell(
                onTap: () {
                  if (linkApi != null && linkApi.isNotEmpty) {
                    // Assuming _launchInWebView is defined elsewhere or use url_launcher
                    // Example: Launch URL in browser or in-app WebView
                    launchUrl(Uri.parse(linkApi),
                        mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height /
                      1.4, // Max height like your example
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // No explicit background color unless image doesn't cover
                  ),
                  child: Stack(
                    alignment: Alignment
                        .topCenter, // Align close button to top-center of the stack
                    children: [
                      Container(
                        // Removed explicit padding here to allow image to fill more
                        child: Image.network(
                          imageUrlOrBase64, // Use imageUrlOrBase64 here
                          height: MediaQuery.of(context).size.height / 1.4,
                          fit: BoxFit
                              .fill, // Fill the container, might distort if aspect ratio is off
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 80, // Make error icon more prominent
                            ); // Show error icon if image fails to load
                          },
                        ),
                      ),
                      // Close button - Positioned within Stack for precise placement
                      Positioned(
                        top: 10, // Adjust as needed
                        // Assuming you want it consistently on the right side for LTR/RTL
                        right: LanguageClass.isEnglish ? 10 : null,
                        left: LanguageClass.isEnglish ? null : 10,
                        child: InkWell(
                          onTap: () {
                            onCloseCallback
                                ?.call(); // Call the provided callback
                            Navigator.pop(context); // Dismiss the dialog
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors
                                  .black, // Dark background for close button
                              borderRadius:
                                  BorderRadius.circular(100), // Circular shape
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18, // Slightly smaller icon
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _onVisaPaymentPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
            create: (context) => ReservationCubit(),
            child: CreditCardPayView(
                Discount: widget.discount,
                promocodeid: widget.promcodeid,
                index: 1,
                user: widget.user!)),
      ),
    );
  }

  void _onElectronicWalletPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ReservationCubit>(
            create: (context) => ReservationCubit(),
            child: ElectronicScreen2(user: widget.user!)),
      ),
    );
  }

  void _onWalletPaymentPressed(BuildContext context) {
    BlocProvider.of<ReservationCubit>(context).addReservationMyWallet(
        promocodeid: widget.promcodeid,
        custId: widget.user!.customerId!,
        paymentTypeID: 67,
        trips: Routes.resrvedtrips);
  }
}
