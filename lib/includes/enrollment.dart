import 'dart:js_interop';

import 'package:attendance_front/includes/department.dart';
import 'package:attendance_front/includes/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({super.key});

  @override
  State<EnrollmentPage> createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _name = TextEditingController();
  TextEditingController _prn = TextEditingController();
  TextEditingController _email = TextEditingController();
  bool saveclicked = false;
  bool fingerid = false;
  var enrollID = '';
  bool enrolling = false;
  var deviceMap = {};
  var selDevice = 'Select';
  var deviceList = [];

  enrollClicked(id) {
    db.collection('enrollment').doc(id).update({'enroll': true});
  }

  getenrollID(id) async {
    db.collection('enrollment').doc(id).snapshots().listen((snapshot) {
      if (snapshot.data() != null) {
        if (snapshot.data()!['enroll'] == false) {
          setState(() {
            enrollID = snapshot.data()!['last_enroll_id'];
            print(enrollID);
            enrolling = false;
            fingerid = true;
          });
        }
      }
    });
  }

  getOnlineDevices() async {
    var da = await db.collection('devices').get();
    var res = ['Select'];
    if (da.docs.length != 0) {
      for (int i = 0; i < da.docs.length; i++) {
        if (DateTime.now()
                .difference(timeStamptoDateTime(da.docs[i].data()["lastSeen"]))
                .inSeconds <=
            60) {
          res.add(da.docs[i].data()['name']);
          deviceMap[da.docs[i].data()['name']] = da.docs[i].id;
        }
      }
      setState(() {
        deviceList = res;
      });
    } else {
      setState(() {
        deviceList = res;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnlineDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                child: const Padding(
                  padding: EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: Text(
                    "Enrollment",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Select Device",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 200,
                          child: DropdownButton(
                              underline: SizedBox(),
                              value: selDevice,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              items: deviceList
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        textAlign: TextAlign.center,
                                      )))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selDevice = value!;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "PRN : ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 350,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              spreadRadius: .2, blurRadius: 2)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextField(
                                        controller: _prn,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Name : ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 350,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              spreadRadius: .2, blurRadius: 2)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextField(
                                        controller: _name,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Email : ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 350,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              spreadRadius: .2, blurRadius: 2)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextField(
                                        controller: _email,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: fingerid
                                ? Lottie.network(
                                    "https://lottie.host/1ef92dc7-75cc-46c7-b3a4-ac54368fe009/Yja1W40grQ.json",
                                    repeat: false)
                                : enrolling
                                    ? Center(
                                        child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: CircularProgressIndicator()),
                                      )
                                    : Lottie.network(
                                        "https://lottie.host/c83d2606-aa8f-419b-9e59-1d90d8f5808d/ed8gq7xUp1.json"),
                          ),
                          fingerid
                              ? SizedBox()
                              : enrolling
                                  ? Text("Enrolling....")
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (selDevice != "Select") {
                                          if (_prn.text.isNotEmpty) {
                                            if (_name.text.isNotEmpty) {
                                              if (_email.text.isNotEmpty) {
                                                enrollClicked(
                                                    deviceMap[selDevice]);
                                                setState(() {
                                                  enrolling = true;
                                                });
                                                Future.delayed(
                                                    Duration(seconds: 2),
                                                    () {});
                                                getenrollID(
                                                    deviceMap[selDevice]);
                                              } else {
                                                showSnackbar().ShowSnakbar(
                                                    context,
                                                    "Email Should noty be empty");
                                              }
                                            } else {
                                              showSnackbar().ShowSnakbar(
                                                  context,
                                                  "Name Should noty be empty");
                                            }
                                          } else {
                                            showSnackbar().ShowSnakbar(context,
                                                "PRN Should noty be empty");
                                          }
                                        } else {
                                          showSnackbar().ShowSnakbar(context,
                                              "Please select a device");
                                        }
                                      },
                                      child: Text(
                                        "Get Fingerprint",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ))
                        ],
                      )))
                ],
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 350,
                child: InkWell(
                  onTap: () async {
                    if (enrollID != '') {
                      setState(() {
                        saveclicked = true;
                      });
                      enrollStudent(deviceMap[selDevice]);
                    } else {
                      showSnackbar().ShowSnakbar(context,
                          "Fingerprint Doesn't Enrolled Please Refresh and retry");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 0.2,
                            color: Colors.grey,
                          )
                        ],
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: saveclicked
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Enroll Student",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  enrollStudent(id) async {
    db.collection('devices').doc(id).get().then((value) async {
      var depID = value.data()!['departmentID'];
      var dep = value.data()!['Department'];
      var data = {
        'name': _name.text,
        'PRN': _prn.text,
        'Department': dep,
        'DepartmentID': depID,
        "last_attendance": Timestamp.now()
      };
      db.collection('students').doc(enrollID).set(data);
      var depdt = await db.collection('departments').doc(depID).get();
      var no_students = depdt.data()!['no_students'] + 1;
      db
          .collection("departments")
          .doc(depID)
          .update({'no_students': no_students});
      var capdt = await db.collection('devices').doc(id).get();
      var cap = capdt.data()!['rem_cap'] - 1;
      db.collection('devices').doc(id).update({'rem_cap': cap});
      Future.delayed(Duration(seconds: 2));
      _email.text = '';
      _prn.text = '';
      _name.text = '';
      enrollID = '';
      fingerid = false;
      setState(() {
        saveclicked = false;
      });
      showSnackbar().ShowSnakbar(context, "Student Enroll Succeessfully");
    });
  }

  timeStamptoDateTime(t) {
    Timestamp s = t;
    print(DateTime.now().difference(s.toDate()).inSeconds);

    return s.toDate();
  }
}
