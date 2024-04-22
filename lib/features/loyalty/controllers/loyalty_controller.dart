import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/loyalty/domain/services/loyalty_service_interface.dart';
import 'package:sixam_mart/common/models/transaction_model.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';

class LoyaltyController extends GetxController implements GetxService {
  final LoyaltyServiceInterface loyaltyServiceInterface;

  LoyaltyController({required this.loyaltyServiceInterface});

  List<Transaction>? _transactionList;
  List<Transaction>? get transactionList => _transactionList;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  int? _pageSize;
  int? get popularPageSize => _pageSize;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getLoyaltyTransactionList(String offset, bool reload) async {
    if(offset == '1' || reload) {
      _offsetList = [];
      _offset = 1;
      _transactionList = null;
      if(reload) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      TransactionModel? transactionModel = await loyaltyServiceInterface.getLoyaltyTransactionList(offset);

      if (transactionModel != null) {
        if (offset == '1') {
          _transactionList = [];
        }
        _transactionList!.addAll(transactionModel.data!);
        _pageSize = transactionModel.totalSize;

        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> pointToWallet(int point) async {
    _isLoading = true;
    update();
    Response response = await loyaltyServiceInterface.pointToWallet(point: point);
    if (response.statusCode == 200) {
      Get.back();
      getLoyaltyTransactionList('1', true);
      Get.find<ProfileController>().getUserInfo();
      showCustomSnackBar('converted_successfully_transfer_to_your_wallet'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }


  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

}