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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      stream: db.collection('Devices').snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Container(
                                child: Center(
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Lottie.asset("lottie/loading.json"),
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
                                                    onPressed: () {},
                                                    icon: Icon(Icons.settings)),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons
                                                        .sim_card_download)),
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
                                },
                              );
                      }),
                )
              ]),
        ),
      ),
    );
  }
}
