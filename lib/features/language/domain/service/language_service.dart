import 'package:flutter/material.dart';
import 'package:sixam_mart/features/language/domain/models/language_model.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/language/domain/repository/language_repository_interface.dart';
import 'package:sixam_mart/features/language/domain/service/language_service_interface.dart';

class LanguageService implements LanguageServiceInterface {
  final LanguageRepositoryInterface languageRepositoryInterface;
  LanguageService({required this.languageRepositoryInterface});

  @override
  bool setLTR(Locale locale) {
    bool isLtr = true;
    locale.languageCode == 'ar' ? isLtr = false : isLtr = true;
    return isLtr;
  }

  @override
  updateHeader(Locale locale, int? moduleId) {
    AddressModel? addressModel = languageRepositoryInterface.getAddressFormSharedPref();
    languageRepositoryInterface.updateHeader(addressModel, locale, moduleId);
  }

  @override
  Locale getLocaleFromSharedPref() {
    return languageRepositoryInterface.getLocaleFromSharedPref();
  }

  @override
  setselectedIndex(List<LanguageModel> languages, Locale locale) {
    int selectedIndex = 0;
    for(int index = 0; index<languages.length; index++) {
      if(languages[index].languageCode == locale.languageCode) {
        selectedIndex = index;
        break;
      }
    }
    return selectedIndex;
  }

  @override
  void saveLanguage(Locale locale) {
    languageRepositoryInterface.saveLanguage(locale);
  }

}