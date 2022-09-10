import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoURL;
  final isPreview;
  const VideoPlayerItem({
    Key? key,
    required this.videoURL,
    required this.isPreview,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    videoPlayerController = CachedVideoPlayerController.network(widget.videoURL)
      ..initialize().then((value) => {
            videoPlayerController.setVolume(1)
            //  setState(() {});
            // videoPlayerController.play() ,
          });
    super.initState();
  }

  @override
  void deactivate() {
    videoPlayerController.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: isPlay ? videoPlayerController.value.aspectRatio : 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          widget.isPreview
              ? SizedBox()
              : Center(
                  child: IconButton(
                    onPressed: () {
                      if (isPlay) {
                        setState(() {
                          videoPlayerController.pause();
                          isPlay = false;
                        });
                      } else {
                        setState(() {
                          videoPlayerController.play();
                          isPlay = true;
                        });
                      }
                    },
                    icon: isPlay
                        ? Icon(
                            Icons.pause_circle,
                            size: 50,
                          )
                        : Icon(
                            Icons.play_circle,
                            size: 50,
                          ),
                  ),
                )
        ],
      ),
    );
  }
}
