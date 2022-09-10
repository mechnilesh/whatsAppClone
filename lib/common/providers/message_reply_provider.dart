// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wpclonemn/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;
  // final String replyUserName;

  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageEnum,
    // required this.replyUserName,
  });
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
