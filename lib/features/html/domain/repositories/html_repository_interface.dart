import 'package:sixam_mart/interfaces/repository_interface.dart';
import 'package:sixam_mart/util/html_type.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getHtmlText(HtmlType htmlType);
}