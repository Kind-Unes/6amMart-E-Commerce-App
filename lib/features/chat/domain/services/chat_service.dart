import 'package:get/get.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:sixam_mart/features/chat/domain/services/chat_service_interface.dart';
import 'package:sixam_mart/features/chat/enums/user_type_enum.dart';

class ChatService implements ChatServiceInterface {
  final ChatRepositoryInterface chatRepositoryInterface;
  ChatService({required this.chatRepositoryInterface});

  @override
  Future<ConversationsModel?> getConversationList(int offset, String type) async {
    return await chatRepositoryInterface.getList(offset: offset, conversationList: true, type: type);
  }

  @override
  Future<ConversationsModel?> searchConversationList(String name) async {
    return await chatRepositoryInterface.getList(searchConversationalList: true, name: name);
  }

  @override
  Future<Response> getMessages(int offset, int? userID, String userType, int? conversationID) async {
    return await chatRepositoryInterface.getMessages(offset, userID, userType, conversationID);
  }

  @override
  Future<Response> sendMessage(String message, List<MultipartBody> images, int? userID, String userType, int? conversationID) async {
    return await chatRepositoryInterface.sendMessage(message, images, userID, userType, conversationID);
  }

  @override
  int setIndex(List<Conversation?>? conversations) {
    int index0 = -1;
    for(int index = 0; index<conversations!.length; index++) {
      if(conversations[index]!.receiverType == UserType.admin.name) {
        index0 = index;
        break;
      }else if(conversations[index]!.receiverType == UserType.admin.name) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

  @override
  bool checkSender(List<Conversation?>? conversations) {
    bool sender = false;
    for(int index = 0; index<conversations!.length; index++) {
      if(conversations[index]!.receiverType == UserType.admin.name) {
        sender = false;
        break;
      }else if(conversations[index]!.receiverType == UserType.admin.name) {
        sender = true;
        break;
      }
    }
    return sender;
  }

  @override
  int findOutConversationUnreadIndex(List<Conversation?>? conversations, int? conversationID) {
    int index0 = -1;
    for(int index = 0; index<conversations!.length; index++) {
      if(conversationID == conversations[index]!.id) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

  @override
  Future<XFile> compressImage(XFile file) async {
    final ImageFile input = ImageFile(filePath: file.path, rawBytes: await file.readAsBytes());
    final Configuration config = Configuration(
      outputType: ImageOutputType.webpThenPng,
      useJpgPngNativeCompressor: false,
      quality: (input.sizeInBytes/1048576) < 2 ? 50 : (input.sizeInBytes/1048576) < 5 ? 30 : (input.sizeInBytes/1048576) < 10 ? 2 : 1,
    );
    final ImageFile output = await compressor.compress(ImageFileConfiguration(input: input, config: config));
    return XFile.fromData(output.rawBytes);
  }

  @override
  List<MultipartBody> processMultipartBody(List<XFile> chatImage) {
    List<MultipartBody> multipartImages = [];
    for (var image in chatImage) {
      multipartImages.add(MultipartBody('image[]', image));
    }
    return multipartImages;
  }

}