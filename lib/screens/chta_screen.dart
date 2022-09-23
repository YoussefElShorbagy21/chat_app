import 'package:chat_app/widget/chat/message.dart';
import 'package:chat_app/widget/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          DropdownButton(underline: Container(),icon: Icon(Icons.more_vert,color: Theme.of(context).primaryIconTheme.color,),
              items: [
                DropdownMenuItem(value: 'LogOut',child: Row(
                  children:
                  const [
                    Icon(Icons.exit_to_app_outlined),
                    SizedBox(width: 8,),
                    Text('Log Out'),
                  ],
                ),),
              ],
              onChanged: (value){
                if(value == 'LogOut')
                {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Column(
        children:
        const [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}
