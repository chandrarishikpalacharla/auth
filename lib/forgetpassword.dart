import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo/utils.dart';

class FprgetPassword extends StatefulWidget {
  const FprgetPassword({super.key});

  @override
  State<FprgetPassword> createState() => _FprgetPasswordState();
}

class _FprgetPasswordState extends State<FprgetPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("reset password")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 200,),
            Text("receive an email to reset your password"),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "enter your email"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>email == null || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email)?'enter a valid email':null,
            ),
            SizedBox(height: 20,),
            ElevatedButton.icon(onPressed: resetPassword, icon: Icon(Icons.mail_outline,size: 32,), label: Text("Sign Up",style: TextStyle(fontSize: 24),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),),
          ],
        ),
      )
    );
  }
  Future resetPassword() async{
    showDialog(context: context,barrierDismissible: false, builder: (context)=>Center(child: CircularProgressIndicator(),));
    try{
     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
     Utils.showSnackBar('password reset email sent');
     Navigator.of(context).popUntil((route) => route.isFirst);
    }
   on FirebaseAuthException catch(e){
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}