import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/pages/error_page.dart';
import 'package:music_app/pages/music_list.dart';

import 'package:music_app/theme_data.dart';
import 'package:music_app/utils/get_songs_images.dart';
import 'package:page_transition/page_transition.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: MyTheme.themeData,
        home: const SplashScreen(),
      ),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timebefore = DateTime.now();
    return AnimatedSplashScreen.withScreenFunction(
        splash: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    "assets/images/splash_screen_icon.png",
                    fit: BoxFit.contain,
                  )),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Music Player",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        duration: 0, //Duration for which splash screen remains visible
        animationDuration: const Duration(
          seconds: 0,
        ),
        backgroundColor: const Color(0xff1d1449),
        pageTransitionType: PageTransitionType.topToBottom,
        screenFunction: () async {
          List<SongModel> songs = [];
          List<Image> images = [];
          final OnAudioQuery _audioQuery = OnAudioQuery();

          if (!kIsWeb) {
            bool permissionStatus = await _audioQuery.permissionsStatus();
            if (!permissionStatus) {
              permissionStatus = await _audioQuery.permissionsRequest();
            }
            if (!permissionStatus) {
              return const ErrorPage();
            }
          }

          final songsimages = await getSongsImages();
          songs = songsimages.songs;
          images = songsimages.images;

          print(DateTime.now().difference(timebefore).inSeconds);
          return MyApp(
            images: images,
            songs: songs,
          );
        });
  }
}

class MyApp extends StatelessWidget {
  List<Image> images = [];
  List<SongModel> songs = [];
  MyApp({Key? key, required this.images, required this.songs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MusicList(images: images, songs: songs);
  }
}
