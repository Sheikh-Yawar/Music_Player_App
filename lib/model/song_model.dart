import 'package:flutter/material.dart';

class MySongModel {
  late bool isSelected;
  late bool isPlaying;
  late final String title;
  late final String location;
  late final String? artist;
  late final int duration;
  late final Image image;
  late bool isLiked;

  MySongModel(
    this.title,
    this.location,
    this.artist,
    this.duration,
    this.image,
    this.isPlaying,
    this.isLiked,
  );
}
