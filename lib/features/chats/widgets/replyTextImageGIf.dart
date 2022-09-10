// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:wpclonemn/features/chats/widgets/video_player_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wpclonemn/common/enums/message_enum.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:wpclonemn/colors.dart';

class ReplyTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const ReplyTextImageGIF({
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
            maxLines: 4,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.grey,
              fontSize: 14,
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
                ? Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.videocam,
                              color: Colors.grey,
                            ),
                            Text(
                              ' Video',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 50,
                            minWidth: 50,
                            maxHeight: 50,
                            maxWidth: 50,
                          ),
                          child: VideoPlayerItem(
                            videoURL: message,
                            isPreview: true,
                          ),
                        ),
                      ),
                    ],
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
                          minHeight: 50,
                          minWidth: 50,
                          maxHeight: 50,
                          maxWidth: 50,
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
