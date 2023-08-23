import 'package:attendance_front/constants.dart';
import 'package:attendance_front/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAgClMH_Cl8YpuC3NBKuuKY3MKFNCEc5Yo",
          authDomain: "webxpertattendance.firebaseapp.com",
          projectId: "webxpertattendance",
          storageBucket: "webxpertattendance.appspot.com",
          messagingSenderId: "800454109581",
          appId: "1:800454109581:web:e844df27d4645536cd75c4",
          measurementId: "G-SMWWNYBM5M"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebXpert Attendance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: genRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
