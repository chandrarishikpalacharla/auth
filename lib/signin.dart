import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo/forgetpassword.dart';
import 'package:photo/main.dart';
import 'package:photo/utils.dart';

class SignIN extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const SignIN({super.key,required this.onClickedSignUp});

  @override
  State<SignIN> createState() => _SignINState();
}

class _SignINState extends State<SignIN> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "enter your email"),
          ),
          SizedBox(height: 4,),
          TextField(
            controller: passwordController,
            cursorColor: Colors.white,
           textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "enter your password"),
            obscureText: true,
          ),
          SizedBox(height: 20,),
          ElevatedButton.icon(onPressed: signIn, icon: Icon(Icons.arrow_forward,size: 32,), label: Text("Sign In",style: TextStyle(fontSize: 24),),style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),),

          SizedBox(height: 24,),
          GestureDetector(
            child: Text("Forget password?",style: TextStyle(decoration: TextDecoration.underline,color: Theme.of(context).colorScheme.secondary,fontSize: 20),),
            onTap:() => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FprgetPassword())),
          ),
          RichText(text: TextSpan(
            style: TextStyle(color: Colors.white,fontSize: 20,),
            text: "No Account? ",
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap= widget.onClickedSignUp,
                text: "sign UP",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary
                )
              )
            ]
          ))

        ],
      ),
    );

  }
  Future signIn() async{
    showDialog(context: context,barrierDismissible: false, builder: (context)=>Center(child: CircularProgressIndicator(),));
    try{

       await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    }
    on FirebaseAuthException catch(e){
       Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}