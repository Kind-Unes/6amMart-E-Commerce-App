import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sixam_mart/features/flash_sale/domain/models/flash_sale_model.dart';
import 'package:sixam_mart/features/flash_sale/domain/models/product_flash_sale.dart';
import 'package:sixam_mart/features/flash_sale/domain/services/flash_sale_service_interface.dart';

class FlashSaleController extends GetxController implements GetxService {
  final FlashSaleServiceInterface flashSaleServiceInterface;
  FlashSaleController({required this.flashSaleServiceInterface});

  Duration? _duration;
  Duration? get duration => _duration;
  
  Timer? _timer;
  
  FlashSaleModel? _flashSaleModel;
  FlashSaleModel? get flashSaleModel => _flashSaleModel;
  
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  
  ProductFlashSale? _productFlashSale;
  ProductFlashSale? get productFlashSale => _productFlashSale;

  void setPageIndex(int index) {
    _pageIndex = index;
    update();
  }

  void setEmptyFlashSale({bool fromModule = false}) {
    if(fromModule) {
      _flashSaleModel = null;
    }
  }

  Future<void> getFlashSale(bool reload, bool notify) async {
    if(_flashSaleModel == null || reload) {
      _flashSaleModel = null;
    }
    if(notify) {
      update();
    }
    if(_flashSaleModel == null || reload) {
      FlashSaleModel? flashSaleModel = await flashSaleServiceInterface.getFlashSale();
      if (flashSaleModel != null) {
        _flashSaleModel = flashSaleModel;
        if(_flashSaleModel?.endDate != null) {
          DateTime endTime = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(_flashSaleModel!.endDate!, true).toLocal();
          _duration = endTime.difference(DateTime.now());
          _timer?.cancel();
          _timer = null;
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            _duration = _duration! - const Duration(seconds: 1);
            update();
          });
        }
      }
      update();
    }
  }

  Future<void> getFlashSaleWithId(int offset, bool reload, int id) async {
    if(reload) {
      _productFlashSale = null;
      update();
    }
    ProductFlashSale? productFlashSale = await flashSaleServiceInterface.getFlashSaleWithId(id, offset);
    if (productFlashSale != null) {

      if(offset == 1){
        _productFlashSale = productFlashSale;
      } else {
        _productFlashSale!.totalSize = productFlashSale.totalSize;
        _productFlashSale!.offset = productFlashSale.offset;
        _productFlashSale!.flashSale = productFlashSale.flashSale;
        _productFlashSale!.products!.addAll(productFlashSale.products!);
      }

      if(_productFlashSale!.flashSale!.endDate != null) {
        DateTime endTime = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(_productFlashSale!.flashSale!.endDate!, true).toLocal();
        _duration = endTime.difference(DateTime.now());
        _timer?.cancel();
        _timer = null;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _duration = _duration! - const Duration(seconds: 1);
          update();
        });
      }
      update();
    }
  }
  
}