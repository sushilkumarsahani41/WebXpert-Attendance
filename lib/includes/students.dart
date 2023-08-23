import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  String _prn = '';
  TextEditingController _searchController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
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
                          "Students",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          width: 350,
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
                            controller: _searchController,
                          ),
                        ),
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
                        const Expanded(
                          flex: 1,
                          child: Text("Department"),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text("Last Attendance"),
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
                      stream: db.collection('students').snapshots(),
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
                                          vertical: 10, horizontal: 20),
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
                                                    .data()['Department']
                                                    .toString()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(toDatefromTime(
                                                    snapshot.data!.docs[index]
                                                            .data()[
                                                        'last_attendance'])),
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
                                          vertical: 10, horizontal: 20),
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
                                                    .data()['Department']
                                                    .toString()),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(toDatefromTime(
                                                    snapshot.data!.docs[index]
                                                            .data()[
                                                        'last_attendance'])),
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
                                  return Container();
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
