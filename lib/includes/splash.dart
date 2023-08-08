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
              Lottie.network(
                  "https://lottie.host/d0a5bcab-192a-408e-b19f-9b5030026c46/wsDd0hyg0j.json",
                  repeat: false),
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
                  child: LottieBuilder.network('https://lottie.host/40b48fb5-6b33-42c9-84c2-db0d24a24ebe/P94JjyhGOK.json'))
            ],
          ),
        ),
      ),
    );
  }
}
