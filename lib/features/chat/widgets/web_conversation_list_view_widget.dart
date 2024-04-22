import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/features/chat/controllers/chat_controller.dart';
import 'package:sixam_mart/features/chat/enums/user_type_enum.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/common/widgets/paginated_list_view.dart';

class WebConversationListViewWidget extends StatefulWidget {
  final ScrollController scrollController;
  final ConversationsModel? conversation;
  final ChatController chatController;
  final String type;

  const WebConversationListViewWidget({super.key, required this.scrollController, required this.conversation, required this.chatController, required this.type, });

  @override
  State<WebConversationListViewWidget> createState() => _WebConversationListViewWidgetState();
}

class _WebConversationListViewWidgetState extends State<WebConversationListViewWidget> {

  @override
  void initState() {
    super.initState();

    Get.find<ChatController>().getConversationList(1, type: widget.type);
  }

  @override
  Widget build(BuildContext context) {

    User? user;
    return (widget.conversation != null && widget.conversation?.conversations != null) ? widget.conversation!.conversations!.isNotEmpty ? RefreshIndicator(
        onRefresh: () async {
        await Get.find<ChatController>().getConversationList(1, type: widget.type);
      },
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        child: SizedBox(width: Dimensions.webMaxWidth, child: PaginatedListView(
          scrollController: widget.scrollController,
          onPaginate: (int? offset) => widget.chatController.getConversationList(offset!),
          totalSize: widget.conversation!.totalSize,
          offset: widget.conversation!.offset,
          enabledPagination: widget.chatController.searchConversationModel == null,
          itemView: ListView.builder(
            itemCount: widget.conversation!.conversations!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {

              String? type;
              if(widget.conversation!.conversations![index]!.senderType == UserType.user.name
                  || widget.conversation?.conversations![index]!.senderType == UserType.customer.name) {
                user = widget.conversation?.conversations![index]!.receiver;
                type = widget.conversation?.conversations![index]!.receiverType;
              }else {
                user = widget.conversation?.conversations![index]!.sender;
                type = widget.conversation?.conversations![index]!.senderType;
              }

              String? baseUrl = '';
              if(type == UserType.vendor.name) {
                baseUrl = Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl;
              }else if(type == UserType.delivery_man.name) {
                baseUrl = Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl;
              }else if(type == UserType.admin.name){
                baseUrl = Get.find<SplashController>().configModel!.baseUrls!.businessLogoUrl;
              }

              return Column(
                children: [

                  Container(
                    decoration: BoxDecoration(
                      color: (widget.chatController.selectedIndex == index && widget.chatController.type == type) ? Theme.of(context).primaryColor.withOpacity(0.10) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: CustomInkWell(
                      onTap: () {
                        String? type;
                        if(widget.conversation!.conversations![index]!.senderType == UserType.user.name
                            || widget.conversation?.conversations![index]!.senderType == UserType.customer.name) {
                          user = widget.conversation?.conversations![index]!.receiver;
                          type = widget.conversation?.conversations![index]!.receiverType;
                        }else {
                          user = widget.conversation?.conversations![index]!.sender;
                          type = widget.conversation?.conversations![index]!.senderType;
                        }

                        String? baseUrl = '';
                        if(type == UserType.vendor.name) {
                          baseUrl = Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl;
                        }else if(type == UserType.delivery_man.name) {
                          baseUrl = Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl;
                        }else if(type == UserType.admin.name){
                          baseUrl = Get.find<SplashController>().configModel!.baseUrls!.businessLogoUrl;
                        }

                        if(AuthHelper.isLoggedIn()) {
                          Get.find<ChatController>().getMessages(1, NotificationBodyModel(
                            type: widget.conversation!.conversations![index]!.senderType,
                            notificationType: NotificationType.message,
                            adminId: type == UserType.admin.name ? 0 : null,
                            restaurantId: type == UserType.vendor.name ? user?.id : null,
                            deliverymanId: type == UserType.delivery_man.name ? user?.id : null,

                          ), user, widget.conversation?.conversations![index]!.id, firstLoad: true);
                          if(Get.find<ProfileController>().userInfoModel == null || Get.find<ProfileController>().userInfoModel!.userInfo == null) {
                            Get.find<ProfileController>().getUserInfo();
                          }
                          widget.chatController.setNotificationBody(
                            NotificationBodyModel(
                              type: widget.conversation!.conversations![index]!.senderType,
                              notificationType: NotificationType.message,
                              adminId: type == UserType.admin.name ? 0 : null,
                              restaurantId: type == UserType.vendor.name ? user?.id : null,
                              deliverymanId: type == UserType.delivery_man.name ? user?.id : null,
                              conversationId: widget.conversation?.conversations![index]!.id,
                              index: index,
                              image: '$baseUrl/${user != null ? user?.image : ''}',
                              name:  '${user?.fName} ${user?.lName}',
                              receiverType: type,
                            ),
                          );

                          widget.chatController.setSelectedIndex(index);

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
                              image: '$baseUrl/${user != null ? user?.image : ''}',
                            )),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                              user != null ? Text(
                                '${user?.fName} ${user?.lName}', style: robotoMedium,
                              ) : Text('${type!.tr} ${'deleted'.tr}', style: robotoMedium),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              widget.conversation!.conversations![index]!.lastMessage != null ? Text(
                                widget.conversation!.conversations![index]!.lastMessage!.message ?? '',
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                              ) : const SizedBox(),
                            ])),
                          ]),
                        ),

                        Positioned(
                          right: Get.find<LocalizationController>().isLtr ? 5 : null, top: 15, left: Get.find<LocalizationController>().isLtr ? null : 5,
                          child: Text(
                            DateConverter.convertOnlyTodayTime(widget.conversation!.conversations![index]!.lastMessageTime!),
                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall),
                          ),
                        ),

                        GetBuilder<ProfileController>(builder: (profileController) {
                          return (profileController.userInfoModel != null && profileController.userInfoModel!.userInfo != null
                              && widget.conversation!.conversations![index]!.lastMessage!.senderId != profileController.userInfoModel!.userInfo!.id
                              && widget.conversation!.conversations![index]!.unreadMessageCount! > 0) ? Positioned(right: Get.find<LocalizationController>().isLtr ? 5 : null, bottom: 8, left: Get.find<LocalizationController>().isLtr ? null : 5,
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                              child: Text(
                                widget.conversation!.conversations![index]!.unreadMessageCount.toString(),
                                style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                              ),
                            ),
                          ) : const SizedBox();
                        }),

                      ]),
                    ),
                  ),

                  index + 1 == widget.conversation!.conversations!.length ? const SizedBox() : Divider(color: Theme.of(context).disabledColor.withOpacity(.5)),

                ],
              );
            },
          ),
        )),
      ),
    ) : Center(child: Text('no_conversation_found'.tr)) : const ConversationShimmer();
  }
}

class ConversationShimmer extends StatelessWidget {
  const ConversationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(
                children: [

                  Row(children: [

                    ClipOval(child: Container(height: 50, width: 50, color: Colors.grey[300])),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Container(height: 10, width: Get.width * 0.5, color: Colors.grey[300]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Container(height: 10, width: Get.width * 0.3, color: Colors.grey[300]),

                    ])),
                  ]),

                  Divider(color: Theme.of(context).disabledColor.withOpacity(.5)),

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
