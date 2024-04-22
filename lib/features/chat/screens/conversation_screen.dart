import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/chat/controllers/chat_controller.dart';
import 'package:sixam_mart/features/chat/enums/user_type_enum.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/not_logged_in_screen.dart';
import 'package:sixam_mart/common/widgets/paginated_list_view.dart';
import 'package:sixam_mart/features/chat/widgets/web_chat_view_widget.dart';
import 'package:sixam_mart/features/search/widgets/search_field_widget.dart';

class ConversationScreen extends StatefulWidget {
  final bool fromNavBar;
  const ConversationScreen({super.key, this.fromNavBar = false});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall(){
    if(AuthHelper.isLoggedIn()) {
      Get.find<ProfileController>().getUserInfo();
      Get.find<ChatController>().getConversationList(1, type: ResponsiveHelper.isDesktop(Get.context) ? 'vendor' : '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      ConversationsModel? conversation;
      if(chatController.searchConversationModel != null) {
        conversation = chatController.searchConversationModel;
      }else {
        conversation = chatController.conversationModel;
      }

      return Scaffold(
        appBar: CustomAppBar(title: 'conversation_list'.tr, backButton: !widget.fromNavBar),
        endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
        floatingActionButton: (chatController.conversationModel != null && !chatController.hasAdmin) && !ResponsiveHelper.isDesktop(context) ? FloatingActionButton.extended(
          label: SizedBox(
            width: context.width * 0.75,
            child: Text(
              '${'chat_with'.tr} ${Get.find<SplashController>().configModel!.businessName}',
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white),
            ),
          ),
          icon: const Icon(Icons.chat, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => Get.toNamed(RouteHelper.getChatRoute(notificationBody: NotificationBodyModel(
            notificationType: NotificationType.message, adminId: 0,
          ))),
        ) : null,
        body: ResponsiveHelper.isDesktop(context) ? WebChatViewWidget(
          scrollController: _scrollController,
          conversation: conversation,
          chatController: chatController,
          searchController: _searchController,
          initCall: initCall,
        ) : Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(children: [

            (AuthHelper.isLoggedIn() && conversation != null && conversation.conversations != null
            && chatController.conversationModel!.conversations!.isNotEmpty) ? Center(child: SizedBox(width: Dimensions.webMaxWidth, child: SearchFieldWidget(
              controller: _searchController,
              hint: 'search'.tr,
              suffixIcon: chatController.searchConversationModel != null ? Icons.close : Icons.search,
              onSubmit: (String text) {
                if(_searchController.text.trim().isNotEmpty) {
                  chatController.searchConversation(_searchController.text.trim());
                }else {
                  showCustomSnackBar('write_something'.tr);
                }
              },
              iconPressed: () {
                if(chatController.searchConversationModel != null) {
                  _searchController.text = '';
                  chatController.removeSearchMode();
                }else {
                  if(_searchController.text.trim().isNotEmpty) {
                    chatController.searchConversation(_searchController.text.trim());
                  }else {
                    showCustomSnackBar('write_something'.tr);
                  }
                }
              },
            ))) : const SizedBox(),
            SizedBox(height: (AuthHelper.isLoggedIn() && conversation != null && conversation.conversations != null
                && chatController.conversationModel!.conversations!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

            Expanded(child: AuthHelper.isLoggedIn() ? (conversation != null && conversation.conversations != null)
            ? conversation.conversations!.isNotEmpty ? RefreshIndicator(
              onRefresh: () async {
                await Get.find<ChatController>().getConversationList(1);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                child: FooterView(
                  child: SizedBox(width: Dimensions.webMaxWidth, child: PaginatedListView(
                    scrollController: _scrollController,
                    onPaginate: (int? offset) => chatController.getConversationList(offset!),
                    totalSize: conversation.totalSize,
                    offset: conversation.offset,
                    enabledPagination: chatController.searchConversationModel == null,
                    itemView: ListView.builder(
                      itemCount: conversation.conversations!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        User? user;
                        String? type;
                        if(conversation!.conversations![index]!.senderType == UserType.user.name
                            || conversation.conversations![index]!.senderType == UserType.customer.name) {
                          user = conversation.conversations![index]!.receiver;
                          type = conversation.conversations![index]!.receiverType;
                        }else {
                          user = conversation.conversations![index]!.sender;
                          type = conversation.conversations![index]!.senderType;
                        }

                        String? baseUrl = '';
                        if(type == UserType.vendor.name) {
                          baseUrl = Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl;
                        }else if(type == UserType.delivery_man.name) {
                          baseUrl = Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl;
                        }else if(type == UserType.admin.name){
                          baseUrl = Get.find<SplashController>().configModel!.baseUrls!.businessLogoUrl;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),

                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                          ),
                          child: CustomInkWell(
                            onTap: () {
                              if(user != null) {
                                Get.toNamed(RouteHelper.getChatRoute(
                                  notificationBody: NotificationBodyModel(
                                    type: conversation!.conversations![index]!.senderType,
                                    notificationType: NotificationType.message,
                                    adminId: type == UserType.admin.name ? 0 : null,
                                    restaurantId: type == UserType.vendor.name ? user.id : null,
                                    deliverymanId: type == UserType.delivery_man.name ? user.id : null,
                                  ),
                                  conversationID: conversation.conversations![index]!.id,
                                  index: index,
                                ));
                              }else {
                                showCustomSnackBar('${type!.tr} ${'not_found'.tr}');
                              }
                            },
                            highlightColor: Theme.of(context).colorScheme.background.withOpacity(0.1),
                            radius: Dimensions.radiusSmall,
                            child: Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Row(children: [
                                  ClipOval(child: CustomImage(
                                    height: 50, width: 50,
                                    image: '$baseUrl/${user != null ? user.image : ''}',
                                  )),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    user != null ? Text(
                                      '${user.fName} ${user.lName}', style: robotoMedium,
                                    ) : Text('${type!.tr} ${'deleted'.tr}', style: robotoMedium),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    user != null ? Text(
                                      type!.tr,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                    ) : const SizedBox(),
                                  ])),
                                ]),
                              ),

                              Positioned(
                                right: Get.find<LocalizationController>().isLtr ? 5 : null, bottom: 5, left: Get.find<LocalizationController>().isLtr ? null : 5,
                                child: Text(
                                  DateConverter.localDateToIsoStringAMPM(DateConverter.dateTimeStringToDate(
                                      conversation.conversations![index]!.lastMessageTime!)),
                                  style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall),
                                ),
                              ),

                              GetBuilder<ProfileController>(builder: (profileController) {
                                return (profileController.userInfoModel != null && profileController.userInfoModel!.userInfo != null
                                && conversation!.conversations![index]!.lastMessage!.senderId != profileController.userInfoModel!.userInfo!.id
                                && conversation.conversations![index]!.unreadMessageCount! > 0) ? Positioned(
                                  right: Get.find<LocalizationController>().isLtr ? 5 : null, top: 5, left: Get.find<LocalizationController>().isLtr ? null : 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                                    child: Text(
                                      conversation.conversations![index]!.unreadMessageCount.toString(),
                                      style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                                    ),
                                  ),
                                ) : const SizedBox();
                              }),

                            ]),
                          ),
                        );
                      },
                    ),
                  )),
                ),
              ),
            ) : Center(child: Text('no_conversation_found'.tr)) : const Center(child: CircularProgressIndicator()) :  NotLoggedInScreen(callBack: (value){
              initCall();
              setState(() {});
            })),

          ]),
        ),
      );
    });
  }
}
