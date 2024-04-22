import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class GetServiceVideoWidget extends StatefulWidget {
  final String youtubeVideoUrl;
  final String fileVideoUrl;
  const GetServiceVideoWidget({super.key, required this.youtubeVideoUrl, required this.fileVideoUrl});

  @override
  State<GetServiceVideoWidget> createState() => _GetServiceVideoWidgetState();
}

class _GetServiceVideoWidgetState extends State<GetServiceVideoWidget> {

  late YoutubePlayerController _controller;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {

    String url = widget.youtubeVideoUrl;
    if(url.isNotEmpty) {

      _controller = YoutubePlayerController(params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        loop: false,
        enableCaption: false, showVideoAnnotations: false, showFullscreenButton: false,
      ));

      _controller.loadVideo(url);

      String? convertedUrl = YoutubePlayerController.convertUrlToId(url);

      _controller = YoutubePlayerController.fromVideoId(
        videoId: convertedUrl!,
        autoPlay: false,
      );
    } else if(widget.fileVideoUrl.isNotEmpty){
      configureForMp4(widget.fileVideoUrl);
    }

    super.initState();
  }

  configureForMp4(String videoUrl) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _videoPlayerController.play();
    _videoPlayerController.setVolume(0);
    Future.delayed(const Duration(seconds: 2), () {
      _videoPlayerController.pause();
      _videoPlayerController.setVolume(1);
      setState(() {});
    });

  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.youtubeVideoUrl.isNotEmpty ? ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      child: YoutubePlayer(
        controller: _controller,
        backgroundColor: Colors.transparent,
      ),
    ) : Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: _videoPlayerController.value.isInitialized ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          ) : const SizedBox(),
        ),

        _videoPlayerController.value.isInitialized ? Positioned(
          bottom: 10, left: 20,
          child: InkWell(
            onTap: (){
              setState(() {
                _videoPlayerController.value.isPlaying
                    ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
              });
            },
            child: Icon(
              _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 34,
            ),
          ),
        ) : const SizedBox(),
      ],
    );
  }
}