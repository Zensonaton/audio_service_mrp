import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

late MyAudioHandler _audioHandler;

Future<void> main() async {
  _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: "com.flutter.myapp.audio",
      androidNotificationChannelName: "Audio playback",
      androidNotificationOngoing: true,
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () {
              setState(() => isPlaying = !isPlaying);

              _audioHandler.mediaItem.add(
                const MediaItem(
                  id: "uniqueid",
                  title: "Test audio",
                  album: "Test album",
                  artist: "Test artist",
                ),
              );

              _audioHandler.playbackState.add(
                PlaybackState(
                  controls: [
                    MediaControl.rewind,
                    if (isPlaying) MediaControl.pause else MediaControl.play,
                    MediaControl.stop,
                    MediaControl.fastForward,
                  ],
                  playing: isPlaying,
                ),
              );
            },
            child: Text(
              "Currently playing: $isPlaying",
            ),
          ),
        ),
      ),
    );
  }
}

class MyAudioHandler extends BaseAudioHandler {
  MyAudioHandler();

  @override
  Future<void> play() async => print("play");

  @override
  Future<void> pause() async => print("pause");

  @override
  Future<void> seek(Duration position) async => print("seek");

  @override
  Future<void> stop() async => print("stop");
}
