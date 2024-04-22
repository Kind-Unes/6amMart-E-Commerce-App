import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/payment/domain/models/offline_method_model.dart';
import 'package:sixam_mart/features/payment/domain/services/payment_service_interface.dart';

class PaymentController extends GetxController implements GetxService {
  final PaymentServiceInterface paymentServiceInterface;
  PaymentController({required this.paymentServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OfflineMethodModel>? _offlineMethodList;
  List<OfflineMethodModel>? get offlineMethodList => _offlineMethodList;

  List<TextEditingController> informationControllerList = [];
  List<FocusNode> informationFocusList = [];

  int _selectedOfflineBankIndex = 0;
  int get selectedOfflineBankIndex => _selectedOfflineBankIndex;

  Future<void> getOfflineMethodList()async {
    _offlineMethodList = await paymentServiceInterface.getOfflineMethodList();
    update();
  }

  void selectOfflineBank(int index, {bool canUpdate = true}){
    _selectedOfflineBankIndex = index;
    if(canUpdate) {
      update();
    }
  }

  void changesMethod({bool canUpdate = true}) {
    List<MethodInformations>? methodInformation = offlineMethodList![selectedOfflineBankIndex].methodInformations!;

    informationControllerList = [];
    informationFocusList = [];

    for(int index=0; index<methodInformation.length; index++) {
      informationControllerList.add(TextEditingController());
      informationFocusList.add(FocusNode());
    }
    if(canUpdate) {
      update();
    }

  }

  Future<bool> saveOfflineInfo(String data) async {
    _isLoading = true;
    update();
    bool success = await paymentServiceInterface.saveOfflineInfo(data);
    _isLoading = false;
    update();
    return success;
  }

  Future<bool> updateOfflineInfo(String data) async {
    _isLoading = true;
    update();
    bool success = await paymentServiceInterface.updateOfflineInfo(data);
    _isLoading = false;
    update();
    return success;
  }
}