import 'dart:async';
import 'package:attendance_front/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final String _uid;
  void getUid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    _uid = pref.getString('uid') ?? "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
    Timer(const Duration(seconds: 5), () {
      if (_uid == '') {
        Navigator.popAndPushNamed(context, 'login');
      } else {
        Navigator.popAndPushNamed(context, 'home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                '/lottie/fingerprint.json',
                repeat: false,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'WebXpert Attendance',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 130,
                  child: LottieBuilder.asset('/lottie/loading.json'))
            ],
          ),
        ),
      ),
    );
  }
}
