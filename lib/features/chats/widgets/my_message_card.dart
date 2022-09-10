// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:wpclonemn/colors.dart';
import 'package:wpclonemn/common/enums/message_enum.dart';
import 'package:wpclonemn/features/chats/widgets/displayTextImageGif.dart';
import 'package:wpclonemn/features/chats/widgets/replyTextImageGIf.dart';

class MyMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      // onLeftSwipe: onLeftSwipe,
      onRightSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            child: Stack(
              children: [
                Padding(
                  padding: isReplying
                      ? EdgeInsets.only(
                          left: 3,
                          right: 3,
                          top: 3,
                          bottom: 3,
                        )
                      : type == MessageEnum.text
                          ? const EdgeInsets.only(
                              left: 10,
                              right: 68,
                              top: 5,
                              bottom: 7,
                            )
                          : const EdgeInsets.only(
                              left: 3,
                              right: 3,
                              top: 3,
                              bottom: 3,
                            ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isReplying) ...[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // constraints: BoxConstraints(
                                // minWidth: MediaQuery.of(context).size.width),
                                // width: MediaQuery.of(context).size.width,

                                padding: EdgeInsets.only(
                                  bottom: 8,
                                  left: 16,
                                  right: 8,
                                  top: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Color.fromARGB(255, 9, 73, 74),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      username,
                                      // textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: messageColor,
                                      ),
                                    ),
                                    ReplyTextImageGIF(
                                      message: repliedText,
                                      type: repliedMessageType,
                                    ),
                                  ],
                                ),
                              ),
                              //
                              isReplying
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 4,
                                      ),
                                    )
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                  left: 4,
                                ),
                                child: DisplayTextImageGIF(
                                  message: "$message",
                                  type: type,
                                ),
                              ),

                              isReplying
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        )
                      ],
                      // isReplying
                      //     ? Padding(
                      //         padding: EdgeInsets.only(
                      //           bottom: 4,
                      //         ),
                      //       )
                      //     : SizedBox(),
                      isReplying
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                left: 4,
                              ),
                              child: DisplayTextImageGIF(
                                message: message,
                                type: type,
                              ),
                            ),
                      // isReplying
                      //     ? Padding(
                      //         padding: EdgeInsets.only(
                      //           bottom: 20,
                      //         ),
                      //       )
                      //     : SizedBox(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: type == MessageEnum.text ? 0 : 5,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          shadows: type == MessageEnum.text
                              ? null
                              : <Shadow>[
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 3.0,
                                    color: Colors.grey,
                                  ),
                                  Shadow(
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 8.0,
                                    color: Colors.black,
                                  ),
                                ],
                          fontSize: 12,
                          color: type == MessageEnum.text
                              ? Colors.white60
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      isSeen
                          ? Icon(
                              Icons.done_all,
                              color: Colors.blue,
                              size: 16,
                            )
                          : Icon(
                              shadows: type == MessageEnum.text
                                  ? null
                                  : <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 3.0,
                                        color: Colors.grey,
                                      ),
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 8.0,
                                        color: Colors.black,
                                      ),
                                    ],
                              Icons.done_all,
                              size: 16,
                              color: type == MessageEnum.text
                                  ? Colors.white60
                                  : Colors.white,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
