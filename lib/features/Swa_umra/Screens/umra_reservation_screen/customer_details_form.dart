import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/language.dart';
import '../../../../core/utils/letters_only_formatter.dart';
import '../../../../core/utils/numbers_only_formatter.dart';
import '../../../../core/utils/styles.dart';
import '../../bloc/umra_bloc.dart';
import '../../models/umra_detail.dart';
import '4_reservation_screen.dart';

//umrahReservationID: widget
//                       .umrahReservationID,
//                   selectedpackage:
//                       selectedpackage,
//                   typeid: widget.typeid,

class PassengerFormScreen extends StatefulWidget {
  int typeid, selectedpackage;
  int? umrahReservationID;
  final int reservedSeats;

  PassengerFormScreen(
      {super.key,
      required this.reservedSeats,
      required this.selectedpackage,
      required this.typeid,
      this.umrahReservationID});

  @override
  State<PassengerFormScreen> createState() => _PassengerFormScreenState();
}

class _PassengerFormScreenState extends State<PassengerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> nameControllers = [];
  final List<TextEditingController> idControllers = [];

  final List<String?> phone1List = [];
  final List<String?> phone2List = [];
  final List<String?> countryCode1List = [];
  final List<String?> countryCode2List = [];
  List<bool> isAdultList = [];
  final List<String?> genderList = [];
  final List<TextEditingController> notesControllers = [];
  final List<int?> selectedSeatsList = [];
  Map<int, int?> _passengerSeatAssignment = {}; // passengerIndex -> seatNumber
  Set<int> _assignedSeats = {};
  final List<bool> notesExpandedList = [];
  final List<bool> passengerCardExpandedList =
      []; // New list for card expansion

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < UmraDetails.seatsNumbers.length; i++) {
      nameControllers.add(TextEditingController());
      idControllers.add(TextEditingController());
      phone1List.add("");
      phone2List.add("");
      countryCode1List.add("");
      countryCode2List.add("");
      isAdultList.add(true);
      genderList.add('Male'); // default to male
      notesControllers.add(TextEditingController());
      selectedSeatsList.add(UmraDetails.seatsNumbers[i].toInt());
      notesExpandedList.add(false);
      passengerCardExpandedList.add(
        i == 0,
      ); // Primary passenger starts expanded
    }
  }

  @override
  void dispose() {
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in idControllers) {
      controller.dispose();
    }
    for (var controller in notesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildCollapsibleNotes(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              notesExpandedList[index] = !notesExpandedList[index];
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  notesExpandedList[index] ? Icons.remove : Icons.add,
                  color: AppColors.umragold,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  LanguageClass.isEnglish ? 'Add Notes' : 'إضافة ملاحظات',
                  style: fontStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.umragold,
                  ),
                ),
                Spacer(),
                Icon(
                  notesExpandedList[index]
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.umragold,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: notesExpandedList[index] ? null : 0,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: notesExpandedList[index] ? 1.0 : 0.0,
            child: notesExpandedList[index]
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: notesControllers[index],
                      maxLines: 3,
                      decoration: _inputDecoration(
                        LanguageClass.isEnglish
                            ? 'Notes (Optional)'
                            : 'ملاحظات (اختياري)',
                        Icons.note_alt_outlined,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  bool _isSeatTaken(int seatNumber, int currentPassengerIndex) {
    for (int i = 0; i < selectedSeatsList.length; i++) {
      if (i != currentPassengerIndex && selectedSeatsList[i] == seatNumber) {
        return true;
      }
    }
    return false;
  }

  Widget _buildSeatSelection(int passengerIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event_seat, color: AppColors.umragold, size: 20),
            SizedBox(width: 8),
            Text(
              LanguageClass.isEnglish
                  ? 'Select Seat (Optional)'
                  : 'اختر المقعد (اختياري)',
              style: fontStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedSeatsList.map((seatNumber) {
              bool isAssigned = _assignedSeats.contains(
                seatNumber!.toInt(),
              );
              bool isSelectedForThisPassenger =
                  _passengerSeatAssignment[passengerIndex] ==
                      seatNumber.toInt();

              return InkWell(
                onTap: isAssigned && !isSelectedForThisPassenger
                    ? null
                    : () {
                        setState(() {
                          // Remove previous assignment for this passenger
                          if (_passengerSeatAssignment[passengerIndex] !=
                              null) {
                            _assignedSeats.remove(
                              _passengerSeatAssignment[passengerIndex],
                            );
                          }

                          if (isSelectedForThisPassenger) {
                            // Deselect seat
                            _passengerSeatAssignment.remove(
                              passengerIndex,
                            );
                          } else {
                            // Select new seat
                            _passengerSeatAssignment[passengerIndex] =
                                seatNumber.toInt();
                            _assignedSeats.add(seatNumber.toInt());
                          }
                        });
                      },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelectedForThisPassenger
                        ? AppColors.umragold.withOpacity(0.4)
                        : isAssigned
                            ? Colors.grey.shade400
                            : AppColors.umragold,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelectedForThisPassenger
                          ? AppColors.umragold
                          : Colors.grey.shade300,
                      width: isSelectedForThisPassenger ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Replace with: SvgPicture.asset('assets/images/busseat.svg', width: 20, height: 20, color: ...)
                      SvgPicture.asset(
                        'assets/images/busseat.svg',
                        width: 20,
                        height: 20,
                        color: isAssigned && !isSelectedForThisPassenger
                            ? Colors.grey.shade600
                            : Colors.white,
                      ),
                      SizedBox(height: 4),
                      Text(
                        seatNumber.toString(),
                        style: fontStyle(
                          fontSize: 10.sp,
                          color: isAssigned && !isSelectedForThisPassenger
                              ? Colors.grey.shade600
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGenderSelection({
    required String currentGender,
    required Function(String) onGenderSelected,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.wc, color: Colors.grey.shade600, size: 20),
          SizedBox(width: 12),
          Text(
            LanguageClass.isEnglish ? 'Gender:' : 'الجنس:',
            style: fontStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 16),
          // Male Option
          InkWell(
            onTap: () => onGenderSelected('Male'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: currentGender == 'Male'
                          ? AppColors.umragold
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: currentGender == 'Male'
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.umragold,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 8),
                Text(
                  LanguageClass.isEnglish ? 'Male' : 'ذكر',
                  style: fontStyle(
                    fontSize: 14.sp,
                    color: currentGender == 'Male'
                        ? AppColors.umragold
                        : Colors.grey.shade600,
                    fontWeight: currentGender == 'Male'
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          // Female Option
          InkWell(
            onTap: () => onGenderSelected('Female'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: currentGender == 'Female'
                          ? AppColors.umragold
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: currentGender == 'Female'
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.umragold,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 8),
                Text(
                  LanguageClass.isEnglish ? 'Female' : 'أنثى',
                  style: fontStyle(
                    fontSize: 14.sp,
                    color: currentGender == 'Female'
                        ? AppColors.umragold
                        : Colors.grey.shade600,
                    fontWeight: currentGender == 'Female'
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasDuplicateNationalId() {
    List<String> allNationalIds = [];

    // Add companions' national IDs if they are adults and have IDs
    for (int i = 0; i < idControllers.length; i++) {
      if (isAdultList[i] && idControllers[i].text.trim().isNotEmpty) {
        allNationalIds.add(idControllers[i].text.trim().toLowerCase());
      }
    }

    // Check for duplicates
    Set<String> uniqueIds = allNationalIds.toSet();
    return uniqueIds.length != allNationalIds.length;
  }

  // Method to validate for duplicate phone numbers
  bool _hasDuplicatePhoneNumbers() {
    List<String> allPhoneNumbers = [];

    // Add companions' phone numbers if they are adults and have phone numbers
    for (int i = 0; i < phone1List.length; i++) {
      if (isAdultList[i]) {
        if (phone1List[i]!.trim().isNotEmpty) {
          allPhoneNumbers.add(phone1List[i]!.trim());
        }
        if (phone2List[i]!.trim().isNotEmpty) {
          allPhoneNumbers.add(phone2List[i]!.trim());
        }
      }
    }

    // Check for duplicates
    Set<String> uniquePhones = allPhoneNumbers.toSet();
    return uniquePhones.length != allPhoneNumbers.length;
  }

  // Method to show duplicate data error
  void _showDuplicateDataError() {
    String errorMessage = "";

    if (_hasDuplicateNationalId() && _hasDuplicatePhoneNumbers()) {
      errorMessage = LanguageClass.isEnglish
          ? "Duplicate National ID and Phone Numbers found. Each passenger must have unique data."
          : "تم العثور على رقم هوية وأرقام هاتف مكررة. يجب أن يكون لكل راكب بيانات فريدة.";
    } else if (_hasDuplicateNationalId()) {
      errorMessage = LanguageClass.isEnglish
          ? "Duplicate National ID found. Each passenger must have a unique National ID."
          : "تم العثور على رقم هوية مكرر. يجب أن يكون لكل راكب رقم هوية فريد.";
    } else if (_hasDuplicatePhoneNumbers()) {
      errorMessage = LanguageClass.isEnglish
          ? "Duplicate Phone Numbers found. Each passenger must have unique phone numbers."
          : "تم العثور على أرقام هاتف مكررة. يجب أن يكون لكل راكب أرقام هاتف فريدة.";
    }

    if (errorMessage.isNotEmpty) {
      Constants.showDefaultSnackBar(
          context: context, text: errorMessage, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UmraBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Directionality(
                textDirection: LanguageClass.isEnglish
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(25),
                        child: Icon(
                          LanguageClass.isEnglish
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_forward_rounded,
                          color: AppColors.umragold,
                          size: 35,
                        ),
                      ),
                      Text(
                        LanguageClass.isEnglish
                            ? 'Passenger Info'
                            : 'بيانات الركاب',
                        style: fontStyle(
                          color: AppColors.blackColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 50), // For balance
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Passenger Cards
                        ...List.generate(widget.reservedSeats, (index) {
                          final isPrimary = index == 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildPassengerCard(index, false),
                          );
                        }),
                        SizedBox(height: 20),

                        // Submit Button
                        BlocListener<UmraBloc, UmraState>(
                          listener: (context, state) {
                            // if (state.isloading) {
                            //   Constants.showLoadingDialog(context);
                            // } else {
                            //   Navigator.of(
                            //     context,
                            //   ).pop(); // Dismiss loading dialog
                            //   if (state.umrahSubmissionSuccess) {
                            //     Constants.showDefaultSnackBar(
                            //       text: LanguageClass.isEnglish
                            //           ? 'Umrah reservation submitted successfully!'
                            //           : 'تم حجز العمرة بنجاح!',
                            //       color: Colors.green,
                            //     );
                            //     context.read<DashboardBloc>().add(
                            //           FetchDashboardData(),
                            //         );
                            //     context.read<BookingBloc>().add(
                            //           LoadReservationsEvent(),
                            //         );
                            //     Navigator.pushAndRemoveUntil(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) =>
                            //             MainScreen(initialIndex: 1),
                            //       ),
                            //       (route) => false,
                            //     );
                            //     context.read<BookingNavigationBloc>().add(
                            //           ShowSearchView(),
                            //         );
                            //
                            //     // Navigate to next screen or show success
                            //   } else if (state.umrahSubmissionError != null) {
                            //     Constants.showDefaultSnackBar(
                            //       text: LanguageClass.isEnglish
                            //           ? 'Submission failed: ${state.umrahSubmissionError}'
                            //           : 'فشل الإرسال: ${state.umrahSubmissionError}',
                            //       color: Colors.red,
                            //     );
                            //   }
                            // }
                          },
                          child: _buildSubmitButton(),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerCard(int index, bool isPrimary) {
    var countryid = CacheHelper.getDataToSharedPref(key: 'countryid') ?? 3;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: isPrimary
            ? null
            : () {
                setState(() {
                  passengerCardExpandedList[index] =
                      !passengerCardExpandedList[index];
                });
              },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isPrimary ? AppColors.umragold : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isPrimary ? Icons.person : Icons.person_add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    isPrimary
                        ? (LanguageClass.isEnglish
                            ? 'Primary Passenger'
                            : 'الراكب الرئيسي')
                        : (LanguageClass.isEnglish
                            ? 'Companion ${index + 1}' // Changed to index + 1 for companion number
                            : 'مرافق ${index + 1}'),
                    style: fontStyle(
                      color: isPrimary ? AppColors.umragold : Colors.orange,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  if (!isPrimary)
                    Icon(
                      passengerCardExpandedList[index]
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.umragold,
                    ),
                ],
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: passengerCardExpandedList[index] ? null : 0,
                curve: Curves.easeInOut,
                child: SingleChildScrollView(
                  physics:
                      NeverScrollableScrollPhysics(), // Prevents internal scrolling when collapsed
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: passengerCardExpandedList[index] ? 1.0 : 0.0,
                    child: passengerCardExpandedList[index]
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),

                              // Adult/Child Selection - Only for companions
                              if (!isPrimary) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                        color: Colors.grey.shade600,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        LanguageClass.isEnglish
                                            ? 'Type:'
                                            : 'النوع:',
                                        style: fontStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      // Adult Option
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isAdultList[index] = true;
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: isAdultList[index]
                                                      ? AppColors.umragold
                                                      : Colors.grey.shade400,
                                                  width: 2,
                                                ),
                                              ),
                                              child: isAdultList[index]
                                                  ? Center(
                                                      child: Container(
                                                        width: 10,
                                                        height: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: AppColors
                                                              .umragold,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              LanguageClass.isEnglish
                                                  ? 'Adult'
                                                  : 'بالغ',
                                              style: fontStyle(
                                                fontSize: 14.sp,
                                                color: isAdultList[index]
                                                    ? AppColors.umragold
                                                    : Colors.grey.shade600,
                                                fontWeight: isAdultList[index]
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      // Child Option
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isAdultList[index] = false;
                                            // Clear fields when switching to child
                                            idControllers[index].clear();
                                            phone1List[index] = '';
                                            phone2List[index] = '';
                                            countryCode1List[index] = '';
                                            countryCode2List[index] = '';
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: !isAdultList[index]
                                                      ? AppColors.umragold
                                                      : Colors.grey.shade400,
                                                  width: 2,
                                                ),
                                              ),
                                              child: !isAdultList[index]
                                                  ? Center(
                                                      child: Container(
                                                        width: 10,
                                                        height: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: AppColors
                                                              .umragold,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              LanguageClass.isEnglish
                                                  ? 'Child'
                                                  : 'طفل',
                                              style: fontStyle(
                                                fontSize: 14.sp,
                                                color: !isAdultList[index]
                                                    ? AppColors.umragold
                                                    : Colors.grey.shade600,
                                                fontWeight: !isAdultList[index]
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                              ],

                              SizedBox(height: 16),

                              // Gender Selection
                              _buildGenderSelection(
                                currentGender: genderList[index]!,
                                onGenderSelected: (gender) {
                                  setState(() {
                                    genderList[index] = gender;
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              // Full Name
                              TextFormField(
                                controller: nameControllers[index],
                                inputFormatters: [LettersOnlyFormatter()],
                                decoration: _inputDecoration(
                                  LanguageClass.isEnglish
                                      ? 'Full Name'
                                      : 'الاسم الكامل',
                                  Icons.person_outline,
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? (LanguageClass.isEnglish
                                            ? 'Please enter name'
                                            : 'يرجى إدخال الاسم')
                                        : null,
                              ),

                              SizedBox(height: 16),

                              // Seat Selection
                              _buildSeatSelection(index),
                              SizedBox(height: 16),

                              SizedBox(height: 16),

                              // Phone Number 1 - Only shown for adults (always shown for primary passenger)
                              if (isPrimary || isAdultList[index]) ...[
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: IntlPhoneField(
                                    inputFormatters: [NumbersOnlyFormatter()],
                                    initialCountryCode:
                                        countryid.toString() == "3"
                                            ? 'SA'
                                            : 'EG',
                                    decoration: _phoneInputDecoration(
                                      LanguageClass.isEnglish
                                          ? 'Phone Number 1'
                                          : 'رقم الهاتف 1',
                                    ),
                                    onChanged: (phone) {
                                      phone1List[index] = phone.number;
                                      countryCode1List[index] =
                                          phone.countryCode;
                                    },
                                    validator: (phone) {
                                      if ((isPrimary || isAdultList[index]) &&
                                          (phone == null ||
                                              phone.number.isEmpty)) {
                                        return LanguageClass.isEnglish
                                            ? 'Please enter phone number'
                                            : 'يرجى إدخال رقم الهاتف';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Phone Number 2 (optional) - Only shown for adults (always shown for primary passenger)
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: IntlPhoneField(
                                    inputFormatters: [NumbersOnlyFormatter()],
                                    initialCountryCode:
                                        countryid.toString() == "3"
                                            ? 'SA'
                                            : 'EG',
                                    decoration: _phoneInputDecoration(
                                      LanguageClass.isEnglish
                                          ? 'Phone Number 2 (Optional)'
                                          : 'رقم الهاتف 2 (اختياري)',
                                    ),
                                    onChanged: (phone) {
                                      phone2List[index] = phone.number;
                                      countryCode2List[index] =
                                          phone.countryCode;
                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                              ],

                              if ((isAdultList[index])) ...[
                                TextFormField(
                                  controller: idControllers[index],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    NumbersOnlyFormatter(),
                                    LengthLimitingTextInputFormatter(
                                      countryid.toString() == "3" ? 10 : 14,
                                    ),
                                  ],
                                  maxLength:
                                      countryid.toString() == "3" ? 10 : 14,
                                  decoration: _inputDecorationWithCamera(
                                    LanguageClass.isEnglish
                                        ? 'National ID'
                                        : 'رقم الهوية',
                                    Icons.credit_card,
                                    () => {},
                                  ),
                                  validator: (value) {
                                    if (isAdultList[index] &&
                                        (value == null || value.isEmpty)) {
                                      return LanguageClass.isEnglish
                                          ? 'Please enter national ID'
                                          : 'يرجى إدخال رقم الهوية';
                                    } else if (isAdultList[index] &&
                                        value!.isNotEmpty &&
                                        value.length !=
                                            (countryid.toString() == "3"
                                                ? 10
                                                : 14)) {
                                      return LanguageClass.isEnglish
                                          ? 'ID must be ${countryid.toString() == "3" ? 10 : 14} digits'
                                          : 'رقم الهوية يجب أن يكون ${countryid.toString() == "3" ? 10 : 14} أرقام';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 8),
                              ],

                              _buildCollapsibleNotes(index),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Builder(
      builder: (context) {
        final umraBloc = BlocProvider.of<UmraBloc>(context);
        return Container(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_hasDuplicateNationalId()) {
                  _showDuplicateDataError();
                  return;
                }
                if (_hasDuplicatePhoneNumbers()) {
                  _showDuplicateDataError();
                  return;
                }

                // Prepare companion list
                List<Map<String, dynamic>> companionList = [];
                for (int i = 1; i < UmraDetails.seatsNumbers.length; i++) {
                  // Start from index 1 for companions
                  companionList.add({
                    "FullName": nameControllers[i - 1].text,
                    "NationalID": idControllers[i - 1].text,
                    "Gender": genderList[i - 1]!.toLowerCase() == "male" ||
                            genderList[i - 1]!.toLowerCase() == "ذكر"
                        ? true
                        : false,
                    "SeatNumber": _passengerSeatAssignment[i - 1],
                    "IsChild": !isAdultList[i - 1],
                    "Notes": notesControllers[i - 1].text,
                    "Phone1": phone1List[i - 1],
                    "CountryCode1": countryCode1List[i - 1],
                    "Phone2": phone2List[i - 1],
                    "CountryCode2": countryCode2List[i - 1],
                  });
                }

                // Extract primary passenger data
                final primaryPassengerName = nameControllers[0].text;
                final primaryPassengerPhone1 = phone1List[0];
                final primaryPassengerCountryCode1 = countryCode1List[0];
                final primaryPassengerPhone2 = phone2List[0];
                final primaryPassengerCountryCode2 = countryCode2List[0];
                final primaryPassengerGender =
                    genderList[0]!.toLowerCase() == "male" ||
                            genderList[0]!.toLowerCase() == "ذكر"
                        ? true
                        : false;
                final primaryPassengerSeatGo = _passengerSeatAssignment[0];

                // Dispatch the event
                // umraBloc.add(
                //   SubmitUmrahEvent(
                //     type: 2, // Assuming type 2 for Partner
                //     customerName: primaryPassengerName,
                //     customerPhone: primaryPassengerPhone1,
                //     countryCode:
                //         primaryPassengerCountryCode1 ?? '', // Ensure non-null
                //     promoCode: UmraDetails
                //         .promocode, // Assuming this is where promoCode is stored
                //     companionList: companionList,
                //   ),
                // );
                UmraDetails.companionDetails = companionList;

                print(
                    "TIK TIK COMPANION DETAILS ${UmraDetails.companionDetails}");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationScreen(
                      umrahReservationID: widget.umrahReservationID,
                      selectedpackage: widget.selectedpackage,
                      typeid: widget.typeid,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.umragold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LanguageClass.isEnglish ? 'Continue' : 'استمرار',
                  style: fontStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.umragold),
      labelStyle: fontStyle(
        color: Colors.grey[600]!,
        fontWeight: FontWeight.normal,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.umragold, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  InputDecoration _inputDecorationWithCamera(
    String label,
    IconData prefixIcon,
    VoidCallback onCameraPressed,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon, color: AppColors.umragold),
      suffixIcon: IconButton(
        icon: Icon(Icons.camera_alt, color: AppColors.umragold),
        onPressed: onCameraPressed,
      ),
      labelStyle: fontStyle(
        color: Colors.grey[600]!,
        fontWeight: FontWeight.normal,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.umragold, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  InputDecoration _phoneInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: fontStyle(
        color: Colors.grey[600]!,
        fontWeight: FontWeight.normal,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.umragold, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  // Future<void> scanNationalId(int index) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //
  //   if (pickedFile == null) return;
  //
  //   final inputImage = InputImage.fromFilePath(pickedFile.path);
  //   final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  //   final recognizedText = await textRecognizer.processImage(inputImage);
  //
  //   final extractedId = recognizedText.text
  //       .replaceAll(RegExp(r'[^0-9]'), '')
  //       .split('\n')
  //       .firstWhere(
  //         (line) => RegExp(r'^\d{10}$').hasMatch(line),
  //         orElse: () => '',
  //       );
  //
  //   if (extractedId.isNotEmpty) {
  //     setState(() {
  //       idControllers[index].text = extractedId;
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           LanguageClass.isEnglish
  //               ? 'Could not recognize a valid 10-digit ID'
  //               : 'لم يتم التعرف على رقم هوية صالح مكون من 10 أرقام',
  //         ),
  //       ),
  //     );
  //   }
  // }
}
