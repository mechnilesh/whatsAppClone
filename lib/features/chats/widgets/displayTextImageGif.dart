// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wpclonemn/colors.dart';

import 'package:wpclonemn/common/enums/message_enum.dart';
import 'package:wpclonemn/features/chats/widgets/video_player_item.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    // print(message);
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: BoxConstraints(minWidth: 100, minHeight: 100),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(
                        UrlSource(message),
                      );
                      print('yesss');
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon:
                      Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                );
              })
            : type == MessageEnum.video
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: VideoPlayerItem(videoURL: message, isPreview: false),
                  )
                : type == MessageEnum.gif
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: CircularProgressIndicator(
                              color: tabColor,
                            ),
                          ),
                          imageUrl: message,
                        ),
                      )
                    : Container(
                        constraints: BoxConstraints(
                          minHeight: 100,
                          minWidth: 100,
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: CircularProgressIndicator(
                                color: tabColor,
                              ),
                            ),
                            imageUrl: message,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
  }
}
