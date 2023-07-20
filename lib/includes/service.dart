import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// ignore: camel_case_types
class service {
  Future<bool> createDepartment(name) async {
    db.collection('departments').add({
      'name': name,
    }).then((value) {
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
}
