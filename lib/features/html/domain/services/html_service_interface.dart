import 'package:get/get.dart';
import 'package:sixam_mart/util/html_type.dart';

abstract class HtmlServiceInterface{
  Future<Response> getHtmlText(HtmlType htmlType);
}