import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/local_cache_helper.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/constants.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/core/utils/styles.dart';
import 'package:swa/core/widgets/currency_selector.dart';
import 'package:swa/features/Swa_umra/Screens/Select_type.dart';
import 'package:swa/features/app_info/presentation/cubit/get_available_countries/get_available_countries_cubit.dart';
import 'package:swa/features/home/presentation/cubit/home_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_bloc.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/packages/bloc/packages_respo.dart';
import 'package:swa/features/home/presentation/screens/tabs/my_home.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/presentation/PLOH/ticket_history_cubit.dart';
import 'package:swa/features/payment/fawry/presentation/screens/fawry.dart';
import 'package:swa/features/payment/fawry2/presentation/PLOH/fawry_Reservation_cubit.dart';
import 'package:swa/features/sign_in/domain/entities/user.dart';
import 'package:swa/features/sign_in/presentation/cubit/login_cubit.dart';
import 'package:swa/features/times_trips/presentation/PLOH/times_trips_cubit.dart';
import 'package:swa/main.dart';
import 'package:swa/select_payment2/data/models/Curruncy_model.dart';
import 'package:swa/select_payment2/presentation/PLOH/reservation_my_wallet_cuibit/reservation_states_my_wallet.dart';
import 'package:swa/select_payment2/presentation/credit_card/presentation/navigation_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart'
    as intl; // Import for NumberFormat in NumericTextFormatter

import '../../../PLOH/reservation_my_wallet_cuibit/reservation_my_wallet_cuibit.dart';
import '../../model/card_model.dart';
import 'credit_card.dart';
import 'package:swa/core/error/failures.dart'; // Import ServerFailure

class AddWalletBalanceWithCreditCardScreen extends StatefulWidget {
  int index; // Index of the selected card in the list.
  User user; // User object for customerId.

  AddWalletBalanceWithCreditCardScreen(
      {super.key, required this.index, required this.user});

  @override
  State<AddWalletBalanceWithCreditCardScreen> createState() =>
      _AddWalletBalanceWithCreditCardScreenState();
}

class _AddWalletBalanceWithCreditCardScreenState
    extends State<AddWalletBalanceWithCreditCardScreen> {
  // Removed unused 'price' variable if it's not directly used here.
  // final price = CacheHelper.getDataToSharedPref(key: 'price');

  // String cardNumber = ''; // These are not directly used, as card data is from `cards` list.
  // String expiryDate = '';
  String cvv = ''; // This is used for input.
  List<CardModel> cards = []; // List to store saved cards.
  TextEditingController cardHolderName =
      TextEditingController(); // Not used in this screen for input.
  // TextEditingController expiryFieldCtrl = TextEditingController(); // Not used directly for input in this screen.
  // TextEditingController cardNumberCtrl = TextEditingController(); // Not used directly for input in this screen.
  TextEditingController amountController =
      TextEditingController(); // For amount input.
  final formKey = GlobalKey<FormState>();
  bool showCardBack = false; // Controls visibility of CVV field.
  // int selectedIndex = 0; // Duplicates widget.index, using widget.index directly.
  FocusNode cardHolderNameNode = FocusNode(); // Not used for input focus.
  FocusNode cardNumberNode = FocusNode(); // Not used for input focus.
  FocusNode amountNode = FocusNode(); // Used for amount input focus.
  FocusNode cardDateNode = FocusNode(); // Not used for input focus.
  FocusNode cvvNode = FocusNode(); // Used for CVV input focus.

  Curruncylist? curruncylist;
  String selectedcurruncy = '';
  bool isloading = false; // Internal loading state for currency conversion.
  double payamount = 0.0; // Amount after currency conversion.

  @override
  void initState() {
    // Attempt to load cached cards.
    final dynamic jsonData = CacheHelper.getDataToSharedPref(key: 'cards');
    log("jsonData runtimeType: ${jsonData.runtimeType}");
    log("jsonData content: $jsonData");

    // Initialize widget.index. It should ideally be checked against cards.length after loading.
    // For now, keep it as passed, but it might be set to -1 or 0 based on cards availability.
    // Setting it to 0 as a default if no card is selected initially.
    if (widget.index == -1 && jsonData != null) {
      // If -1 indicates no selection and data exists
      // Check if there are any cards loaded, default to first if so.
      if (jsonData is String) {
        final decoded = json.decode(jsonData);
        if (decoded is List && decoded.isNotEmpty) {
          widget.index = 0;
        }
      } else if (jsonData is List && jsonData.isNotEmpty) {
        widget.index = 0;
      }
    }

    if (jsonData != null) {
      try {
        if (jsonData is String) {
          final decodedData = json.decode(jsonData);
          if (decodedData is List) {
            cards = decodedData
                .map<CardModel>((e) => CardModel.fromJsom(e))
                .toList();
          }
        } else if (jsonData is List) {
          cards =
              jsonData.map<CardModel>((e) => CardModel.fromJsom(e)).toList();
        }
      } catch (e) {
        log("Error decoding cached cards: $e");
        // Consider clearing invalid cache data here.
        // CacheHelper.removeDataFromSharedPref(key: 'cards');
      }
    }
    log("cached cards: ${cards.length} cards loaded.");

    // Ensure selected card index is valid if cards were loaded.
    if (cards.isNotEmpty &&
        (widget.index < 0 || widget.index >= cards.length)) {
      widget.index =
          0; // Default to the first card if the index is out of bounds.
    } else if (cards.isEmpty) {
      widget.index = -1; // Indicate no card is selected if the list is empty.
    }

    getwalllet(); // Fetch currency list.
    selectedcurruncy =
        Routes.curruncy ?? "EGP"; // Default currency if not set in Routes.

    super.initState();
  }

  Future<void> getwalllet() async {
    Constants.showLoadingDialog(context);
    try {
      var response = await PackagesRespo().GetallCurrency();
      if (response is Curruncylist) {
        curruncylist = response;
      } else {
        // Handle unexpected response type
        Constants.showDefaultSnackBar(
            context: context,
            text: LanguageClass.isEnglish
                ? "Failed to load currencies data"
                : "فشل في تحميل بيانات العملات",
            color: Colors.red);
      }
    } catch (e) {
      log("Error fetching currencies: $e");
      Constants.showDefaultSnackBar(
          context: context,
          text: LanguageClass.isEnglish
              ? "Failed to load currencies"
              : "فشل تحميل العملات",
          color: Colors.red);
    } finally {
      Constants.hideLoadingDialog(context);
    }
  }

  Future<void> convertcurruncy(
      {String? from, String? to, double? amount}) async {
    if (amount == null || amount <= 0) {
      payamount = 0.0;
      return;
    }
    setState(() {
      isloading = true;
    });
    try {
      var response = await PackagesRespo()
          .Convertcurrency(amount: amount, from: from, to: to);
      setState(() {
        if (response is double) {
          // Ensure the response is a double
          payamount = response;
        } else {
          log("Currency conversion returned non-double: $response");
          payamount = amount; // Fallback to original amount if conversion fails
          Constants.showDefaultSnackBar(
              context: context,
              text: LanguageClass.isEnglish
                  ? "Currency conversion failed, using original amount"
                  : "فشل تحويل العملة، استخدام المبلغ الأصلي",
              color: Colors.orange);
        }
      });
    } catch (e) {
      log("Currency conversion error: $e");
      setState(() {
        payamount = amount; // Fallback to original amount on error
        Constants.showDefaultSnackBar(
            context: context,
            text: LanguageClass.isEnglish
                ? "Currency conversion failed, using original amount"
                : "فشل تحويل العملة، استخدام المبلغ الأصلي",
            color: Colors.red);
      });
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void dispose() {
    cardHolderName.dispose();
    // expiryFieldCtrl.dispose(); // Added to dispose, as it was missing from the last provide code
    // cardNumberCtrl.dispose(); // Added to dispose, as it was missing from the last provide code
    amountController.dispose();
    cvvNode.dispose();
    amountNode.dispose(); // Ensure to dispose all created FocusNodes.
    cardDateNode.dispose(); // Also dispose this FocusNode
    cardNumberNode.dispose(); // Also dispose this FocusNode
    cardHolderNameNode.dispose(); // Also dispose this FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection:
            LanguageClass.isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Form(
          key: formKey,
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: sizeHeight * 0.08,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  LanguageClass.isEnglish
                                      ? Icons.arrow_back_rounded
                                      : Icons.arrow_forward,
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
                            Text(
                              LanguageClass.isEnglish
                                  ? 'Debit/Credit Card'
                                  : "بطاقة خصم / ائتمان",
                              style: fontStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 30,
                                  fontFamily: FontFamily.bold),
                            ),
                            const SizedBox(height: 40),
                            InkWell(
                              onTap: () async {
                                if (cards.isNotEmpty) {
                                  _showCardSelectionBottomSheet(context); //
                                } else {
                                  // If no cards exist, directly navigate to AddCreditCard
                                  final card = await Navigator.push<CardModel>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AddCreditCard();
                                      },
                                    ),
                                  );
                                  if (card != null) {
                                    cards.add(card);
                                    widget.index = cards.length -
                                        1; // Select the newly added card
                                    CacheHelper.setDataToSharedPref(
                                        key: "cards",
                                        value: json.encode(cards
                                            .map((e) => e.toJson())
                                            .toList()));
                                    setState(() {});
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(color: AppColors.grey),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/master_card.png',
                                      height: 11,
                                      width: 17,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    (cards.isNotEmpty &&
                                            widget.index >= 0 &&
                                            widget.index < cards.length) //
                                        ? Expanded(
                                            child: Text(
                                              "XXXX-XXXX-XXXX-${cards[widget.index].cardNumber!.substring(cards[widget.index].cardNumber!.length - 4)}",
                                              style: fontStyle(
                                                  fontSize: 18,
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  color: Colors.black),
                                            ),
                                          )
                                        : Expanded(
                                            child: Text(
                                              LanguageClass.isEnglish
                                                  ? 'Add credit Card'
                                                  : "اضافة كارت جديد",
                                              style: fontStyle(
                                                  fontSize: 15.45,
                                                  fontFamily: FontFamily.bold,
                                                  color: AppColors.blackColor),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Conditionally render CVV field if a card is selected
                            (widget.index >= 0 && cards.isNotEmpty)
                                ? PayField(
                                    height: 20,
                                    width: 1,
                                    color: const Color(0xff47A9EB),
                                    hint: LanguageClass.isEnglish
                                        ? 'CVV'
                                        : 'رقم السري',
                                    textInputType: TextInputType.number,
                                    onChange: (value) {
                                      setState(() {
                                        showCardBack = true;
                                        cvv = value;
                                      });
                                    },
                                    focusNode: cvvNode,
                                    maxLength: 3,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        showCardBack = false;
                                        amountNode.requestFocus();
                                      });
                                    },
                                  )
                                : const SizedBox
                                    .shrink(), // Use SizedBox.shrink()
                            const SizedBox(
                                height:
                                    10), // Small space between CVV and Amount
                            // Conditionally render amount field if a card is selected
                            (widget.index >= 0 && cards.isNotEmpty)
                                ? Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 1,
                                        decoration: const BoxDecoration(
                                            color: Color(0xffD865A4)),
                                      ),
                                      Expanded(
                                        //
                                        child: Container(
                                            height: sizeHeight * 0.07,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 18),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: TextFormField(
                                                    autofocus: true,
                                                    style: fontStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize: 16),
                                                    cursorColor: AppColors.blue,
                                                    controller:
                                                        amountController,
                                                    inputFormatters: [
                                                      NumericTextFormatter(),
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'[0-9,]')),
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: LanguageClass
                                                              .isEnglish
                                                          ? 'Amount'
                                                          : 'القيمة',
                                                      errorStyle: fontStyle(
                                                        color: Colors.red,
                                                        fontSize: 11,
                                                      ),
                                                      hintStyle: fontStyle(
                                                          color: AppColors
                                                              .greyLight,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              FontFamily.bold),
                                                      labelStyle: fontStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              FontFamily.bold),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return LanguageClass
                                                                .isEnglish
                                                            ? 'This Field is Required'
                                                            : 'هذا الحقل مطلوب';
                                                      }
                                                      // Remove commas for validation
                                                      String cleanedValue =
                                                          value.replaceAll(
                                                              ',', '');
                                                      final double?
                                                          parsedAmount =
                                                          double.tryParse(
                                                              cleanedValue);

                                                      if (parsedAmount ==
                                                              null ||
                                                          parsedAmount <= 0) {
                                                        return LanguageClass
                                                                .isEnglish
                                                            ? 'Enter a valid amount'
                                                            : 'من فضلك ادخل قيمة صحيحة';
                                                      } else if (parsedAmount <
                                                          10) {
                                                        // Check for minimum amount
                                                        return LanguageClass
                                                                .isEnglish
                                                            ? 'The least amount for charge is 10 EGP'
                                                            : 'اقل قيمة للشحن 10 جنيهات';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                ),
                                                4.horizontalSpace,
                                                2.horizontalSpace,
                                                InkWell(
                                                  onTap: () {
                                                    // Ensure curruncylist.message is not null before showing selector
                                                    if (curruncylist?.message !=
                                                        null) {
                                                      showCurrencySelector(
                                                          context,
                                                          currencyList:
                                                              curruncylist!
                                                                  .message!,
                                                          onCurrencySelected:
                                                              (currency) {
                                                        setState(() {
                                                          amountController
                                                                  .text =
                                                              ''; // Clear amount on currency change
                                                          selectedcurruncy =
                                                              currency.symbol!;
                                                        });
                                                        Navigator.pop(context);
                                                      });
                                                    } else {
                                                      Constants.showDefaultSnackBar(
                                                          context: context,
                                                          text: LanguageClass
                                                                  .isEnglish
                                                              ? "Currencies not loaded yet"
                                                              : "لم يتم تحميل العملات بعد",
                                                          color: Colors.orange);
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          selectedcurruncy,
                                                          style: fontStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .bold),
                                                        ),
                                                        4.horizontalSpace,
                                                        Icon(
                                                          Icons
                                                              .arrow_drop_down_rounded,
                                                          color: AppColors
                                                              .umragold,
                                                          size: 20,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  )
                                : const SizedBox
                                    .shrink(), // Use SizedBox.shrink()
                            const SizedBox(
                              height: 50,
                            ),
                            BlocListener<ReservationCubit, ReservationStates>(
                              // Specify Cubit and State types
                              listener: (context, state) {
                                if (state is LoadingCreditCardState ||
                                    isloading) {
                                  // Check both internal loading and cubit loading
                                  Constants.showLoadingDialog(context);
                                } else {
                                  Constants.hideLoadingDialog(
                                      context); // Hide loading for all other states

                                  if (state is LoadedCreditCardState) {
                                    if (state
                                                .reservationResponseCreditCard
                                                .message
                                                ?.nextAction
                                                ?.redirectUrl !=
                                            null &&
                                        state
                                            .reservationResponseCreditCard
                                            .message!
                                            .nextAction!
                                            .redirectUrl!
                                            .isNotEmpty) {
                                      //
                                      NavHelper().navigate(ConfirmPayWebView(
                                        webViewLink: state
                                            .reservationResponseCreditCard
                                            .message!
                                            .nextAction!
                                            .redirectUrl!,
                                      ));
                                    } else {
                                      // Handle cases where redirectUrl is null or empty but status is 'success'
                                      showDoneConfirmationDialog(context,
                                          message: LanguageClass.isEnglish
                                              ? 'Payment successful!'
                                              : 'تم الدفع بنجاح!',
                                          callback: () {
                                        Navigator.pop(context); // Close dialog
                                        // Optionally navigate to home or success screen
                                      });
                                    }
                                  } else if (state is ErrorCreditCardState) {
                                    // Handle error string from state.error
                                    String errorMessage;
                                    if (state.error is ServerFailure) {
                                      errorMessage =
                                          (state.error as ServerFailure)
                                              .message!;
                                    } else if (state.error is String) {
                                      errorMessage = state.error as String;
                                    } else {
                                      errorMessage = LanguageClass.isEnglish
                                          ? "An unknown error occurred."
                                          : "حدث خطأ غير معروف.";
                                    }
                                    Constants.showDefaultSnackBar(
                                        context: context,
                                        text: errorMessage,
                                        color: Colors.red);
                                  } else if (state
                                      is ConfirmationCreditCardState) {
                                    // Handle confirmation
                                    showDoneConfirmationDialog(
                                      context,
                                      isError:
                                          false, // Not an error type of alert
                                      message: state.message,
                                      callback: () {
                                        Navigator.pop(context); // Close dialog
                                      },
                                    );
                                  } else if (state is WarningCreditCardState) {
                                    // Handle warning
                                    showDoneConfirmationDialog(
                                      context,
                                      isError:
                                          true, // Treat warnings as errors for visual alert
                                      message: state.message,
                                      callback: () {
                                        Navigator.pop(context); // Close dialog
                                      },
                                    );
                                  } else if (state is ImageCreditCardState) {
                                    // Handle image
                                    showGeneralDialog(
                                      context: context,
                                      pageBuilder: (BuildContext buildContext,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return StatefulBuilder(
                                            builder: (context, setStater) {
                                          return Container(
                                            color: Colors.transparent,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              child: InkWell(
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.4,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10,
                                                                horizontal: 5),
                                                        child: Image.network(
                                                          state.message,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              1.4,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            width: 25,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
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
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          Routes.home, (route) => false,
                                          arguments: Routes.isomra);
                                    });
                                  } else if (state
                                      is ImageWithGiftCreditCardState) {
                                    // Handle image with gift
                                    late ConfettiController
                                        _controllerTopCenter;
                                    _controllerTopCenter = ConfettiController(
                                        duration: const Duration(seconds: 3));

                                    showGeneralDialog(
                                        context: context,
                                        pageBuilder: (BuildContext buildContext,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return StatefulBuilder(
                                              builder: (context, setStater) {
                                            _controllerTopCenter.play();

                                            return Container(
                                              color: Colors.transparent,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 0,
                                                child: InkWell(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            1.4,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      5),
                                                          child: Image.network(
                                                            state.message,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                1.4,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: ConfettiWidget(
                                                            shouldLoop: false,

                                                            confettiController:
                                                                _controllerTopCenter,
                                                            blastDirection:
                                                                math.pi,
                                                            maxBlastForce:
                                                                2, // set a lower max blast force
                                                            minBlastForce:
                                                                1, // set a lower min blast force
                                                            emissionFrequency:
                                                                0.05,
                                                            blastDirectionality:
                                                                BlastDirectionality
                                                                    .explosive,

                                                            numberOfParticles:
                                                                20, // a lot of particles at once
                                                            gravity: 0.2,
                                                            colors: [
                                                              AppColors
                                                                  .primaryColor,
                                                              AppColors.umragold
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              width: 25,
                                                              height: 25,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
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
                                        });
                                  }
                                }
                              },
                              child: InkWell(
                                onTap: cards.isNotEmpty &&
                                        widget.index >= 0 &&
                                        widget.index <
                                            cards
                                                .length // Only enable tap if there are cards and index is valid
                                    ? () async {
                                        // Make it async since convertcurruncy is async
                                        if (formKey.currentState!.validate()) {
                                          double? amount = double.tryParse(
                                              amountController.text
                                                  .replaceAll(',', ''));

                                          if (amount != null && amount > 0) {
                                            await convertcurruncy(
                                              // Await the conversion
                                              amount: amount,
                                              from: selectedcurruncy,
                                              to: 'EGP',
                                            );
                                            // Only proceed if conversion was successful and payamount is valid
                                            if (payamount > 0) {
                                              log("expiry ${cards[widget.index].month}");
                                              BlocProvider.of<ReservationCubit>(
                                                      context)
                                                  .chargebycard(
                                                custId: widget.user.customerId!,
                                                curruncy:
                                                    selectedcurruncy, // Pass the selected currency symbol
                                                amount: payamount
                                                    .toStringAsFixed(2),
                                                cvv: cvv,
                                                cardNumber: cards[widget.index]
                                                    .cardNumber!
                                                    .replaceAll(" ", ""),
                                                cardExpiryYear: cards[
                                                        widget.index]
                                                    .month! // Assumes 'month' format is "MM/YY"
                                                    .substring(
                                                        3) // Extracts "YY"
                                                    .toString(),
                                                cardExpiryMonth:
                                                    cards[widget.index]
                                                        .month!
                                                        .substring(0,
                                                            2) // Extracts "MM"
                                                        .toString(),
                                              );
                                            } else {
                                              Constants.showDefaultSnackBar(
                                                  context: context,
                                                  text: LanguageClass.isEnglish
                                                      ? "Invalid amount after currency conversion."
                                                      : "المبلغ غير صالح بعد تحويل العملة.",
                                                  color: Colors.red);
                                            }
                                          } else {
                                            Constants.showDefaultSnackBar(
                                                color: Colors.red,
                                                context: context,
                                                text: LanguageClass.isEnglish
                                                    ? 'Enter a valid amount'
                                                    : 'ادخل مبلغ صحيح');
                                          }
                                        }
                                      }
                                    : null, // Disable InkWell if no cards or invalid index
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: Container(
                                    width: 200,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: Container(
                                      height: 65,
                                      decoration: BoxDecoration(
                                          color: cards.isEmpty ||
                                                  (widget.index < 0 ||
                                                      widget.index >=
                                                          cards
                                                              .length) // Grey out if no cards or invalid index
                                              ? Colors.grey
                                              : Routes.isomra
                                                  ? AppColors.umragold
                                                  : AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            LanguageClass.isEnglish
                                                ? 'Charge'
                                                : 'شحن',
                                            style: fontStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: FontFamily.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to show the card selection bottom sheet
  void _showCardSelectionBottomSheet(BuildContext context) {
    final sizeWidth = MediaQuery.sizeOf(context).width;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to update bottom sheet content
          builder:
              (BuildContext context, StateSetter setStateInsideBottomSheet) {
            return Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                height: 270,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageClass.isEnglish ? 'Choose Card' : 'اختر كارت ',
                      style: fontStyle(
                          fontSize: 15,
                          fontFamily: FontFamily.bold,
                          color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 5),
                    Divider(thickness: 0.5, color: AppColors.grey),
                    Expanded(
                      // Use Expanded for ListView.builder
                      child: ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              setStateInsideBottomSheet(() {
                                widget.index = index;
                              });
                              Navigator.pop(context); // Close bottom sheet
                              setState(() {}); // Update parent widget
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: widget.index == index,
                                  activeColor: Colors.yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  onChanged: (value) {
                                    setStateInsideBottomSheet(() {
                                      widget.index = index;
                                    });
                                    Navigator.pop(
                                        context); // Close bottom sheet
                                    setState(() {}); // Update parent widget
                                  },
                                ),
                                Image.asset(
                                  'assets/images/master_card.png',
                                  height: 11,
                                  width: 17,
                                  fit: BoxFit.fitWidth,
                                ),
                                Text(
                                  "XXXX-XXXX-XXXX-${cards[index].cardNumber!.substring(cards[index].cardNumber!.length - 4)}",
                                  style: fontStyle(
                                    fontSize: 20,
                                    fontFamily: FontFamily.regular,
                                    color: Colors.black,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    setStateInsideBottomSheet(() {
                                      if (index >= 0 && index < cards.length) {
                                        //
                                        cards.removeAt(index);
                                      }
                                      // Adjust selected index if the removed card was selected or before the selected one
                                      if (widget.index == index) {
                                        widget.index =
                                            0; // Default to first card
                                        if (cards.isEmpty)
                                          widget.index =
                                              -1; // If list becomes empty
                                      } else if (widget.index > index) {
                                        widget
                                            .index--; // Shift index if a card before it was removed
                                      }
                                      CacheHelper.setDataToSharedPref(
                                        key: "cards",
                                        value: json.encode(cards
                                            .map((e) => e.toJson())
                                            .toList()),
                                      );
                                      // No pop here, allow user to continue interacting with the list in the bottom sheet.
                                      // If the last card is removed and you want to close the bottom sheet, add Navigator.pop(context) here.
                                      if (cards.isEmpty) {
                                        //
                                        Navigator.pop(
                                            context); // Close if no cards left
                                        setState(() {}); // Update parent
                                      } else {
                                        setState(
                                            () {}); // Update parent after removal
                                      }
                                    });
                                  },
                                  child: Icon(Icons.delete),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(thickness: 0.5, color: AppColors.grey),
                    Row(
                      children: [
                        SizedBox(width: sizeWidth * 0.03),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: AppColors.grey),
                            child: const Icon(
                              Icons.add,
                              color: Colors.lightGreen,
                              size: 20,
                            )),
                        SizedBox(width: sizeWidth * 0.03),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context); // Close bottom sheet
                            final card = await Navigator.push<CardModel>(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AddCreditCard();
                                },
                              ),
                            );
                            if (card != null) {
                              //
                              cards.add(card);
                              widget.index =
                                  cards.length - 1; // Select the new card
                              CacheHelper.setDataToSharedPref(
                                  key: "cards",
                                  value: json.encode(
                                      cards.map((e) => e.toJson()).toList()));
                              setState(
                                  () {}); // Update parent widget after adding card
                            }
                          },
                          child: Text(
                            LanguageClass.isEnglish
                                ? 'Add New Card'
                                : 'اضافة كارت جديد',
                            style: fontStyle(
                                fontSize: 15.45,
                                fontFamily: FontFamily.bold,
                                color: AppColors.blackColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> showDoneConfirmationDialog(BuildContext context,
      {required String message,
      String? callbackTitle,
      bool isError = false,
      bool isWarning = false,
      required VoidCallback? callback}) async {
    return CoolAlert.show(
        barrierDismissible: false,
        context: context,
        confirmBtnText: "ok",
        title: isError
            ? LanguageClass.isEnglish
                ? 'Error'
                : 'خطأ'
            : isWarning
                ? LanguageClass.isEnglish
                    ? 'Please'
                    : 'يرجى'
                : LanguageClass.isEnglish
                    ? 'Success'
                    : 'تم بنجاح',
        lottieAsset: isError
            ? 'assets/json/error.json'
            : isWarning
                ? 'assets/json/Warning.json'
                : 'assets/json/done.json',
        type: isError ? CoolAlertType.error : CoolAlertType.success,
        loopAnimation: false,
        backgroundColor: isError ? Colors.red : Colors.white,
        text: message,
        onConfirmBtnTap: callback);
  }

  // Helper method to show image dialog (copied from previous response)
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
}

class PayField extends StatelessWidget {
  PayField(
      {required this.hint,
      required this.onChange,
      this.ctr,
      this.maxLength,
      this.focusNode,
      this.textInputType,
      this.onFieldSubmitted,
      this.height,
      required this.color,
      this.width});
  final TextEditingController? ctr;
  final String hint;
  final Function onChange;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final Function? onFieldSubmitted;
  final double? height;
  final double? width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(color: color),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          // Use Expanded to allow TextFormField to take available space
          child: SizedBox(
            height: 60, // Fixed height for consistency
            child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                controller: ctr,
                keyboardType: textInputType,
                style: fontStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: hint,
                  contentPadding: EdgeInsets.only(top: 10),
                  border: InputBorder.none,
                  hintStyle: fontStyle(
                      fontSize: 15,
                      fontFamily: FontFamily.bold,
                      color: AppColors.greyLight),
                  labelStyle: fontStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontFamily: FontFamily.bold),
                  errorStyle: fontStyle(
                    color: Colors.red,
                    fontSize: 11,
                  ),
                ),
                maxLength: maxLength ?? 16,
                onChanged: (value) => onChange(value),
                focusNode: focusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return LanguageClass.isEnglish
                        ? 'This Field is Required'
                        : 'هذا الحقل مطلوب';
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (value) {
                  if (onFieldSubmitted != null) {
                    onFieldSubmitted!(value);
                  }
                }),
          ),
        ),
        const Icon(
          Icons.info_rounded,
          color: Color(0xff616B80),
          size: 20, // Increased size for visibility
        )
      ],
    );
  }
}

// Re-defining NumericTextFormatter to ensure it's available
class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      var value = newValue.text;
      value = value.replaceAll(RegExp(r'\D'), ''); // Remove non-digits

      if (value.length > 3) {
        final formatter = intl.NumberFormat('#,##0');
        try {
          value = formatter.format(int.parse(value));
        } catch (e) {
          return oldValue;
        }
      }
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(
            offset: value.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}

class ConfirmPayWebView extends StatefulWidget {
  final String webViewLink;
  ConfirmPayWebView({
    Key? key,
    required this.webViewLink,
  }) : super(key: key);

  @override
  State<ConfirmPayWebView> createState() => _ConfirmPayWebViewState();
}

class _ConfirmPayWebViewState extends State<ConfirmPayWebView> {
  WebViewController controller = WebViewController();
  bool isLoadingPage = true; // To show a loading indicator for the WebView

  @override
  void initState() {
    super.initState();
    controller = WebViewController() // Initialize controller inside initState
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar or state
            log('WebView loading progress: $progress%');
            if (mounted) {
              setState(() {
                isLoadingPage = progress < 100;
              });
            }
          },
          onPageStarted: (String url) {
            log('Page started loading: $url');
            if (mounted) {
              //
              setState(() {
                isLoadingPage = true;
              });
            }
          },
          onPageFinished: (String url) {
            log('Page finished loading: $url');
            if (mounted) {
              //
              setState(() {
                isLoadingPage = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            log('Web resource error: ${error.description}');
            if (mounted) {
              //
              setState(() {
                isLoadingPage = false;
              });
            }
            Constants.showDefaultSnackBar(
                //
                context: context,
                text: LanguageClass.isEnglish
                    ? "Failed to load payment page."
                    : "فشل تحميل صفحة الدفع.",
                color: Colors.red);
          },
          onNavigationRequest: (NavigationRequest request) async {
            log('Navigating to: ${request.url}');
            // Check for success or failure URLs
            if (request.url.contains('825151')) {
              // Example for error URL
              await Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  //
                  showDoneConfirmationDialog(context, //
                      isError: true,
                      message: LanguageClass.isEnglish
                          ? 'Payment Error'
                          : 'حدث خطاء اثنا الدفع', callback: () {
                    NavHelper().goBack(); // Pop WebView
                    NavHelper().goBack(); // Pop Credit Card Screen
                  });
                }
              });
              return NavigationDecision
                  .prevent; // Prevent navigation to this URL
            } else if (request.url
                    .startsWith('https://swabus.com/Home/FawryCharge') ||
                request.url.contains('success_callback_url')) {
              // Example for success URL or your actual success endpoint
              await Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  //
                  showDoneConfirmationDialog(context, //
                      message: LanguageClass.isEnglish
                          ? 'Payment completed successfully'
                          : 'تم عملية الدفع بنجاح', callback: () {
                    // Navigate to home or appropriate screen after successful payment
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.home, (route) => false,
                        arguments: Routes.isomra);
                  });
                }
              });
              return NavigationDecision
                  .prevent; // Prevent navigation to this URL
            }
            return NavigationDecision.navigate; // Allow other navigations
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.webViewLink));
  }

  @override
  Widget build(BuildContext context) {
    log("ConfirmPayWebView build");
    return PopScope(
      // Use PopScope for back button handling
      canPop: false, // Prevent popping directly without confirmation
      onPopInvoked: (didPop) {
        if (didPop) return;
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(LanguageClass.isEnglish
                  ? "Exit Payment?"
                  : "الخروج من الدفع؟"),
              content: Text(LanguageClass.isEnglish
                  ? "Are you sure you want to cancel the payment?"
                  : "هل أنت متأكد أنك تريد إلغاء عملية الدفع؟"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close current dialog
                  },
                  child: Text(LanguageClass.isEnglish ? "No" : "لا"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close current dialog
                    NavHelper().goBack(); // Pop WebView
                    NavHelper().goBack(); // Pop Credit Card screen
                  },
                  child: Text(LanguageClass.isEnglish ? "Yes" : "نعم"),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              // Trigger the onPopInvoked logic for confirmation
              Navigator.pop(context); // This will trigger PopScope
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            LanguageClass.isEnglish ? "Complete Payment" : "إتمام الدفع",
            style: fontStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home, (route) => false,
                    arguments: Routes.isomra);
              },
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 35,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: controller),
              if (isLoadingPage) // Show loading indicator
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to show CoolAlert dialog (re-defined here for accessibility)
  Future<dynamic> showDoneConfirmationDialog(BuildContext context,
      {required String message,
      String? callbackTitle,
      bool isError = false,
      bool isWarning = false,
      required VoidCallback? callback}) async {
    return CoolAlert.show(
        barrierDismissible: false,
        context: context,
        confirmBtnText: "ok",
        title: isError
            ? LanguageClass.isEnglish
                ? 'Error'
                : 'خطأ'
            : isWarning
                ? LanguageClass.isEnglish
                    ? 'Please'
                    : 'يرجى'
                : LanguageClass.isEnglish
                    ? 'Success'
                    : 'تم بنجاح',
        lottieAsset: isError
            ? 'assets/json/error.json'
            : isWarning
                ? 'assets/json/Warning.json'
                : 'assets/json/done.json',
        type: isError ? CoolAlertType.error : CoolAlertType.success,
        loopAnimation: false,
        backgroundColor: isError ? Colors.red : Colors.white,
        text: message,
        onConfirmBtnTap: callback);
  }
}
