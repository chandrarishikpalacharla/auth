import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

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
        ElevatedButton.icon(onPressed: ()=>FirebaseAuth.instance.signOut(), icon: Icon(Icons.arrow_back,size: 32,), label: Text("Sign out",style: TextStyle(fontSize: 24),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),)
      ]),),
    );
  }
}