import 'dart:ui';

import 'package:flutter/material.dart';

final _borderRadius = BorderRadius.circular(20);

class GlassBox extends StatelessWidget {
  final height;
  final width;
  final child;
  GlassBox({
    Key? key,
    @required this.height,
    @required this.width,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _borderRadius,
      child: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            //blur effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5, //horizontal blur
                sigmaY: 5, //vertical blur
              ),
              child: Container(),
            ),
            //gradient effect
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                  borderRadius: _borderRadius,
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1),
                      ])),
            ),
            //child
            Center(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
