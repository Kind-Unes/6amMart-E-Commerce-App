import 'package:flutter/foundation.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CustomValidator {

  static Future<PhoneValid> isPhoneValid(String number) async {
    String phone = number;
    bool isValid = false;
      try {
        PhoneNumber phoneNumber = PhoneNumber.parse(number);
        isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
      } catch (e) {
        debugPrint('Phone Number is not parsing: $e');
      }
    return PhoneValid(isValid: isValid, phone: phone);
  }

}

class PhoneValid {
  bool isValid;
  String phone;
  PhoneValid({required this.isValid, required this.phone});
}