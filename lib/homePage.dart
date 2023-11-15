import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo/pickimage.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final textController = TextEditingController();
   final currentUser = FirebaseAuth.instance.currentUser!;
   Uint8List? _image;

   selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  Future AddUserDetails() async{

    userDetails(currentUser.email!, userController.text.trim(), bioController.text.trim(),currentUser.uid);
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
  Widget build(BuildContext context)
  {
    final user  =FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text("home")),
      body: Padding(padding: EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Text("signed In as",style: TextStyle(fontSize: 16),),
        SizedBox(height: 8,),
        Text(user.email!,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        SizedBox(
          height: 20,
        ),
        Stack(
          children: [
            _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        ):
            CircleAvatar(
              radius: 64,
              backgroundImage: NetworkImage("https://i.stack.imgur.com/l60Hf.png"),
              backgroundColor: Colors.red,
            ),
            Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
            
          ],
        ),
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
        ElevatedButton.icon(onPressed: ()=>FirebaseAuth.instance.signOut(), icon: Icon(Icons.arrow_back,size: 32,), label: Text("Sign out",style: TextStyle(fontSize: 24),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),)
      ]),),
    );
  }
}