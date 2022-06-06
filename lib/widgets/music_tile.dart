import 'dart:io';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ringtone_set/ringtone_set.dart';
import 'package:music_app/pages/music_player.dart';
import 'package:music_app/utils/format_time.dart';
import 'package:music_app/widgets/neumorphic_button.dart';
import 'package:share_plus/share_plus.dart';

import '../StateManagement/state_management.dart';
import 'glass_morphism.dart';

Widget musicTile(
  final _player,
  BuildContext context,
  int index,
  final previousIndex,
  List songs,
  SongStateNotifier stateNotifier,
  final snackBar,
  WidgetRef ref,
) {
  return GlassBox(
    height: 90.0,
    width: (MediaQuery.of(context).size.width - 100).toDouble(),
    child: FittedBox(
      fit: BoxFit.contain,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: 50,
                width: 50,
                child: songs[index].image,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              if (previousIndex != index) {
                await _player.setFilePath(songs[index].location);
              }

              ref.read(StateManagement.indexProvider.state).state = index;

              if (!songs[index].isPlaying) {
                stateNotifier.resetplayPause();
                stateNotifier.playPause(index);
                _player.play();
              }
              ref
                  .read(StateManagement.progressBarStatusprovider.notifier)
                  .getTotalDuration(_player);
              ref
                  .read(StateManagement.progressBarStatusprovider.notifier)
                  .getCurrentDuration(_player);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MusicPlayer(
                    index: index,
                    player: _player,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songs[index].title,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        songs[index].artist.toString(),
                        style: const TextStyle(
                          color: Color(0xff83909c),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        FormatTime.formatDuration(
                          Duration(
                            milliseconds: songs[index].duration,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xff83909c),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (previousIndex != index) {
                    await _player.setFilePath(songs[index].location);
                  }

                  if (!songs[index].isPlaying) {
                    stateNotifier.resetplayPause();
                    stateNotifier.playPause(index);
                    _player.play();
                  } else {
                    _player.pause();
                    stateNotifier.playPause(index);
                  }
                  ref.read(StateManagement.indexProvider.state).state = index;
                },
                child: StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (_, snapshot) {
                    final playerState = snapshot.data;
                    if (playerState?.processingState ==
                        ProcessingState.completed) {
                      return neumorphicButton(
                        songs[index].isPlaying,
                        40.0,
                        40.0,
                        25,
                        isCompleted: true,
                      );
                    }
                    return neumorphicButton(
                      songs[index].isPlaying,
                      40.0,
                      40.0,
                      25,
                    );
                  },
                ),
              ),
              SizedBox(
                width: 30,
                child: PopupMenuButton(
                  elevation: 8,
                  color: const Color(0xff1d1449),
                  icon: const Icon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: Colors.white,
                    size: 29,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onSelected: (String value) {
                    deleteOrShareFile(
                      value,
                      index,
                      songs,
                      stateNotifier,
                      snackBar,
                      context,
                    );
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: "Share",
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Share",
                            style: GoogleFonts.lora(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "Delete",
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Delete",
                            style: GoogleFonts.lora(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: "Ringtone",
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Set Ringtone",
                            style: GoogleFonts.lora(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void deleteOrShareFile(
  String value,
  int index,
  List songs,
  SongStateNotifier stateNotifier,
  final snackBar,
  BuildContext context,
) {
  switch (value) {
    case "Delete":
      stateNotifier.deleteSong(index);
      break;
    case "Share":
      Share.shareFiles(
        [songs[index].location],
        text: songs[index].title,
      );

      break;

    case "Ringtone":
      final File ringtoneFile = File(songs[index].location);
      RingtoneSet.setRingtoneFromFile(ringtoneFile);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      break;
  }
}
