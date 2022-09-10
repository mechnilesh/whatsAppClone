// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wpclonemn/colors.dart';
import 'package:wpclonemn/features/auth/controller/auth_controller.dart';
import 'package:wpclonemn/features/call/controller/call_contoller.dart';
import 'package:wpclonemn/features/chats/widgets/chat_list.dart';
import 'package:wpclonemn/models/user_model.dart';

import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isGroupChat,
  }) : super(key: key);

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic  ,
          isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('loading...');
              }
              return Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: Color(0x2B08FCCB)),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 6),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(profilePic.toString()),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 3),
                      snapshot.data!.isOnline
                          ? Text(
                              'online',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            )
                          : Container(),
                    ],
                  ),
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => makeCall(ref, context),
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(recieverUserId: uid),
          ),
          BottomChatField(recieverUserId: uid),
        ],
      ),
    );
  }
}
