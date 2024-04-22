import 'package:flutter/foundation.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sixam_mart/features/html/controllers/html_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/html_type.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_page_title_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({super.key, required this.htmlType});

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<HtmlController>().getHtmlText(widget.htmlType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.htmlType == HtmlType.termsAndCondition ? 'terms_conditions'.tr
          : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr : widget.htmlType == HtmlType.privacyPolicy
          ? 'privacy_policy'.tr : widget.htmlType == HtmlType.shippingPolicy ? 'shipping_policy'.tr
          : widget.htmlType == HtmlType.refund ? 'refund_policy'.tr :  widget.htmlType == HtmlType.cancellation
          ? 'cancellation_policy'.tr : 'no_data_found'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<HtmlController>(builder: (htmlController) {
        return Center(
          child: htmlController.htmlText != null ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                WebScreenTitleWidget( title: widget.htmlType == HtmlType.termsAndCondition ? 'terms_conditions'.tr
                  : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr : widget.htmlType == HtmlType.privacyPolicy
                  ? 'privacy_policy'.tr : widget.htmlType == HtmlType.shippingPolicy ? 'shipping_policy'.tr
                  : widget.htmlType == HtmlType.refund ? 'refund_policy'.tr :  widget.htmlType == HtmlType.cancellation
                  ? 'cancellation_policy'.tr : 'no_data_found'.tr),

                FooterView(child: Ink(
                  width: Dimensions.webMaxWidth,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                    (htmlController.htmlText!.contains('<ol>') || htmlController.htmlText!.contains('<ul>')) ? HtmlWidget(
                      htmlController.htmlText ?? '',
                      key: Key(widget.htmlType.toString()),
                      onTapUrl: (String url) {
                        return launchUrlString(url, mode: LaunchMode.externalApplication);
                      },
                    ) : SelectableHtml(
                      data: htmlController.htmlText, shrinkWrap: true,
                      onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
                        if(url!.startsWith('www.')) {
                          url = 'https://$url';
                        }
                        if (kDebugMode) {
                          print('Redirect to url: $url');
                        }
                        html.window.open(url, "_blank");
                      },
                    ),

                  ]),
                ))
              ],
            ),
          ) : const CircularProgressIndicator(),
        );
      }),
    );
  }
}