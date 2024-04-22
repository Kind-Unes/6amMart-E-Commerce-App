import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart/features/chat/enums/user_type_enum.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/features/chat/domain/models/chat_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/chat/domain/services/chat_service_interface.dart';

class ChatController extends GetxController implements GetxService {
  final ChatServiceInterface chatServiceInterface;
  ChatController({required this.chatServiceInterface});

  List<bool>? _showDate;
  List<bool>? get showDate => _showDate;
  
  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;
  
  final bool _isSeen = false;
  bool get isSeen => _isSeen;
  
  final bool _isSend = true;
  bool get isSend => _isSend;
  
  bool _isMe = false;
  bool get isMe => _isMe;
  
  bool _isLoading= false;
  bool get isLoading => _isLoading;
  
  final List<Message>  _deliveryManMessage = [];
  List<Message> get deliveryManMessage => _deliveryManMessage;
  
  final List<Message>  _adminManMessage = [];
  List<Message> get adminManMessages => _adminManMessage;
  
  List <XFile>_chatImage = [];
  List<XFile> get chatImage => _chatImage;
  
  List <Uint8List>_chatRawImage = [];
  List<Uint8List> get chatRawImage => _chatRawImage;
  
  ChatModel?  _messageModel;
  ChatModel? get messageModel => _messageModel;
  
  ConversationsModel? _conversationModel;
  ConversationsModel? get conversationModel => _conversationModel;
  
  ConversationsModel? _searchConversationModel;
  ConversationsModel? get searchConversationModel => _searchConversationModel;
  
  bool _hasAdmin = true;
  bool get hasAdmin => _hasAdmin;
  
  NotificationBodyModel? _notificationBody;
  NotificationBodyModel? get notificationBody => _notificationBody;
  
  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;
  
  String _type = 'vendor';
  String? get type => _type;
  
  bool _clickTab = false;
  bool get clickTab => _clickTab;

  void setType(String type) {
    _type = type;
    update();
  }

  void setTabSelect() {
    _clickTab = !_clickTab;
  }

  Future<void> getConversationList(int offset, {String type = ''}) async {
    _hasAdmin = true;
    _searchConversationModel = null;
    ConversationsModel? conversationModel = await chatServiceInterface.getConversationList(offset, type);
    if(conversationModel != null) {
      if(offset == 1) {
        _conversationModel = conversationModel;
      }else {
        _conversationModel!.totalSize = conversationModel.totalSize;
        _conversationModel!.offset = conversationModel.offset;
        _conversationModel!.conversations!.addAll(conversationModel.conversations!);
      }
      int index0 = chatServiceInterface.setIndex(_conversationModel!.conversations);
      bool sender = chatServiceInterface.checkSender(_conversationModel!.conversations);
      _hasAdmin = false;
      if(index0 != -1 && !ResponsiveHelper.isDesktop(Get.context)) {
        _hasAdmin = true;
        if(sender) {
          _conversationModel!.conversations![index0]!.sender = User(
            id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
            phone: Get.find<SplashController>().configModel!.phone, email: Get.find<SplashController>().configModel!.email,
            image: Get.find<SplashController>().configModel!.logo,
          );
        }else {
          _conversationModel!.conversations![index0]!.receiver = User(
            id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
            phone: Get.find<SplashController>().configModel!.phone, email: Get.find<SplashController>().configModel!.email,
            image: Get.find<SplashController>().configModel!.logo,
          );
        }
      }
    }
    update();
  }

  Future<void> searchConversation(String name) async {
    _searchConversationModel = ConversationsModel();
    update();
    ConversationsModel? searchConversationModel = await chatServiceInterface.searchConversationList(name);
    if(searchConversationModel != null) {
      _searchConversationModel = searchConversationModel;
      int index0 = chatServiceInterface.setIndex(_searchConversationModel!.conversations);
      bool sender = chatServiceInterface.checkSender(_searchConversationModel!.conversations);
      if(index0 != -1) {
        if(sender) {
          _searchConversationModel!.conversations![index0]!.sender = User(
            id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
            phone: Get.find<SplashController>().configModel!.phone, email: Get.find<SplashController>().configModel!.email,
            image: Get.find<SplashController>().configModel!.logo,
          );
        }else {
          _searchConversationModel!.conversations![index0]!.receiver = User(
            id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
            phone: Get.find<SplashController>().configModel!.phone, email: Get.find<SplashController>().configModel!.email,
            image: Get.find<SplashController>().configModel!.logo,
          );
        }
      }
    }
    update();
  }

  void removeSearchMode() {
    _searchConversationModel = null;
    update();
  }

  Future<void> getMessages(int offset, NotificationBodyModel? notificationBody, User? user, int? conversationID, {bool firstLoad = false}) async {
    Response? response;
    if(firstLoad) {
      _messageModel = null;
      _isSendButtonActive = false;
      _isLoading = false;
    }
    if(notificationBody == null || notificationBody.adminId != null) {
      response = await chatServiceInterface.getMessages(offset, 0, UserType.admin.name, null);
    } else if(notificationBody.restaurantId != null) {
      response = await chatServiceInterface.getMessages(offset, notificationBody.restaurantId, UserType.vendor.name, conversationID);
    } else if(notificationBody.deliverymanId != null) {
      response = await chatServiceInterface.getMessages(offset, notificationBody.deliverymanId, UserType.delivery_man.name, conversationID);
    }

    if (response != null && response.body['messages'] != {} && response.statusCode == 200) {
      if (offset == 1) {
        /// Unread-read
        if(conversationID != null && _conversationModel != null && !ResponsiveHelper.isDesktop(Get.context)) {
          int index0 = chatServiceInterface.findOutConversationUnreadIndex(_conversationModel!.conversations, conversationID);
          if(index0 != -1) {
            _conversationModel!.conversations![index0]!.unreadMessageCount = 0;
          }
        }
        if(Get.find<ProfileController>().userInfoModel == null) {
          await Get.find<ProfileController>().getUserInfo();
        }
        /// Manage Receiver
        _messageModel = ChatModel.fromJson(response.body);
        if(_messageModel!.conversation == null) {
          _messageModel!.conversation = Conversation(sender: User(
            id: Get.find<ProfileController>().userInfoModel!.id, image: Get.find<ProfileController>().userInfoModel!.image,
            fName: Get.find<ProfileController>().userInfoModel!.fName, lName: Get.find<ProfileController>().userInfoModel!.lName,
          ), receiver: notificationBody!.adminId != null ? User(
            id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
            image: Get.find<SplashController>().configModel!.logo,
          ) : user);
        }
        _sortMessage(notificationBody!.adminId);
      }else {
        _messageModel!.totalSize = ChatModel.fromJson(response.body).totalSize;
        _messageModel!.offset = ChatModel.fromJson(response.body).offset;
        _messageModel!.messages!.addAll(ChatModel.fromJson(response.body).messages!);
      }
    }
    update();
  }


  void pickImage(bool isRemove) async {
    if(isRemove) {
      _chatImage = [];
      _chatRawImage = [];
    }else {
      List<XFile> imageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      for(XFile xFile in imageFiles) {
        if(_chatImage.length >= 3) {
          showCustomSnackBar('can_not_add_more_than_3_image'.tr);
          break;
        }else {
          XFile file = await chatServiceInterface.compressImage(xFile);
          _chatImage.add(file);
          _chatRawImage.add(await file.readAsBytes());
        }
      }
      _isSendButtonActive = true;
    }
    update();
  }

  void removeImage(int index, String messageText){
    _chatImage.removeAt(index);
    _chatRawImage.removeAt(index);
    if(_chatImage.isEmpty && messageText.isEmpty) {
      _isSendButtonActive = false;
    }
    update();
  }

  Future<Response?> sendMessage({required String message, required NotificationBodyModel? notificationBody, required int? conversationID, required int? index}) async {
    Response? response;
    _isLoading = true;
    update();
    
    List<MultipartBody> myImages = chatServiceInterface.processMultipartBody(_chatImage);
    
    if(notificationBody == null || notificationBody.adminId != null) {
      response = await chatServiceInterface.sendMessage(message, myImages, 0, UserType.admin.name, null);
    } else if(notificationBody.restaurantId != null) {
      response = await chatServiceInterface.sendMessage(message, myImages, notificationBody.restaurantId, UserType.vendor.name, conversationID);
    } else if(notificationBody.deliverymanId != null) {
      response = await chatServiceInterface.sendMessage(message, myImages, notificationBody.deliverymanId, UserType.delivery_man.name, conversationID);
    }
    if (response!.statusCode == 200) {
      _chatImage = [];
      _chatRawImage = [];
      _isSendButtonActive = false;
      _isLoading = false;
      _messageModel = ChatModel.fromJson(response.body);
      if(index != null && _searchConversationModel != null) {
        _searchConversationModel!.conversations![index]!.lastMessageTime = DateConverter.isoStringToLocalString(_messageModel!.messages![0].createdAt!);
      }else if(index != null && _conversationModel != null) {
        _conversationModel!.conversations![index]!.lastMessageTime = DateConverter.isoStringToLocalString(_messageModel!.messages![0].createdAt!);
      }
      if(_conversationModel != null && !_hasAdmin && (_messageModel!.conversation!.senderType == UserType.admin.name || _messageModel!.conversation!.receiverType == UserType.admin.name)
          && !ResponsiveHelper.isDesktop(Get.context)) {
        _conversationModel!.conversations!.add(_messageModel!.conversation);
        _hasAdmin = true;
      }
      if(Get.find<ProfileController>().userInfoModel!.userInfo == null) {
        Get.find<ProfileController>().updateUserWithNewData(_messageModel!.conversation!.sender);
      }
      _sortMessage(notificationBody!.adminId);
      Future.delayed(const Duration(seconds: 2),() {
        getMessages(1, notificationBody, null, conversationID);
      });
    }
    update();
    return response;
  }

  void _sortMessage(int? adminId) {
    if(_messageModel!.conversation != null && (_messageModel!.conversation!.receiverType == UserType.user.name
        || _messageModel!.conversation!.receiverType == UserType.customer.name)) {
      User? receiver = _messageModel!.conversation!.receiver;
      _messageModel!.conversation!.receiver = _messageModel!.conversation!.sender;
      _messageModel!.conversation!.sender = receiver;
    }
    if(adminId != null) {
      _messageModel!.conversation!.receiver = User(
        id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
        image: Get.find<SplashController>().configModel!.logo,
      );
    }
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    update();
  }

  void setIsMe(bool value) {
    _isMe = value;
  }

  void reloadConversationWithNotification(int conversationID) {
    int index0 = -1;
    Conversation? conversation;
    for(int index=0; index<_conversationModel!.conversations!.length; index++) {
      if(_conversationModel!.conversations![index]!.id == conversationID) {
        index0 = index;
        conversation = _conversationModel!.conversations![index];
        break;
      }
    }
    if(index0 != -1) {
      _conversationModel!.conversations!.removeAt(index0);
    }
    conversation!.unreadMessageCount = conversation.unreadMessageCount! + 1;
    _conversationModel!.conversations!.insert(0, conversation);
    update();
  }

  void reloadMessageWithNotification(Message message) {
    _messageModel!.messages!.insert(0, message);
    update();
  }

  void setNotificationBody(NotificationBodyModel notificationBody) {
    _notificationBody = notificationBody;
    update();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    update();
  }
  
}