import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wpclonemn/colors.dart';
import 'package:wpclonemn/common/providers/message_reply_provider.dart';
import 'package:wpclonemn/features/chats/widgets/replyTextImageGIf.dart';

void cancelReply(WidgetRef ref) {
  ref.read(messageReplyProvider.state).update((state) => null);
}

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: appBarColor,
        ),
        width: MediaQuery.of(context).size.width * 0.82,
        padding: EdgeInsets.only(bottom: 38, left: 8, right: 8, top: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        messageReply!.isMe ? 'You' : 'Opposite',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:
                              messageReply.isMe ? messageColor : Colors.orange,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.close,
                        size: 16,
                      ),
                      onTap: () => cancelReply(ref),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                // Text(
                //   maxLines: 4,
                //   messageReply.message,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontSize: 14,
                //   ),
                // ),
                ReplyTextImageGIF(
                  message: messageReply.message,
                  type: messageReply.messageEnum,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
