import 'package:chat_app/screens/auth_screen_firebase.dart';
import 'package:chat_app/screens/chta_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor:  Colors.deepPurple,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )
        )
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (context,snap)
        {
          if(snap.hasData) {
            return const ChatScreen();
          }
          else
            {
              return const AuthScreenFirebase();
            }
        },),
    );
  }
}
