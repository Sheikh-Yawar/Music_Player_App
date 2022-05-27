import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/StateManagement/state_management.dart';
import 'package:music_app/model/song_model.dart';
import 'package:music_app/pages/music_player.dart';

import 'package:music_app/widgets/music_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

import '../utils/get_songs_images.dart';

class MusicList extends ConsumerStatefulWidget {
  List<Image> images = [];
  List<SongModel> songs = [];
  MusicList({Key? key, required this.images, required this.songs})
      : super(key: key);

  @override
  ConsumerState<MusicList> createState() => _MusicListState();
}

class _MusicListState extends ConsumerState<MusicList> {
  int previousIndex = -1;
  List<Image> images = [];
  List<SongModel> dummySongs = [];
  late final _player;
  bool nextSongPressed = false;

  getSongs(List<SongModel> dummySongs) async {
    final SongStateNotifier songs =
        ref.watch(StateManagement.songListProvider.notifier);

    songs.clearState();

    for (int i = 0; i < dummySongs.length; i++) {
      songs.addSong(
        MySongModel(
          dummySongs[i].title,
          dummySongs[i].data,
          dummySongs[i].artist,
          dummySongs[i].duration!,
          images[i],
          false,
          false,
        ),
      );
    }
  }

  @override
  void initState() {
    dummySongs = widget.songs;
    images = widget.images;
    _player = AudioPlayer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getSongs(dummySongs);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _player.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MySongModel> songs = ref.watch(StateManagement.songListProvider);

    final SongStateNotifier stateNotifier =
        ref.watch(StateManagement.songListProvider.notifier);

    return RefreshIndicator(
      displacement: 70.0,
      color: const Color(0xffe16e03),
      strokeWidth: 4.0,
      backgroundColor: const Color(0xff1d1449),
      onRefresh: () async {
        final songsimages = await getSongsImages();
        _player.pause();
        dummySongs = [];
        dummySongs = songsimages.songs;
        images = [];
        images = songsimages.images;
        getSongs(dummySongs);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "All Songs",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: songs.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 10,
              ),
              child: musicTile(
                _player,
                context,
                index,
                songs,
                stateNotifier,
                ref,
              ),
            );
          },
        ),
      ),
    );
  }
}
