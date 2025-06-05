import 'dart:developer';

import 'package:phone_numbers_parser/phone_numbers_parser.dart';

abstract class PhoneNumberValidatorService {
  Future<bool> isValid(String countrycode, String phoneNumber);
}

class PhoneNumberValidatorServiceImp implements PhoneNumberValidatorService {
  @override
  Future<bool> isValid(String countrycode, String phone) async {
    final phoneNumber = PhoneNumber.parse(countrycode + phone);

    log("is Phone Number Valid ${phoneNumber.isValid()} ");
    return phoneNumber.isValid();
  }
}
