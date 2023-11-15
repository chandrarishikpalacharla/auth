import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo/homePage.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
   final TextEditingController userController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final textController = TextEditingController();
   final currentUser = FirebaseAuth.instance.currentUser!;
   Future AddUserDetails() async{

    userDetails(currentUser.email!, userController.text.trim(), bioController.text.trim(),currentUser.uid);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future userDetails(String email,String user,String bio,String uid)async {

    await FirebaseFirestore.instance.collection("userPosts").doc(currentUser.uid).set({
      'email':email,
        'user':user,
        'bio':bio,
        'uid':currentUser.uid
    });
   }
   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userController.dispose();
    bioController.dispose();
  }
  @override
  Widget build(BuildContext context) =>
  Scaffold(
    body: Column(
  children: [
    SizedBox(
          height: 20,
        ),
         TextField(
            controller: userController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "enter your username"),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
            controller: bioController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "enter your bio"),
        ),
        SizedBox(height: 20,),
        TextButton(onPressed: AddUserDetails, child: Text("Add user data",style: TextStyle(fontSize: 24),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),),
        SizedBox(height: 40,),

  ],
    ), 
    
  );
}