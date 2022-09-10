import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:wpclonemn/common/enums/message_enum.dart';
import 'package:wpclonemn/common/providers/message_reply_provider.dart';
import 'package:wpclonemn/common/utils/utils.dart';
import 'package:wpclonemn/features/chats/widgets/message_reply_preview.dart';

import '../../../colors.dart';
import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  BottomChatField({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  // FlutterSoundRecorder? _soundRecorder;
  final record = Record();
  final TextEditingController _messageController = TextEditingController();

  bool isShowSendButton = false;
  bool isAttachClicked = false;
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  bool isRecording = false;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // _soundRecorder = FlutterSoundRecorder();
    super.initState();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw SnackBar(
        content: Text('Mic permission not allowed!'),
      );
    }
    // await _soundRecorder!.openRecorder();

    isRecorderInit = true;
  }

  Future sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
      cancelReply(ref);
    } else {
      // setState(() {
      //   isRecording = !isRecording;
      // });

      // var tempDir = await getTemporaryDirectory();
      // var path = '${tempDir.path}/flutter_sound.acc';
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.acc';

      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        // await _soundRecorder!.stopRecorder();
        // sendFileMessage(File(path), MessageEnum.audio);
        await record.stop();
        print('stoppppppppppppppppp');
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await record.start(
          path: path,
          encoder: AudioEncoder.aacLc, // by default
          bitRate: 128000, // by default
          // sampleRate: 44100, // by default
        );
        print('startttttttt');
        // await _soundRecorder!.startRecorder(
        //   toFile: path,
        // );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
        );
  }

  void selectImageFromCam() async {
    // Navigator.pop(context);
    bool isCamera = true;
    File? image = await pickImageFromGallery(context, isCamera);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectImageFromGallery() async {
    Navigator.pop(context);
    bool isCamera = false;
    File? image = await pickImageFromGallery(context, isCamera);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    Navigator.pop(context);
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    hideEmojiContainer();
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
            context,
            gif.url,
            widget.recieverUserId,
          );
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyBoard() => focusNode.requestFocus();
  void hideKeyBoard() => focusNode.unfocus();

  void toggleEmojikeyboardContaier() {
    if (isShowEmojiContainer) {
      showKeyBoard();
      hideEmojiContainer();
    } else {
      hideKeyBoard();
      showEmojiContainer();
    }
  }

  void showKeyboardCloseEmji() {
    if (isShowEmojiContainer) {
      showKeyBoard();
      hideEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    // _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessaageReply = messageReply != null;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: SizedBox(
                        child: isShowMessaageReply
                            ? MessageReplyPreview()
                            : const SizedBox(),
                      ),
                    ),
                    // Container(
                    //   height: 60,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: TextFormField(
                        onTap: showKeyboardCloseEmji,
                        focusNode: focusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        minLines: 1,
                        controller: _messageController,
                        onChanged: (val) {
                          setState(() {
                            if (val.isNotEmpty) {
                              setState(() {
                                isShowSendButton = true;
                              });
                            } else {
                              setState(() {
                                isShowSendButton = false;
                              });
                            }
                          });
                        },
                        cursorColor: Color(0xFF128C7E),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: mobileChatBoxColor,
                          prefixIcon: IconButton(
                            onPressed: toggleEmojikeyboardContaier,
                            icon: isShowEmojiContainer
                                ? Icon(
                                    Icons.keyboard,
                                    color: Colors.grey,
                                  )
                                : Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.grey,
                                  ),
                          ),
                          suffixIcon: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isAttachClicked = true;
                                    });

                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 60,
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Container(
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: mobileChatBoxColor,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                // mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  74,
                                                                  14),
                                                          child: Icon(
                                                            Icons
                                                                .headset_rounded,
                                                            size: 30,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Text(
                                                        "Audio",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: selectVideo,
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  226,
                                                                  40,
                                                                  15),
                                                          child: Icon(
                                                            Icons.video_file,
                                                            size: 30,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Text(
                                                        "Video",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap:
                                                            selectImageFromGallery,
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  221,
                                                                  30,
                                                                  255),
                                                          child: Icon(
                                                            Icons.photo_library,
                                                            size: 30,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Text(
                                                        "Photo",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }, //selectImage,
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    record.stop();
                                  }, //selectImageFromCam, //selectImage(true),
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                          hintText: 'Message',
                          hintStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 2.0, left: 5),
                child:
                    (isShowSendButton && _messageController.text.trim() != '')
                        ? CircleAvatar(
                            backgroundColor: Color(0xFF128C7E),
                            radius: 24,
                            child: GestureDetector(
                              onTap: sendTextMessage,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor:
                                isRecording ? Colors.red : Color(0xFF128C7E),
                            radius: 24,
                            child: GestureDetector(
                                child: Icon(
                                  isRecording ? Icons.close : Icons.mic_rounded,
                                  color: Colors.white,
                                ),
                                onTap: sendTextMessage ////////////
                                ),
                          ),
              ),
            ],
          ),

          //

          isShowEmojiContainer
              ? Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.36,
                      child: EmojiPicker(
                        // textEditingController: _messageController,
                        onEmojiSelected: ((category, emoji) {
                          setState(() {
                            _messageController.text =
                                _messageController.text + emoji.emoji;
                          });

                          if (!isShowSendButton) {
                            setState(() {
                              isShowSendButton = true;
                            });
                          }
                        }),
                        config: Config(
                          columns: 8,
                          bgColor: backgroundColor,
                          iconColorSelected: tabColor,
                          indicatorColor: tabColor,
                          emojiSizeMax: 28,
                          skinToneDialogBgColor: Colors.white,
                          enableSkinTones: true,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          selectGIF();
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.gif,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: mobileChatBoxColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
