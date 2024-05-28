import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class PlayVideoFromBilibili extends StatefulWidget {
  const PlayVideoFromBilibili({Key? key}) : super(key: key);

  @override
  State<PlayVideoFromBilibili> createState() => _PlayVideoFromVimeoIdState();
}

class _PlayVideoFromVimeoIdState extends State<PlayVideoFromBilibili> {
  late final PodPlayerController controller;
  final videoTextFieldCtr = TextEditingController();
  @override
  void initState() {
//https://bilibili.com/video/BV1B8411F7Dg
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.bilibili('BV19U411d7pQ'),
      podPlayerConfig: const PodPlayerConfig(
        videoQualityPriority: [360],
        autoPlay: true,
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bilibili player')),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              PodVideoPlayer(
                rootCtx: context,
                onTogglePlayPause: (state) async {
                  print('=== ${state}');
                },
                onToggleFullScreen: (s) async {

                },
                controller: controller,
                videoThumbnail: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dW5zcGxhc2h8ZW58MHx8MHx8&w=1000&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),
              _loadVideoFromUrl()
            ],
          ),
        ),
      ),
    );
  }

  Row _loadVideoFromUrl() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: videoTextFieldCtr,
            decoration: const InputDecoration(
              labelText: 'Enter Bilibili url/id',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'https://youtu.be/A3ltMaM6noM',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        FocusScope(
          canRequestFocus: false,
          child: ElevatedButton(
            onPressed: () async {
              if (videoTextFieldCtr.text.isEmpty) {
                snackBar('Please enter the url');
                return;
              }
              try {
                snackBar('Loading....');
                FocusScope.of(context).unfocus();
                await controller.changeVideo(
                  playVideoFrom: PlayVideoFrom.bilibili(videoTextFieldCtr.text),
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              } catch (e) {
                snackBar('Unable to load,\n $e');
              }
            },
            child: const Text('Load Video'),
          ),
        ),
      ],
    );
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
  }
}
