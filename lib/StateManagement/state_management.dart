import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/model/song_model.dart';

class SongStateNotifier extends StateNotifier<List<MySongModel>> {
  SongStateNotifier() : super([]);

  void addSong(MySongModel song) {
    state = [...state, song];
  }

  void clearState() {
    state = [];
    state = [...state];
  }

  void playPause(int index) {
    if (!state[index].isPlaying) {
      state[index].isPlaying = true;
    } else {
      state[index].isPlaying = false;
    }

    state = [...state];
  }

  void likeSong(int index) {
    state[index].isLiked = !state[index].isLiked;

    state = [...state];
  }

  void deleteSong(int index) {
    state.removeAt(index);
    state = [...state];
  }

  void resetplayPause() {
    for (final song in state) {
      song.isPlaying = false;
    }
  }
}

class ProgressBarStatus extends ChangeNotifier {
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;

  void getTotalDuration(AudioPlayer player) {
    player.durationStream.listen((value) {
      totalDuration = value ?? Duration.zero;
    });
    notifyListeners();
  }

  void getCurrentDuration(AudioPlayer player) {
    player.positionStream.listen((value) {
      currentDuration = value;
      notifyListeners();
    });
  }
}

class StateManagement {
  static final songListProvider =
      StateNotifierProvider<SongStateNotifier, List<MySongModel>>((ref) {
    return SongStateNotifier();
  });
  static final progressBarStatusprovider =
      ChangeNotifierProvider<ProgressBarStatus>((ref) {
    return ProgressBarStatus();
  });

  static final indexProvider = StateProvider<int>((ref) {
    return 0;
  });
}
