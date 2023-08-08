import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// ignore: camel_case_types
class service {
  Future<bool> createDepartment(name) async {
    db
        .collection('departments')
        .add({'name': name, 'no_devices': 0, 'no_students': 0}).then((value) {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  getDepartments() async {
    return await db.collection('departments').get();
  }

  updateDep(data, id) async {
    await db.collection('departments').doc(id).update(data).then((value) {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  Future<bool> createDevice(dt) async {
    var depID = dt['departmentID'];
    print(depID);
    var devNo = await db.collection('departments').doc(depID).get();
    var TRemNo = devNo.data()!['no_devices'];
    var DeviceNo = TRemNo + 1;
    print(DeviceNo);
    await db
        .collection('departments')
        .doc(depID)
        .update({'no_devices': DeviceNo});

    db.collection('devices').add(dt).then((value) {
      db.collection('enrollment').doc(value.id).set({
        'enroll': false,
        'last_enroll_id': "",
        'lastUpdate': Timestamp.now()
      });
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  updateDevice(id, data) async {
    await db.collection('devices').doc(id).update(data).then((value) {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
    return true;
  }
}
