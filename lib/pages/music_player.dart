import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:like_button/like_button.dart';
import 'package:marquee/marquee.dart';
import 'package:music_app/StateManagement/state_management.dart';
import 'package:music_app/model/song_model.dart';
import 'package:music_app/widgets/glass_morphism.dart';
import 'package:music_app/widgets/neumorphic_button.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  AudioPlayer player;
  int index;

  MusicPlayer({Key? key, required this.index, required this.player})
      : super(key: key);

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  late int index;
  late AudioPlayer _player;

  bool isPlaying = false;
  bool isLoopModePressed = false;

  @override
  void initState() {
    // TODO: implement initState
    index = widget.index;
    _player = widget.player;

    super.initState();
  }

  changeSong(
    List<MySongModel> songs,
    int i,
    SongStateNotifier stateNotifier,
    bool nextSong,
  ) async {
    if (nextSong) {
      index = i + 1;
      if (index >= songs.length) {
        index = 0;
      }
    } else {
      index = i - 1;
      if (index < 0) {
        index = songs.length - 1;
      }
    }

    await _player.setFilePath(songs[index].location);

    if (!songs[index].isPlaying) {
      stateNotifier.resetplayPause();
      stateNotifier.playPause(index);
      _player.play();
    } else {
      _player.pause();
      stateNotifier.playPause(index);
    }
    ref
        .read(StateManagement.progressBarStatusprovider.notifier)
        .getTotalDuration(_player);
    ref
        .read(StateManagement.progressBarStatusprovider.notifier)
        .getCurrentDuration(_player);
  }

  @override
  Widget build(BuildContext context) {
    List<MySongModel> songs = ref.watch(StateManagement.songListProvider);
    final SongStateNotifier stateNotifier =
        ref.watch(StateManagement.songListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Text("Now Playing"),
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(130),
                bottomLeft: Radius.circular(130),
              ),
              child: Material(
                elevation: 10,
                child: SizedBox(
                  height: 400,
                  width: 250,
                  child: songs[index].image,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              child: marqueeText(
                songs,
                index,
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(
                songs[index].artist ?? "<Unknown>",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff83909c),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: 30,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ProgressBar(
                    progressBarColor: const Color(0xffe16e03),
                    thumbColor: Colors.white,
                    thumbRadius: 15.0,
                    baseBarColor: const Color(0xff83909c),
                    timeLabelTextStyle: GoogleFonts.lora(
                      fontSize: 13,
                      color: const Color(0xff83909c),
                      fontWeight: FontWeight.w300,
                    ),
                    barHeight: 7,
                    timeLabelLocation: TimeLabelLocation.above,
                    progress: ref
                        .watch(StateManagement.progressBarStatusprovider)
                        .currentDuration,
                    total: ref
                        .watch(StateManagement.progressBarStatusprovider)
                        .totalDuration,
                    onSeek: (duration) {
                      _player.seek(duration);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                    top: 20,
                    bottom: 30,
                  ),
                  child: GlassBox(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: LikeButton(
                                onTap: (_) {
                                  stateNotifier.likeSong(index);
                                  return Future.delayed(
                                    const Duration(seconds: 0),
                                  );
                                },
                                size: 38,
                                isLiked: songs[index].isLiked,
                              ),
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      onPressed: () async {
                                        changeSong(
                                            songs, index, stateNotifier, false);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.backwardStep,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (!songs[index].isPlaying) {
                                      stateNotifier.resetplayPause();
                                      stateNotifier.playPause(index);
                                      _player.play();
                                    } else {
                                      _player.pause();
                                      stateNotifier.playPause(index);
                                    }
                                  },
                                  child: StreamBuilder<PlayerState>(
                                    stream: _player.playerStateStream,
                                    builder: (_, snapshot) {
                                      final playerState = snapshot.data;
                                      if (playerState?.processingState ==
                                          ProcessingState.completed) {
                                        changeSong(
                                          songs,
                                          index,
                                          stateNotifier,
                                          true,
                                        );
                                      }
                                      return neumorphicButton(
                                        songs[index].isPlaying,
                                        70.0,
                                        70.0,
                                        40,
                                      );
                                    },
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                        onPressed: () async {
                                          changeSong(
                                            songs,
                                            index,
                                            stateNotifier,
                                            true,
                                          );
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.forwardStep,
                                          color: Colors.white,
                                        )),
                                  ),
                                )
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Material(
                                color: Colors.transparent,
                                child: IconButton(
                                    onPressed: () {
                                      if (isLoopModePressed == true) {
                                        _player.setLoopMode(LoopMode.off);
                                      } else {
                                        _player.setLoopMode(LoopMode.one);
                                      }

                                      setState(() {
                                        isLoopModePressed = !isLoopModePressed;
                                      });
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.repeat,
                                      color: isLoopModePressed == true
                                          ? const Color(0xffe16e03)
                                          : Colors.white,
                                    )),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

bool _willTextOverflow(
    {required String text, required TextStyle style, required maxWidth}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: maxWidth);

  return textPainter.didExceedMaxLines;
}

Widget marqueeText(
  List<MySongModel> songs,
  int index,
) {
  TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
  return SizedBox(
    width: 270,
    height: 25,
    child: _willTextOverflow(
                text: songs[index].title, style: textStyle, maxWidth: 170.0) ==
            true
        ? Marquee(
            text: songs[index].title,
            style: textStyle,
            blankSpace: 80,
            velocity: 35.0,
          )
        : Text(
            songs[index].title,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
  );
}
