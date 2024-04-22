import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/auth/domain/reposotories/auth_repository_interface.dart';
import 'package:sixam_mart/features/verification/domein/reposotories/verification_repository_interface.dart';
import 'package:sixam_mart/features/verification/domein/services/verification_service_interface.dart';

class VerificationService implements VerificationServiceInterface {
  final VerificationRepositoryInterface verificationRepoInterface;
  final AuthRepositoryInterface authRepoInterface;

  VerificationService({required this.verificationRepoInterface, required this.authRepoInterface});

  @override
  Future<ResponseModel> forgetPassword(String? phone) async {
    return await verificationRepoInterface.forgetPassword(phone);
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String number, String password, String confirmPassword) async {
    return await verificationRepoInterface.resetPassword(resetToken, number, password, confirmPassword);
  }

  @override
  Future<ResponseModel> verifyPhone(String? phone, String otp, String? token) async {
    ResponseModel responseModel = await verificationRepoInterface.verifyPhone(phone, otp);
    if(responseModel.isSuccess) {
      authRepoInterface.saveUserToken(token!);
      await authRepoInterface.updateToken();
      authRepoInterface.clearSharedPrefGuestId();
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> verifyToken(String? phone, String token) async {
    return await verificationRepoInterface.verifyToken(phone, token);
  }

}