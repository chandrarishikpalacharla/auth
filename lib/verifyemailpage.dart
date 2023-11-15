import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo/homePage.dart';
import 'package:photo/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerifed = false;
  bool canResendEmail = false;
  bool isMounted = false; 
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isMounted = true;
    isEmailVerifed  =FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerifed){
      sendverificationEmail();

     timer = Timer.periodic(Duration(seconds: 3), (_)=>checkEmailVerified());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isMounted = false; 
    timer?.cancel();
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    if(isMounted){
    setState(() {
      isEmailVerifed = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    }
    if(isEmailVerifed)timer?.cancel();
  }
  
  Future sendverificationEmail()async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    if(isMounted){
    setState(()=>canResendEmail = false);
    }
    await Future.delayed(Duration(seconds: 5));
    if(isMounted){
    setState(()=>canResendEmail = true);
    }
    }
    catch(e){
      Utils.showSnackBar(e.toString());
    }
  }

  Future<void> deleteCurrentUserAndNavigate(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      // Get the user ID
      final uid = user.uid;

      await deleteUserData(uid);

      await user.delete();

      // Sign out the user
      FirebaseAuth.instance.signOut();

      // Navigate to the first page
    //   Navigator.pushNamedAndRemoveUntil(
    //     context,
    //     '/first_page', // Replace with the route name of your first page
    //     (Route<dynamic> route) => false, // This prevents going back to the previous screens
    //   );
     } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  Future<void> deleteUserData(String uid) async {
    try {
      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection('userPosts').doc(uid).delete();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  


  @override
  Widget build(BuildContext context) => isEmailVerifed ? HomePage():Scaffold(
    appBar: AppBar(title: Text('verify email')),
    body: Padding(padding: EdgeInsets.all(16),child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("a verification email has been send to your email",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
        SizedBox(
          height: 24,
        ),
         ElevatedButton.icon(onPressed: canResendEmail? sendverificationEmail: null, icon: Icon(Icons.email,size: 32,), label: Text("Resend Email",style: TextStyle(fontSize: 24),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),),
         SizedBox(
          height: 24,
        ),
         TextButton(onPressed: ()=>deleteCurrentUserAndNavigate(context), child: Text("cancel",style: TextStyle(fontSize: 24),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),),
      ],
    ),),
  );
}