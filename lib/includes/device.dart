// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:async';

import 'package:attendance_front/includes/service.dart';
import 'package:attendance_front/includes/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  String? selDep = 'Select';
  var selDepID = '';
  var DepMap = {};
  bool editNameClicked = false;
  bool editWifiClicked = false;
  bool editPassClicked = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController devNameController = TextEditingController();
  TextEditingController wSSID = TextEditingController();
  TextEditingController wPass = TextEditingController();

  // ignore: non_constant_identifier_names
  Future<List> get_Deplist() async {
    var da = await db.collection('departments').get();
    var doc = da.docs;
    var res = ['Select'];
    if (doc.length == 0) {
      return [];
    }
    for (int i = 0; i < doc.length; i++) {
      print(doc[i].data()['name']);
      res.add(doc[i].data()['name']);
      print(doc[i].id.toString());
      DepMap[doc[i].data()['name']] = doc[i].id.toString();
    }
    return res;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 15), (timer) {
      setState(() {});
    });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Devices",
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
                    width: double.maxFinite,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text("Device Name"),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text("Department"),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text("Mode"),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text("Remaining Capacity"),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  hoverColor: Colors.transparent,
                                  onPressed: () {},
                                  icon: const Icon(Icons.settings)),
                              IconButton(
                                  hoverColor: Colors.transparent,
                                  onPressed: () {},
                                  icon: const Icon(Icons.sim_card_download)),
                              IconButton(
                                  hoverColor: Colors.transparent,
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: db.collection('devices').snapshots(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Container(
                                  child: Center(
                                    child: SizedBox(
                                      height: 200,
                                      width: 200,
                                      child: Lottie.network(
                                          "https://lottie.host/40b48fb5-6b33-42c9-84c2-db0d24a24ebe/P94JjyhGOK.json"),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Container(
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                            color: kBgLightColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                spreadRadius: 0.2,
                                                blurRadius: 5,
                                                color: Colors.grey,
                                              )
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            snapshot.data!
                                                                .docs[index]
                                                                .data()["name"]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18)),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        (DateTime.now()
                                                                    .difference(timeStamptoDateTime(snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()["lastSeen"]))
                                                                    .inSeconds <=
                                                                60)
                                                            ? Icon(
                                                                Icons
                                                                    .fiber_manual_record,
                                                                color: Colors
                                                                    .green,
                                                                size: 15,
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                    Text(snapshot
                                                        .data!.docs[index].id
                                                        .toString())
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()["Department"]
                                                    .toString()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()["Mode"]
                                                    .toString()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()["rem_cap"]
                                                    .toString()),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        deviceSetting(snapshot
                                                            .data!
                                                            .docs[index]
                                                            .id
                                                            .toString());
                                                      },
                                                      icon:
                                                          Icon(Icons.settings)),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {});
                                                      },
                                                      icon: Icon(Icons
                                                          .sim_card_download)),
                                                  IconButton(
                                                      onPressed: () {
                                                        delDevice(snapshot.data!
                                                            .docs[index].id
                                                            .toString());
                                                      },
                                                      icon: Icon(Icons.delete))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        }),
                  )
                ]),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          hoverElevation: 2,
          backgroundColor: kPrimaryColor,
          label: const Row(
            children: [
              Icon(
                Icons.library_add,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Add Device",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              )
            ],
          ),
          onPressed: () async {
            var SelList = await get_Deplist();
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      content: Container(
                        width: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Add New Device",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 2,
                                      spreadRadius: 0.2,
                                      color: Colors.grey,
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextField(
                                controller: devNameController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 3),
                                    border: InputBorder.none,
                                    hintText: "Enter Device Name"),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Select Department: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 2,
                                        spreadRadius: 0.2,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: DropdownButton(
                                        underline: SizedBox(),
                                        value: selDep,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        items: SelList.map(
                                            (item) => DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  textAlign: TextAlign.center,
                                                ))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selDepID = DepMap[value].toString();
                                            print(DepMap[value].toString());
                                            selDep = value;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 5,
                                            spreadRadius: 0.2,
                                            color: Colors.grey,
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Center(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (devNameController.text.isNotEmpty) {
                                      print(selDepID);
                                      var data = {
                                        'name': devNameController.text,
                                        'Department': selDep,
                                        'departmentID': selDepID,
                                        'Mode': 'Enrollment',
                                        'lastSeen': Timestamp.now(),
                                        'rem_cap': 1000,
                                      };
                                      bool res =
                                          await service().createDevice(data);
                                      if (res) {
                                        Navigator.of(context).pop();
                                        showSnackbar().ShowSnakbar(context,
                                            "Department created successfully");
                                      } else {
                                        showSnackbar().ShowSnakbar(context,
                                            "ERROR creating department");
                                      }
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
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Center(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      child: Text(
                                        "Add New",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
                });
          },
        ));
  }

  deviceSetting(id) async {
    var res = await db.collection('devices').doc(id).get();
    var data = res.data()!;
    wSSID.text = data['ssid'] ?? ''; //Wifi Ssid
    wPass.text = data['wpassword'] ?? ''; // Wifi Password
    devNameController.text = data['name'] ?? '';
    var mode = data['Mode'] ?? '';
    print(mode);
    var depName = data['Department'] ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Container(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (editNameClicked
                        ? Container(
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(spreadRadius: .2, blurRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: devNameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                devNameController.text,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        editNameClicked = true;
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.edit))
                            ],
                          )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Department : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(depName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Wifi Name : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(spreadRadius: .2, blurRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: wSSID,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Wifi Password : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(spreadRadius: .2, blurRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: wPass,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mode : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(spreadRadius: .2, blurRadius: 2)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                (index == 0)
                                    ? mode = 'Enrollment'
                                    : mode = 'Attendance';
                                print(mode);
                                // The button that is tapped is set to true, and the others to false.
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            selectedBorderColor: kPrimaryColor,
                            selectedColor: Colors.white,
                            fillColor: kPrimaryColor,
                            color: kPrimaryColor,
                            isSelected: (mode == 'Enrollment')
                                ? [true, false]
                                : [false, true],
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 3),
                                child: Text(
                                  "Enrollment",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: Text(
                                  "Attendance",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 0.2,
                                    color: Colors.grey,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (editNameClicked) {
                              var dt = {
                                'Mode': mode,
                                'name': devNameController.text,
                                'ssid': wSSID.text,
                                'wpassword': wPass.text,
                              };
                              var res = await service().updateDevice(id, dt);
                              if (res) {
                                showSnackbar()
                                    .ShowSnakbar(context, "Saved successfully");
                                Navigator.pop(context);
                              } else {
                                showSnackbar().ShowSnakbar(
                                    context, "Something went wrong");
                              }
                            } else {
                              var dt = {
                                'Mode': mode,
                                'ssid': wSSID.text,
                                'wpassword': wPass.text,
                              };
                              var res = await service().updateDevice(id, dt);
                              if (res) {
                                showSnackbar()
                                    .ShowSnakbar(context, "Saved successfully");
                                Navigator.pop(context);
                              } else {
                                showSnackbar().ShowSnakbar(
                                    context, "Something went wrong");
                              }
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
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              child: Text(
                                " Save ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  timeStamptoDateTime(t) {
    Timestamp s = t;
    print(DateTime.now().difference(s.toDate()).inSeconds);

    return s.toDate();
  }

  void delDevice(String id) async {
    var data = await db.collection('devices').doc(id).get();
    var dt = data.data()!;
    var depID = dt['departmentID'];
    print(depID);
    var devNo = await db.collection('departments').doc(depID).get();
    var TRemNo = devNo.data()!['no_devices'];
    var DeviceNo = TRemNo - 1;
    print(DeviceNo);
    await db
        .collection('departments')
        .doc(depID)
        .update({'no_devices': DeviceNo});
    db.collection('enrollment').doc(id).delete();
    db.collection('devices').doc(id).delete();
  }
}
