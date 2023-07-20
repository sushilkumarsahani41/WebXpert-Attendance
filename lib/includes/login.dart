import 'package:attendance_front/constants.dart';
import 'package:attendance_front/includes/on_hover.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _obsecureText = true;
  bool _loginClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Lottie.asset("lottie/login.json"),
              Container(
                width: 400,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 3,
                      color: Colors.grey.shade300,
                    )
                  ],
                ),
                child: _loginClicked
                    ? Center(
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Lottie.asset('lottie/loading.json')))
                    : Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Panel Login ",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: kBgDarkColor,
                              ),
                              child: TextField(
                                controller: _username,
                                decoration: const InputDecoration(
                                  hintText: "username",
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: kBgDarkColor,
                              ),
                              child: TextField(
                                onSubmitted: (sample) {
                                  _loginFunc();
                                },
                                decoration: InputDecoration(
                                  hintText: "password",
                                  suffixIconConstraints: const BoxConstraints(
                                    // minWidth: 2,
                                    minHeight: 2,
                                  ),
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _obsecureText = !_obsecureText;
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          _obsecureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 20,
                                        ),
                                      )),
                                  contentPadding: const EdgeInsets.only(
                                      left: 20, right: 30),
                                  border: InputBorder.none,
                                ),
                                obscureText: _obsecureText,
                                controller: _password,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text("Having trouble in signing? "),
                                OnHover(
                                  builder: (isHover) {
                                    return Text(
                                      "Forget Password",
                                      style: TextStyle(
                                          color: isHover
                                              ? kPrimaryColor
                                              : Colors.grey),
                                    );
                                  },
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            OnHover(builder: (isHover) {
                              return InkWell(
                                onTap: _loginFunc,
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _loginFunc() async {
    if (_username.text.isNotEmpty) {
      if (_password.text.isNotEmpty) {
        try {
          setState(() {
            _loginClicked = true;
          });
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _username.text, password: _password.text);
          final SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('uid', credential.user!.uid);
          if (credential.user!.uid.isNotEmpty) {
            Navigator.popAndPushNamed(context, "home");
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            _loginClicked = false;
          });
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      }
    }
  }
}
