import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget neumorphicButton(
    bool isPlaying, double height, double width, double iconSize,
    {bool isCompleted = false}) {
  return SizedBox(
    height: height,
    width: width,
    child: Neumorphic(
      style: NeumorphicStyle(
        shape: isPlaying == true
            ? NeumorphicShape.concave
            : NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(60),
        ),
        depth: 10,
        shadowLightColor: isPlaying == true && isCompleted == false
            ? const Color(0xffe16e03)
            : const Color(0xffffffff).withOpacity(0.1),
        lightSource: LightSource.right,
        intensity: 0.50,
        color: isPlaying == true && isCompleted == false
            ? const Color(0xffe16e03)
            : const Color(0xffffffff).withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Icon(
          (isPlaying == true && isCompleted == false)
              ? FontAwesomeIcons.pause
              : FontAwesomeIcons.play,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    ),
  );
}
