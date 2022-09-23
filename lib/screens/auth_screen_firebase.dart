import 'dart:io';

import 'package:chat_app/widget/auth_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreenFirebase extends StatefulWidget {
  const AuthScreenFirebase({Key? key}) : super(key: key);

  @override
  State<AuthScreenFirebase> createState() => _AuthScreenFirebaseState();
}

class _AuthScreenFirebaseState extends State<AuthScreenFirebase> {

  bool _isLoading = false;
  void _submitAuthForm(String email , String password,String username,bool isLogin,BuildContext context,File image)
  async {
    try
    {
      setState(() {
        _isLoading = true;
      });
      if(isLogin)
        {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        }
      else
        {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          final ref = FirebaseStorage.instance.ref().child('user_image').child('${userCredential.user!.uid}.jpg');
         await ref.putFile(image);

          final url = await ref.getDownloadURL();
          print(url);
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(
              {
                'username': username,
                'password':password,
                'image_url': url,
              });
        }

    }on FirebaseAuthException catch (e)
    {
      String message = 'Error';
      if(e.code == 'weak-password')
        {
          message = 'The password provided is too weak' ;
        } else if (e.code == 'email-already-in-use')
        {
          message = 'The account already exists for that email' ;
        } else if (e.code == 'user-not-found')
          {
            message = 'No user found for that email' ;
          }else if(e.code == 'wrong-password')
            {
              message = 'Wrong password provided for that user. ' ;
            }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),backgroundColor: Theme.of(context).errorColor,));
    setState(() {
      _isLoading = false ;
    });
    }catch (e)
    {
      print('e : $e');
      setState(() {
        _isLoading = false ;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:  AuthScreen(_submitAuthForm,_isLoading),
    );
  }
}
