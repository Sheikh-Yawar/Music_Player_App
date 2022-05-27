import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:music_app/main.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  navigate() async {
    final OnAudioQuery _audioQuery = OnAudioQuery();
    bool permissionStatus = await _audioQuery.permissionsStatus();

    if (permissionStatus) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 70.0,
      color: const Color(0xffe16e03),
      strokeWidth: 4.0,
      backgroundColor: const Color(0xff1d1449),
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          setState(() {});
          navigate();
        });
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "Please Provide Required Permission \n             and Refresh the App!",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 320.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      await AppSettings.openAppSettings();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.lock,
                          color: Color(0xff1d1449),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Grant",
                          style: TextStyle(
                            color: Color(0xff1d1449),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
