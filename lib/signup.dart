import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo/main.dart';
import 'package:photo/utils.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const SignUp({super.key,required this.onClickedSignIn});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
     userController.dispose();
    bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "enter your email"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>email == null || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email)?'enter a valid email':null,
            ),
            SizedBox(height: 4,),
            TextFormField(
              controller: passwordController,
              cursorColor: Colors.white,
             textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "enter your password"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>value!=null && value.length<6?'enter min. 6 character':null,
              obscureText: true,
            ),
            SizedBox(height: 20,),
            TextField(
            controller: userController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "enter your username"),
          ),
          SizedBox(height: 4,),
          TextField(
            controller: bioController,
            cursorColor: Colors.white,
           textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "enter your bio"),
          ),
          SizedBox(height: 20,),
            ElevatedButton.icon(onPressed: signUp, icon: Icon(Icons.lock_open,size: 32,), label: Text("Sign Up",style: TextStyle(fontSize: 24),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),),
      
            SizedBox(height: 24,),
            RichText(text: TextSpan(
              style: TextStyle(color: Colors.white,fontSize: 20,),
              text: "already have Account? ",
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap= widget.onClickedSignIn,
                  text: "sign in",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary
                  )
                )
              ]
            ))
      
          ],
        ),
      ),
    );
  }
  Future signUp() async{
    final isValid =formKey.currentState!.validate();
    if(!isValid) return;
    showDialog(context: context,barrierDismissible: false, builder: (context)=>Center(child: CircularProgressIndicator(),));
    try {
     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());

     //adding users data
     userDetails(emailController.text.trim(), userController.text.trim(), bioController.text.trim());
    }
   on FirebaseAuthException catch(e){

        Utils.showSnackBar(e.message);
       
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
  Future userDetails(String email,String user,String bio)async {

    await FirebaseFirestore.instance.collection("userPosts").add({
      'email':email,
        'user':user,
        'bio':bio,
    });
   }
}
