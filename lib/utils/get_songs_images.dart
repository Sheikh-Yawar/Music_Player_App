import 'dart:typed_data';
import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsImages {
  List<SongModel> songs = [];
  List<Image> images = [];
}

Future<SongsImages> getSongsImages() async {
  List<SongModel> songs = [];
  List<Image> images = [];
  SongsImages dummySongsImages = SongsImages();
  final tagger = Audiotagger();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  songs = await _audioQuery.querySongs(
    sortType: SongSortType.DATE_ADDED,
    orderType: OrderType.DESC_OR_GREATER,
  );
  dummySongsImages.songs = songs;

  for (int i = 0; i < songs.length; i++) {
    final Uint8List? bytes = await tagger.readArtwork(path: songs[i].data);
    if (bytes != null) {
      images.add(
        Image.memory(
          bytes,
          fit: BoxFit.cover,
        ),
      );
    } else {
      images.add(Image.asset(
        "assets/icons/app_icon.png",
        fit: BoxFit.cover,
      ));
    }
  }
  dummySongsImages.images = images;
  return dummySongsImages;
}
