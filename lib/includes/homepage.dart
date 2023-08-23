import 'package:attendance_front/constants.dart';
import 'package:attendance_front/includes/attendance.dart';
import 'package:attendance_front/includes/dashboard.dart';
import 'package:attendance_front/includes/department.dart';
import 'package:attendance_front/includes/device.dart';
import 'package:attendance_front/includes/enrollment.dart';
import 'package:attendance_front/includes/on_hover.dart';
import 'package:attendance_front/includes/service.dart';
import 'package:attendance_front/includes/students.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userName = '';
  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _uid = prefs.getString('uid');
    print(_uid);
    db = FirebaseFirestore.instance;
    db.collection('admins').doc(_uid).get().then((doc) {
      var data = doc.data();
      setState(() {
        userName = data!['Name'];
      });
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  var pages = const [
    DashboardPage(),
    DevicePage(),
    DepartmentPage(),
    EnrollmentPage(),
    StudentsPage(),
    AttendancePage(),
  ];
  int selected_index = 1;
  List<String> menu = [
    "Dashboard",
    "Devices",
    "Department",
    "Enrollment",
    "Students",
    "Attendance",
    "Logout"
  ];
  List<IconData> menu_icon = [
    Icons.dashboard,
    Icons.fingerprint,
    Icons.domain,
    Icons.person_add,
    Icons.groups,
    Icons.contact_page,
    Icons.logout
  ];

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  color: kBgDarkColor,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      const Text(
                        "WebXpert",
                        style: TextStyle(
                          fontSize: 22,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Attendance",
                        style: TextStyle(
                          fontSize: 22,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: menu.length,
                            itemBuilder: (context, index) {
                              return OnHover(builder: (ishoverd) {
                                return InkWell(
                                  onTap: () async {
                                    if (index == 6) {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.clear();
                                      // ignore: use_build_context_synchronously
                                      Navigator.popAndPushNamed(context, '/');
                                    } else {
                                      setState(() {
                                        selected_index = index;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Container(
                                        decoration: (selected_index == index)
                                            ? BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: const [
                                                    BoxShadow(
                                                        blurRadius: 40,
                                                        spreadRadius: 0.5,
                                                        color: Colors.grey)
                                                  ])
                                            : BoxDecoration(),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                menu_icon[index],
                                                size: 30,
                                                color: (selected_index == index)
                                                    ? Colors.white
                                                    : ishoverd
                                                        ? kPrimaryColor
                                                        : Colors.black,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                menu[index],
                                                style: TextStyle(
                                                  color:
                                                      (selected_index == index)
                                                          ? Colors.white
                                                          : ishoverd
                                                              ? kPrimaryColor
                                                              : Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                );
                              });
                            }),
                      ),
                    ],
                  )),
            ),
            Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Hello, $userName",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 9,
                      child: pages[selected_index],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
