import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/features/bus_reservation_layout/data/models/Ticket_class.dart';
import 'package:swa/features/bus_reservation_layout/presentation/screens/reservation_ticket.dart';

import '../../../../core/local_cache_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/language.dart';
import '../../../../core/utils/letters_only_formatter.dart';
import '../../../../core/utils/numbers_only_formatter.dart';
import '../../../../core/utils/styles.dart';
import '../../../../main.dart';
import '../../../sign_in/domain/entities/user.dart';
import '../../../sign_in/presentation/cubit/login_cubit.dart';
import '../../../times_trips/data/models/TimesTripsResponsedart.dart';

class CustomerInfoScreen extends StatefulWidget {
  final String from;
  final String to;
  final String tocity;
  final String fromcity;
  final bool isedit;
  final DateTime? busdate;
  final String? busttime;
  final String triTypeId;
  final int busGoId;
  final List<TripList>? tripListBack;
  final num price;
  final int? tripId;
  final List<num> Seatsnumbers;
  final String toStationName;
  final String fromStationName;
  final List<num> actualSeats;
  final String? tripTypeId;
  final User? user;
  final bool? isFromBackTrip;

  const CustomerInfoScreen({
    super.key,
    required this.to,
    required this.tocity,
    required this.fromcity,
    required this.from,
    required this.triTypeId,
    required this.isedit,
    required this.busGoId,
    this.tripListBack,
    this.busdate,
    this.busttime,
    this.user,
    this.tripTypeId,
    required this.isFromBackTrip,
    required this.price,
    required this.tripId,
    required this.Seatsnumbers,
    required this.actualSeats,
    required this.fromStationName,
    required this.toStationName,
  });

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

// tripListBack: widget
//     .tripListBack,
// tripTypeId:
// widget.triTypeId,
// user: widget.user,

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _natIdController = TextEditingController();

  String? _phone1, _countryCode1;
  String? _phone2, _countryCode2;

  var countryid = CacheHelper.getDataToSharedPref(key: 'countryid') ?? 3;
  List<TextEditingController> _companionNameControllers = [];
  List<TextEditingController> _companionIdControllers = [];
  List<TextEditingController> _companionPhone1Controllers = [];
  List<TextEditingController> _companionPhone2Controllers = [];
  List<bool> _companionIsAdult = [];
  List<String> _companionGenders = [];
  String _primaryGender = 'Male'; // Default gender
  final TextEditingController _notesController = TextEditingController();
  Map<int, int?> _passengerSeatAssignment = {}; // passengerIndex -> seatNumber
  Set<int> _assignedSeats = {};
  bool _primaryNotesVisible = false;
  List<bool> _companionNotesVisible = [];
  final TextEditingController _primaryNotesController = TextEditingController();
  List<TextEditingController> _companionNotesControllers = [];

  @override
  void initState() {
    super.initState();
    int companionsCount = widget.Seatsnumbers.length - 1;

    _companionNameControllers = List.generate(
      companionsCount,
      (_) => TextEditingController(),
    );
    _companionIdControllers = List.generate(
      companionsCount,
      (_) => TextEditingController(),
    );
    _companionPhone1Controllers = List.generate(
      companionsCount,
      (_) => TextEditingController(),
    );
    _companionPhone2Controllers = List.generate(
      companionsCount,
      (_) => TextEditingController(),
    );
    _companionIsAdult = List.generate(companionsCount, (_) => true);
    _companionGenders = List.generate(companionsCount, (_) => 'Male');
    _companionNotesVisible = List.generate(companionsCount, (_) => false);
    _companionNotesControllers = List.generate(
      companionsCount,
      (_) => TextEditingController(),
    );
  }

  Widget _buildCollapsibleNotes({
    required bool isVisible,
    required VoidCallback onToggle,
    required TextEditingController controller,
    required Color iconColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  isVisible ? Icons.note_alt : Icons.note_add,
                  color: iconColor,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  LanguageClass.isEnglish ? 'Notes' : 'ملاحظات',
                  style: fontStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                Spacer(),
                Icon(
                  isVisible ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isVisible ? null : 0,
          child: isVisible
              ? Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: TextFormField(
                    controller: controller,
                    maxLines: 3,
                    decoration: _inputDecoration(
                      LanguageClass.isEnglish
                          ? 'Additional Notes (Optional)'
                          : 'ملاحظات إضافية (اختياري)',
                      Icons.note_alt_outlined,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
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
                          ? AppColors.primaryColor
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
                              color: AppColors.primaryColor,
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
                        ? AppColors.primaryColor
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
                          ? AppColors.primaryColor
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
                              color: AppColors.primaryColor,
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
                        ? AppColors.primaryColor
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

  Widget _buildSeatSelection(int passengerIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event_seat, color: AppColors.primaryColor, size: 20),
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
            children: widget.actualSeats.map((seatNumber) {
              bool isAssigned = _assignedSeats.contains(seatNumber.toInt());
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
                        ? AppColors.primaryColor.withOpacity(0.4)
                        : isAssigned
                            ? Colors.grey.shade400
                            : AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelectedForThisPassenger
                          ? AppColors.primaryColor
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

  bool _hasDuplicateNationalId() {
    List<String> allNationalIds = [];

    // Add primary passenger's national ID if not empty
    if (_natIdController.text.trim().isNotEmpty) {
      allNationalIds.add(_natIdController.text.trim().toLowerCase());
    }

    // Add companions' national IDs if they are adults and have IDs
    for (int i = 0; i < _companionIdControllers.length; i++) {
      if (_companionIsAdult[i] &&
          _companionIdControllers[i].text.trim().isNotEmpty) {
        allNationalIds.add(
          _companionIdControllers[i].text.trim().toLowerCase(),
        );
      }
    }

    // Check for duplicates
    Set<String> uniqueIds = allNationalIds.toSet();
    return uniqueIds.length != allNationalIds.length;
  }

  // Method to validate for duplicate phone numbers
  bool _hasDuplicatePhoneNumbers() {
    List<String> allPhoneNumbers = [];

    // Add primary passenger's phone numbers if not empty
    if (_phone1 != null && _phone1!.trim().isNotEmpty) {
      allPhoneNumbers.add(_phone1!.trim());
    }
    if (_phone2 != null && _phone2!.trim().isNotEmpty) {
      allPhoneNumbers.add(_phone2!.trim());
    }

    // Add companions' phone numbers if they are adults and have phone numbers
    for (int i = 0; i < _companionPhone1Controllers.length; i++) {
      if (_companionIsAdult[i]) {
        if (_companionPhone1Controllers[i].text.trim().isNotEmpty) {
          allPhoneNumbers.add(_companionPhone1Controllers[i].text.trim());
        }
        if (_companionPhone2Controllers[i].text.trim().isNotEmpty) {
          allPhoneNumbers.add(_companionPhone2Controllers[i].text.trim());
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
    print("Chosen seats: ${widget.Seatsnumbers}");
    print("PRICE GO : ${widget.price}");
    var countryid = CacheHelper.getDataToSharedPref(key: 'CountryID') ?? 3;

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
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
                        Icons.arrow_back_rounded,
                        color: AppColors.primaryColor,
                        size: 35,
                      ),
                    ),
                    Text(
                      LanguageClass.isEnglish
                          ? "Companion Data"
                          : "بيانات المرافقين",
                      style: fontStyle(
                        color: AppColors.blackColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.regular,
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
                      // Trip Summary Card
                      _buildTripSummaryCard(),
                      SizedBox(height: 16),

                      // Primary Passenger Card
                      // _buildPrimaryPassengerCard(),
                      // SizedBox(height: 16),

                      // Companions Cards
                      ..._buildCompanionCards(),

                      // Price Card
                      _buildPriceCard(),
                      SizedBox(height: 20),

                      // Submit Button
                      _buildSubmitButton(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.route, color: AppColors.primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  LanguageClass.isEnglish ? 'Trip Details' : 'تفاصيل الرحلة',
                  style: fontStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageClass.isEnglish ? 'From' : 'من',
                        style: fontStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600]!,
                        ),
                      ),
                      Text(
                        widget.fromStationName,
                        style: fontStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: AppColors.primaryColor),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        LanguageClass.isEnglish ? 'To' : 'إلى',
                        style: fontStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600]!,
                        ),
                      ),
                      Text(
                        widget.toStationName,
                        style: fontStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event_seat, color: AppColors.primaryColor, size: 16),
                SizedBox(width: 4),
                Text(
                  '${LanguageClass.isEnglish ? 'Seats: ' : 'المقاعد: '} ${widget.actualSeats.join(', ')}',
                  style: fontStyle(fontSize: 13.sp, color: Colors.grey[700]!),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range, color: AppColors.primaryColor, size: 16),
                SizedBox(width: 4),
                Text(
                  '${LanguageClass.isEnglish ? 'Date: ' : 'التاريخ: '} ${widget.busdate!.day}/${widget.busdate!.month}/${widget.busdate!.year}',
                  style: fontStyle(fontSize: 13.sp, color: Colors.grey[700]!),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.primaryColor,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '${LanguageClass.isEnglish ? 'Access time: ' : 'وقت الركوب: '} ${_formatTime12Hour(widget.busdate!, LanguageClass.isEnglish)}',
                  style: fontStyle(fontSize: 13.sp, color: Colors.grey[700]!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryPassengerCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  LanguageClass.isEnglish
                      ? 'Primary Passenger (You)'
                      : 'الراكب الرئيسي (انت)',
                  style: fontStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // TextFormField(
            //   controller: _nameController,
            //   inputFormatters: [LettersOnlyFormatter()],
            //   decoration: _inputDecoration(
            //     LanguageClass.isEnglish ? 'Customer Name' : 'اسم العميل',
            //     Icons.person_outline,
            //   ),
            //   validator: (value) => value!.isEmpty
            //       ? LanguageClass.isEnglish
            //           ? 'Please enter customer name'
            //           : 'برجاء ادخال اسم العميل'
            //       : null,
            // ),
            // SizedBox(height: 16),
            _buildGenderSelection(
              currentGender: _primaryGender,
              onGenderSelected: (gender) {
                setState(() {
                  _primaryGender = gender;
                });
              },
            ),
            SizedBox(height: 16),

            // Seat Selection
            _buildSeatSelection(-1),

            TextFormField(
              controller: _natIdController,
              maxLength: countryid.toString() == "3" ? 10 : 14,
              decoration: _inputDecoration(
                LanguageClass.isEnglish ? 'National ID' : 'الرقم القومي',
                Icons.credit_card,
              ),
              validator: (value) => value!.isEmpty
                  ? LanguageClass.isEnglish
                      ? 'Please enter national id'
                      : 'برجاء ادخال الرقم القومي'
                  : null,
            ),
            SizedBox(height: 16),

            // Directionality(
            //   textDirection: TextDirection.ltr,
            //   child: IntlPhoneField(
            //     inputFormatters: [NumbersOnlyFormatter()],
            //     decoration: _phoneInputDecoration(
            //       LanguageClass.isEnglish
            //           ? 'Customer Phone 1'
            //           : 'هاتف العميل 1',
            //     ),
            //     initialCountryCode: countryid.toString() == "3" ? 'SA' : 'EG',
            //     onChanged: (phone) {
            //       _phone1 = phone.number;
            //       _countryCode1 = phone.countryCode;
            //     },
            //     invalidNumberMessage: LanguageClass.isEnglish
            //         ? 'Enter valid phone number'
            //         : "ادخل رقم هاتف صحيح",
            //   ),
            // ),
            // SizedBox(height: 16),
            //
            // Directionality(
            //   textDirection: TextDirection.ltr,
            //   child: IntlPhoneField(
            //     inputFormatters: [NumbersOnlyFormatter()],
            //     invalidNumberMessage: LanguageClass.isEnglish
            //         ? 'Enter valid phone number'
            //         : "ادخل رقم هاتف صحيح",
            //     decoration: _phoneInputDecoration(
            //       LanguageClass.isEnglish
            //           ? 'Customer Phone 2'
            //           : 'هاتف العميل 2',
            //     ),
            //     initialCountryCode: countryid.toString() == "3" ? 'SA' : 'EG',
            //     onChanged: (phone) {
            //       _phone2 = phone.number;
            //       _countryCode2 = phone.countryCode;
            //     },
            //   ),
            // ),
            // SizedBox(height: 16),
            _buildCollapsibleNotes(
              isVisible: _primaryNotesVisible,
              onToggle: () {
                setState(() {
                  _primaryNotesVisible = !_primaryNotesVisible;
                });
              },
              controller: _primaryNotesController,
              iconColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCompanionCards() {
    return List.generate(_companionNameControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      LanguageClass.isEnglish
                          ? 'Companion ${index + 1}'
                          : 'المرافق ${index + 1}',
                      style: fontStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Adult/Child Selection
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
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
                        LanguageClass.isEnglish ? 'Type:' : 'النوع:',
                        style: fontStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 16),
                      // Adult Checkbox
                      InkWell(
                        onTap: () {
                          setState(() {
                            _companionIsAdult[index] = true;
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
                                  color: _companionIsAdult[index]
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: _companionIsAdult[index]
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 8),
                            Text(
                              LanguageClass.isEnglish ? 'Adult' : 'بالغ',
                              style: fontStyle(
                                fontSize: 14.sp,
                                color: _companionIsAdult[index]
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade600,
                                fontWeight: _companionIsAdult[index]
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      // Child Checkbox
                      InkWell(
                        onTap: () {
                          setState(() {
                            _companionIsAdult[index] = false;
                            // Clear national ID when switching to child
                            _companionIdControllers[index].clear();
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
                                  color: !_companionIsAdult[index]
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: !_companionIsAdult[index]
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 8),
                            Text(
                              LanguageClass.isEnglish ? 'Child' : 'طفل',
                              style: fontStyle(
                                fontSize: 14.sp,
                                color: !_companionIsAdult[index]
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade600,
                                fontWeight: !_companionIsAdult[index]
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

                SizedBox(height: 16),

                // Gender Selection
                _buildGenderSelection(
                  currentGender: _companionGenders[index],
                  onGenderSelected: (gender) {
                    setState(() {
                      _companionGenders[index] = gender;
                    });
                  },
                ),
                SizedBox(height: 16),

                // Seat Selection
                _buildSeatSelection(index),

                TextFormField(
                  controller: _companionNameControllers[index],
                  inputFormatters: [LettersOnlyFormatter()],
                  decoration: _inputDecoration(
                    LanguageClass.isEnglish ? 'Name' : 'الاسم',
                    Icons.person_outline,
                  ),
                  validator: (value) => value!.isEmpty
                      ? (LanguageClass.isEnglish
                          ? 'Please enter name'
                          : 'برجاء ادخال الاسم')
                      : null,
                ),
                SizedBox(height: 16),

                // National ID Field - Only show for adults
                if (_companionIsAdult[index]) ...[
                  TextFormField(
                    controller: _companionIdControllers[index],
                    keyboardType: TextInputType.number,
                    inputFormatters: [NumbersOnlyFormatter()],
                    maxLength: countryid.toString() == "3" ? 10 : 14,
                    decoration: _inputDecoration(
                      LanguageClass.isEnglish ? 'National ID' : 'الرقم القومي',
                      Icons.credit_card,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LanguageClass.isEnglish
                            ? 'Please enter national ID'
                            : 'يرجى إدخال رقم الهوية';
                      } else if (value.length != 10 &&
                          countryid.toString() == "3") {
                        return LanguageClass.isEnglish
                            ? 'ID must be 10 digits'
                            : 'رقم الهوية يجب أن يكون 10 أرقام';
                      } else if (value.length != 14 &&
                          countryid.toString() == "1") {
                        return LanguageClass.isEnglish
                            ? 'ID must be 14 digit'
                            : 'الرقم القومي يجب أن يكون 14 رقم';
                      }
                      return null;
                    },
                  ),

                  // SizedBox(height: 16),
                  // Directionality(
                  //   textDirection: TextDirection.ltr,
                  //   child: IntlPhoneField(
                  //     inputFormatters: [NumbersOnlyFormatter()],
                  //     invalidNumberMessage:
                  //         LanguageClass.isEnglish
                  //             ? 'Enter valid phone number'
                  //             : "ادخل رقم هاتف صحيح",
                  //     decoration: _phoneInputDecoration(
                  //       LanguageClass.isEnglish ? 'Phone 1' : 'الهاتف 1',
                  //     ),
                  //     initialCountryCode:
                  //         countryid.toString() == "3" ? 'SA' : 'EG',
                  //     onChanged: (phone) {
                  //       _companionPhone1Controllers[index].text = phone.number;
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 16),
                  //
                  // Directionality(
                  //   textDirection: TextDirection.ltr,
                  //   child: IntlPhoneField(
                  //     inputFormatters: [NumbersOnlyFormatter()],
                  //     decoration: _phoneInputDecoration(
                  //       LanguageClass.isEnglish
                  //           ? 'Phone 2 (Optional)'
                  //           : 'الهاتف 2 (اختياري)',
                  //     ),
                  //     initialCountryCode:
                  //         countryid.toString() == "3" ? 'SA' : 'EG',
                  //     onChanged: (phone) {
                  //       _companionPhone2Controllers[index].text = phone.number;
                  //     },
                  //   ),
                  // ),
                  SizedBox(height: 8),
                ],

                _buildCollapsibleNotes(
                  isVisible: _companionNotesVisible[index],
                  onToggle: () {
                    setState(() {
                      _companionNotesVisible[index] =
                          !_companionNotesVisible[index];
                    });
                  },
                  controller: _companionNotesControllers[index],
                  iconColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _formatTime12Hour(DateTime time, bool isEnglish) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final isPM = hour >= 12;
    final period =
        isEnglish ? (isPM ? 'PM' : 'AM') : (isPM ? 'مساءً' : 'صباحًا');
    final formattedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${formattedHour.toString().padLeft(2, '0')}:$minute $period';
  }

  Widget _buildPriceCard() {
    print("TIK TIK APP CURRENCY: ${Routes.curruncy}");
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.primaryColor.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  LanguageClass.isEnglish ? "Total Price" : "السعر الكلي",
                  style: fontStyle(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Text(
              "${(widget.price * widget.Seatsnumbers.length).toStringAsFixed(2)} ${Routes.curruncy != null ? Routes.curruncy : countryid.toString() == "3" ? "SAR" : "EGP"}",
              style: fontStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _submitBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LanguageClass.isEnglish ? "Continue" : 'استكمال',
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
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
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
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
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
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      // if (_hasDuplicateNationalId()) {
      //   _showDuplicateDataError();
      //   return;
      // }
      // if (_hasDuplicatePhoneNumbers()) {
      //   _showDuplicateDataError();
      //   return;
      // }
      // if (_phone1 == _phone2) {
      //   Constants.showDefaultSnackBar(
      //     context: context,
      //     text: LanguageClass.isEnglish
      //         ? "Duplicated phone number"
      //         : "رقم الهاتف مكرر",
      //     color: Colors.red,
      //   );
      // } else {
      final companionList = List.generate(
        _companionNameControllers.length,
        (index) => {
          "FullName": _companionNameControllers[index].text,
          "NationalID": _companionIdControllers[index].text,
          "Gender": _companionGenders[index].toLowerCase() == "ذكر" ||
              _companionGenders[index].toLowerCase() == "male",
          "SeatNumber": widget.actualSeats.length > index
              ? widget.actualSeats[index]
              : null,
          "IsChild": !_companionIsAdult[index],
          "Notes": _companionNotesControllers[index].text,
        },
      );

      if (widget.isFromBackTrip == false) {
        CacheHelper.setDataToSharedPref(
          key: "companionList",
          value: companionList,
        );
        Ticketreservation.companionDataGo = companionList;
      } else {
        Ticketreservation.companionDataBack = companionList;
        CacheHelper.setDataToSharedPref(
          key: "companionListBack",
          value: companionList,
        );
      }

      if (widget.tripTypeId == "1") {
        print("FROM 1");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<LoginCubit>(
              create: (context) => sl<LoginCubit>(),
              child: ReservationTicket(
                tripListBack: widget.tripListBack,
                tripTypeId: widget.triTypeId,
                user: widget.user,
                companionList: companionList,
              ),
            ),
          ),
        );
      } else if (widget.isFromBackTrip == false) {
        print("FROM 2");
        Navigator.pop(context);
        Navigator.pop(context);
      } else if (widget.isFromBackTrip == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<LoginCubit>(
              create: (context) => sl<LoginCubit>(),
              child: ReservationTicket(
                tripListBack: widget.tripListBack,
                tripTypeId: widget.triTypeId,
                user: widget.user,
                companionList: companionList,
              ),
            ),
          ),
        );
      }

      // Call your API directly here if needed.
      //}
    } else {
      Constants.showDefaultSnackBar(
        context: context,
        text: LanguageClass.isEnglish
            ? "Please enter all fields"
            : "برجاء ادخال جميع الحقول",
        color: Colors.red,
      );
    }
  }
}
