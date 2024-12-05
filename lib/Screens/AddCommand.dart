import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/Home.dart';
import 'package:random_string/random_string.dart';

class AddCommand extends StatefulWidget {
  const AddCommand({super.key});

  @override
  State<AddCommand> createState() => _CommandState();
}

class _CommandState extends State<AddCommand> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    // Nettoyage des contrôleurs pour éviter les fuites de mémoire
    nameController.dispose();
    phonenumberController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Commande ajoutée"),
        content: const Text("Votre commande a été ajoutée avec succès."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer le dialogue
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _addCommand() async {
    if (nameController.text.isNotEmpty &&
        phonenumberController.text.isNotEmpty &&
        contentController.text.isNotEmpty) {
      // Créer un ID aléatoire pour la commande
      String Id = randomAlphaNumeric(10);
      Map<String, dynamic> postInfoMap = {
        "name": nameController.text,
        "phonenumber": phonenumberController.text,
        "content": contentController.text,
        "commandId": Id,
        "authorId": FirebaseAuth.instance.currentUser?.uid,
      };

      // Ajouter la commande à Firebase
      await FirebaseFirestore.instance.collection('commands').doc(Id).set(postInfoMap);

      // Afficher le dialogue de confirmation
      _showConfirmationDialog();
    } else {
      // Afficher une alerte si les champs sont vides
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Tous les champs doivent être remplis."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Add",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Delivery",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "PhoneNumber",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: phonenumberController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Content",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 60.0),
            Center(
              child: ElevatedButton(
                onPressed: _addCommand,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10.0),
                    Image.asset(
                      'assets/images/commandfood.png',
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      "Buy",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
