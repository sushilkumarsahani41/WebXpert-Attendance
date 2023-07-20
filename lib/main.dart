import 'package:attendance_front/constants.dart';
import 'package:attendance_front/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD5icl6uLoCHsB3XAbaIhlIhev16h4BCxQ",
          authDomain: "attendance-d7352.firebaseapp.com",
          projectId: "attendance-d7352",
          storageBucket: "attendance-d7352.appspot.com",
          messagingSenderId: "873573586803",
          appId: "1:873573586803:web:edb79c8528a517b56ed706",
          measurementId: "G-DKE7KWLQQ1"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
      ),
      initialRoute: 'home',
      onGenerateRoute: genRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
