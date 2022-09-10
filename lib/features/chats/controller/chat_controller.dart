// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wpclonemn/common/enums/message_enum.dart';
import 'package:wpclonemn/common/providers/message_reply_provider.dart';
import 'package:wpclonemn/features/auth/controller/auth_controller.dart';
import 'package:wpclonemn/features/chats/repositories/chat_repository.dart';
import 'package:wpclonemn/models/chat_contact.dart';
import 'package:wpclonemn/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRespository = ref.watch(chatRespositoryProvider);
  return ChatController(
    chatRespository: chatRespository,
    ref: ref,
  );
});

class ChatController {
  final ChatRespository chatRespository;
  final ProviderRef ref;
  ChatController({
    required this.chatRespository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRespository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRespository.getChatStream(recieverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRespository.sendTextMessage(
              context: context,
              text: text,
              recieverUserId: recieverUserId,
              senderUser: value!,
              messageReply: messageReply),
        );
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRespository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
          ),
        );
  }

  void sendGIFMessage(
    BuildContext context,
    String gifURL,
    String recieverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    // https://giphy.com/gifs/usopen-2022-serena-williams-us-open-Le9RoUFjFgVTe3f7eQ
    // https://media4.giphy.com/media/ ? /200.gif /giphy.webp

    int gifurlPartIndex = gifURL.lastIndexOf("-") + 1;
    String gifUrlPart = gifURL.substring(gifurlPartIndex);
    String newgifUrl = "https://i.giphy.com/media/$gifUrlPart/giphy.webp";

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRespository.sendGIFMessage(
            context: context,
            gifURL: newgifUrl,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
          ),
        );
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRespository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
}
