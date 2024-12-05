import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommandSearchPage extends StatefulWidget {
  @override
  _CommandSearchPageState createState() => _CommandSearchPageState();
}

class _CommandSearchPageState extends State<CommandSearchPage> {
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> searchResults = [];
  bool isLoading = false;

  void performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('commands')
          .where('authorId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      List<QueryDocumentSnapshot> filteredResults = snapshot.docs.where((doc) {
        String name = doc['name'] ?? '';
        String phonenumber = doc['phonenumber'] ?? '';
        String content = doc['content'] ?? '';

        return name.toLowerCase().contains(query.toLowerCase()) ||
            phonenumber.toLowerCase().contains(query.toLowerCase()) ||
            content.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        searchResults = filteredResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la recherche : ${e.toString()}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Rechercher des commandes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "🔍 Rechercher par nom, téléphone ou contenu...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                performSearch(value);
              },
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: searchResults.isEmpty
                      ? Center(
                          child: Text(
                            "Aucun résultat trouvé.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = searchResults[index];
                            return Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.blueGrey, Colors.black54],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds['name'] ?? 'Nom non disponible',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      "📞 Téléphone : ${ds['phonenumber']}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      "📋 Contenu : ${ds['content']}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
