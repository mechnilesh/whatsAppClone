// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wpclonemn/common/enums/message_enum.dart';
import 'package:wpclonemn/common/providers/message_reply_provider.dart';

import 'package:wpclonemn/features/chats/controller/chat_controller.dart';

import 'package:wpclonemn/models/message.dart';
import 'package:wpclonemn/features/chats/widgets/my_message_card.dart';
import 'package:wpclonemn/features/chats/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            message: message,
            isMe: isMe,
            messageEnum: messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:
          ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text('Loading...'),
          );
        }

        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          },
        );

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);
            var sendNameUId = messageData.senderId;

            //     var userData =
            // await firestore.collection('users').doc(auth.currentUser?.uid).get();

            if (!messageData.isSeen &&
                messageData.recieverId ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                    context,
                    widget.recieverUserId,
                    messageData.messageId,
                  );
            }

            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo, ///////////////
                repliedMessageType: messageData.repliedMessageType,
                onLeftSwipe: () => onMessageSwipe(
                  messageData.text,
                  true,
                  messageData.type,
                ),
                isSeen: messageData.isSeen,
              );
            }
            return SenderMessageCard(
              username: messageData.repliedTo,
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              repliedMessageType: messageData.repliedMessageType,
              repliedText: messageData.repliedMessage,
              // repliedText: messageData.repliedMessage,
              onLeftSwipe: () => onMessageSwipe(
                messageData.text,
                true,
                messageData.type,
              ),
            );
          },
        );
      },
    );
  }
}
