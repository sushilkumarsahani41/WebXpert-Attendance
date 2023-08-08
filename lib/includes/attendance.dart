import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _prn = '';
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamQuery;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  var selDepartment = 'Department';
  var selDepartmentId = 'Department';
  var selSubject = 'Subject';
  var DepMap = {
    'Department': 'Department',
  };
  var Deplist = [
    'Department',
  ];
  var SubMap = [
    "Subject",
  ];
  var selDate = 'Date';

  get_Deplist() async {
    var da = await db.collection('departments').get();
    var doc = da.docs;
    if (doc.length == 0) {
      return [];
    }
    setState(() {
      for (int i = 0; i < doc.length; i++) {
        Deplist.add(doc[i].data()['name']);
        DepMap[doc[i].data()['name']] = doc[i].id.toString();
      }
    });
  }

  get_Sublist(id) async {
    var da = await db.collection('departments').doc(id).get();
    var doc = da.data()!;
    var data = doc['subjects'] ?? [];
    var res = ["Subject"];
    if (data.length == 0) {
      setState(() {
        SubMap = res;
      });
    } else {
      setState(() {
        for (int i = 0; i < data.length; i++) {
          res.add(data[i]);
        }
        SubMap = res;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateController.text = "Date";
    get_Deplist();
  }

  @override
  Widget build(BuildContext context) {
    if (selDepartmentId == 'Department' &&
        selSubject == 'Subject' &&
        selDate == 'Date') {
      setState(() {
        streamQuery = db.collection('records').snapshots();
      });
    } else if (selSubject == 'Subject' && selDate == 'Date') {
      setState(() {
        streamQuery = db
            .collection('records')
            .where('dep_id', isEqualTo: selDepartmentId)
            .snapshots();
      });
    } else if (selDepartmentId == 'Department' && selSubject == 'Subject') {
      setState(() {
        streamQuery = db
            .collection('records')
            .where('date', isEqualTo: selDate)
            .snapshots();
      });
    } else if (selSubject == 'Subject') {
      setState(() {
        streamQuery = db
            .collection('records')
            .where('dep_id', isEqualTo: selDepartmentId)
            .where('date', isEqualTo: selDate)
            .snapshots();
      });
    } else if (selDate == 'Date') {
      setState(() {
        streamQuery = db
            .collection('records')
            .where('dep_id', isEqualTo: selDepartmentId)
            .where('subject', isEqualTo: selSubject)
            .snapshots();
      });
    } else {
      setState(() {
        streamQuery = db
            .collection('records')
            .where('dep_id', isEqualTo: selDepartmentId)
            .where('subject', isEqualTo: selSubject)
            .where('date', isEqualTo: selDate)
            .snapshots();
      });
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Attendance Records",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          width: 450,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 0.5,
                                  color: Colors.grey,
                                )
                              ],
                              color: kBgDarkColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextField(
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  _prn = _searchController.text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search by PRN",
                                suffixIconConstraints: const BoxConstraints(
                                  // minWidth: 2,
                                  minHeight: 2,
                                ),
                                suffixIcon: InkWell(
                                    onTap: () {},
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.search,
                                        size: 20,
                                      ),
                                    )),
                                contentPadding:
                                    const EdgeInsets.only(left: 20, right: 30),
                                border: InputBorder.none,
                              ),
                              controller: _searchController),
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      "Export Records",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Icon(Icons.upgrade, color: Colors.white)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text("Student Name"),
                        ),
                        Expanded(
                          flex: 1,
                          child: DropdownButton(
                              underline: SizedBox(),
                              value: selDepartment,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              items: Deplist.map(
                                  (item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        textAlign: TextAlign.center,
                                      ))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selDate = "Date";
                                  _dateController.text = "Date";
                                  selDepartmentId = DepMap[value].toString();
                                  print(DepMap[value].toString());
                                  selDepartment = value!;
                                  selSubject = "Subject";
                                  if (selDepartmentId != "Department") {
                                    get_Sublist(selDepartmentId);
                                    selSubject = "Subject";
                                  }
                                });
                              }),
                        ),
                        Expanded(
                          flex: 1,
                          child: DropdownButton(
                              underline: SizedBox(),
                              value: selSubject,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              items:
                                  SubMap.map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        textAlign: TextAlign.center,
                                      ))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selDate = "Date";
                                  _dateController.text = "Date";
                                  selSubject = value!;
                                });
                              }),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _prn = _searchController.text;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Date in M/D/Y",
                              prefixIconConstraints: const BoxConstraints(
                                // minWidth: 2,
                                minHeight: 2,
                              ),
                              prefixIcon: InkWell(
                                  onTap: () async {
                                    var pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime.now(), //get today's date
                                        firstDate: DateTime(
                                            2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101));
                                    if (pickedDate != null) {
                                      String formattedDate =
                                          "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                                      setState(() {
                                        _dateController.text = formattedDate;
                                        selDate = formattedDate;
                                      });
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                    
                                  )),
                              contentPadding:
                                  const EdgeInsets.only(left: 20, right: 30),
                              border: InputBorder.none,
                            ),
                            controller: _dateController,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                hoverColor: Colors.transparent,
                                onPressed: () {},
                                icon: const Icon(Icons.edit)),
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
                      stream: streamQuery,
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
                                  if (_prn.isEmpty) {
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
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          .data()["name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(snapshot
                                                        .data!.docs[index]
                                                        .data()['PRN']
                                                        .toString())
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()['department']
                                                    .toString()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()['subject']),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()['date']),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.edit)),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.delete))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.data!.docs[index]
                                      .data()['PRN']
                                      .toString()
                                      .startsWith(_prn)) {
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
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          .data()["name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(snapshot
                                                        .data!.docs[index]
                                                        .data()['PRN']
                                                        .toString())
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()['department']
                                                    .toString()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()['subject']),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(snapshot
                                                    .data!.docs[index]
                                                    .data()['date']),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.edit)),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.delete))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    child: Center(
                                      child: Text("Student not found...!"),
                                    ),
                                  );
                                },
                              );
                      }),
                )
              ]),
        ),
      ),
    );
  }

  toDatefromTime(data) {
    Timestamp timestampFromFirestore = data;
    DateTime dateTime = timestampFromFirestore.toDate();
    String formattedDate = "${dateTime.month}/${dateTime.day}/${dateTime.year}";
    return formattedDate;
  }
}
