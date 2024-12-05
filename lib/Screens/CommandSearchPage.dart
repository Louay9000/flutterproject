import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/Homee.dart';
import 'package:flutterproject/services/database.dart';
import 'package:random_string/random_string.dart';

class Command extends StatefulWidget {
  const Command({super.key});

  @override
  State<Command> createState() => _CommandState();
}

class _CommandState extends State<Command> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("Delivery",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body:Container(
        margin: EdgeInsets.only(left:20.0, top:30.0,right:20.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(
          "Name",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24
            ,fontWeight: FontWeight.bold),
            ),
        SizedBox(
          height:10.0
          ),
        Container(
          padding:EdgeInsets.only(left:10.0),
          decoration:BoxDecoration(
            color:Colors.blueGrey[100],
            borderRadius:BorderRadius.circular(10),
          ),
          child: TextField(
          controller :nameController,
decoration:InputDecoration(border:InputBorder.none),
          )
        ),
        SizedBox(height : 20.0,),
          Text(
          "PhoneNumber",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24
            ,fontWeight: FontWeight.bold),
            ),
        SizedBox(
          height:10.0
          ),
        Container(
          padding:EdgeInsets.only(left:10.0),
          decoration:BoxDecoration(
            color:Colors.blueGrey[100],
            borderRadius:BorderRadius.circular(10),
          ),
          child: TextField(
            controller:phonenumberController,
decoration:InputDecoration(border:InputBorder.none),
          )
        ),
        SizedBox(height : 20.0,),
          Text(
          "Content",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24
            ,fontWeight: FontWeight.bold),
            ),
        SizedBox(
          height:10.0
          ),
        Container(
          padding:EdgeInsets.only(left:10.0),
          decoration:BoxDecoration(
            color:Colors.blueGrey[100],
            borderRadius:BorderRadius.circular(10),
          ),
          child: TextField(
            controller:contentController,
decoration:InputDecoration(border:InputBorder.none),
          )
        ),
        SizedBox(height:60.0),
        Center(
          child: ElevatedButton(onPressed: () async {
          String Id = randomAlphaNumeric(10);
          Map<String,dynamic> postInfoMap = {

            "name":nameController.text,
            "phonenumber":phonenumberController.text,
            "content":contentController.text,
            "commandId":Id,
            "authorId":FirebaseAuth.instance.currentUser?.uid
            
          };
          await DatabaseMethods().addCommandDetails(postInfoMap, Id);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homee())
            );

          }, child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(width: 10.0),
              Image.asset('assets/images/commandfood.png', height: 30, width: 30),
              SizedBox(width: 10.0),
              Text(
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
        )
        
      ],
      ),
      ),

    );
  }
}
