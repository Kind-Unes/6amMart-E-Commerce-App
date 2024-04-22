import 'package:sixam_mart/common/models/response_model.dart';

abstract class VerificationServiceInterface{
  Future<ResponseModel> forgetPassword(String? phone);
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword);
  Future<ResponseModel> verifyPhone(String? phone, String otp, String? token);
  Future<ResponseModel> verifyToken(String? phone, String token);
}