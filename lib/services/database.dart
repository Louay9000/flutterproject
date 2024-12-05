import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addCommandDetails(
      Map<String, dynamic> commandInfoMap, String commandId) async {
    try {
      return await FirebaseFirestore.instance
          .collection('commands')
          .doc(commandId)
          .set(commandInfoMap);
    } catch (e) {
      print("Erreur lors de l'ajout du command : $e");
      throw e;
    }
  }


  Future<Stream<QuerySnapshot>> getCommands() async {
    try {
      return await FirebaseFirestore.instance.collection('commands').snapshots();
    } catch (e) {
      print("Erreur lors de la récupération des commands : $e");
      throw e;
    }
  }

  Future<Stream<QuerySnapshot>> getUserCommands(String uid) async {
    try {
      return await FirebaseFirestore.instance
          .collection('commands')
          .where("authorId", isEqualTo: uid)
          .snapshots();
    } catch (e) {
      print("Erreur lors de la récupération des commands : $e");
      throw e;
    }
  }

  Future updateCommandDetails(String id , Map<String,dynamic>updateInfo)  async{
    return await
    FirebaseFirestore
    .instance
    .collection("commands")
    .doc(id)
    .update(updateInfo);

  }


  Future deleteCommand(String id) async {
    return await FirebaseFirestore.instance.collection("commands").doc(id).delete();
  }









  


}
