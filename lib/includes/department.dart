import 'package:attendance_front/constants.dart';
import 'package:attendance_front/includes/service.dart';
import 'package:attendance_front/includes/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController addSub = TextEditingController();
  final TextEditingController depName = TextEditingController();
  final TextEditingController delDep = TextEditingController();
  void getDepartments() {}

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
                    child: const Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Text(
                        "Departments",
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
                            child: Text("Department Name"),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text("No of Students"),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text("No of Devices"),
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
                        stream: db.collection('departments').snapshots(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Container(
                                  child: Center(
                                    child: SizedBox(
                                      height: 200,
                                      width: 200,
                                      child:
                                          Lottie.asset("lottie/loading.json"),
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
                                                        .data!.docs[index].id
                                                        .toString())
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text("No of Students"),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text("No of Devices"),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        edit_Department(snapshot
                                                            .data!
                                                            .docs[index]
                                                            .id
                                                            .toString());
                                                      },
                                                      icon: Icon(Icons.edit)),
                                                  IconButton(
                                                      onPressed: () {
                                                        delDepartment(snapshot
                                                            .data!
                                                            .docs[index]
                                                            .id
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
                Icons.domain_add,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Add Department",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              )
            ],
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    content: Container(
                      width: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Create New Department",
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
                              controller: depName,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 3),
                                  border: InputBorder.none,
                                  hintText: "Enter Department Name"),
                            ),
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
                                      borderRadius: BorderRadius.circular(30)),
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
                                  if (depName.text.isNotEmpty) {
                                    bool res = await service()
                                        .createDepartment(depName.text);
                                    if (res) {
                                      Navigator.of(context).pop();
                                      showSnackbar().ShowSnakbar(context,
                                          "Department created successfully");
                                    } else {
                                      showSnackbar().ShowSnakbar(
                                          context, "ERROR creating department");
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
                                      "Create",
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
          },
        ));
  }

  Future getDepData(id) async {
    var data = await db.collection('departments').doc(id).get();
    var subjects = data.data();
    return subjects;
  }

  delDepartment(id) async {
    var data = await getDepData(id);
    var dep_name = data['name'];
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Are you sure you want to delete this department?",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Department Name : $dep_name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                          db.collection('departments').doc(id).delete();
                          Navigator.pop(context);
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
                              "Yes",
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
  }

  edit_Department(id) async {
    var data = await getDepData(id);
    var dep_name = data['name'];
    var sub = data['subjects'] ?? [];
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: Colors.white,
                content: SizedBox(
                    width: 450,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Maihn Department Name
                        Text(
                          dep_name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Subject Input Box
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(spreadRadius: .2, blurRadius: 2)
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextField(
                                    controller: addSub,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Add Subject",
                                    ),
                                  ),
                                ),
                              ),

                              // Add Button
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    if (addSub.text.isNotEmpty) {
                                      sub.add(addSub.text);
                                      data = {'subjects': sub};
                                    }
                                  });
                                  service().updateDep(data, id);
                                  addSub.clear();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Center(
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        (sub.length == 0)
                            ? Container(
                                child: const Center(
                                  child: Text("No Subjects Found"),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: sub.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey, width: 1),
                                          ),
                                          
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(sub[index]),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    sub.removeAt(index);
                                                    data = {'subjects': sub};
                                                  });
                                                  service().updateDep(data, id);
                                                },
                                                icon: const Icon(Icons.delete))
                                          ],
                                        )),
                                  );
                                },
                              )
                      ],
                    )));
          });
        });
  }
}
