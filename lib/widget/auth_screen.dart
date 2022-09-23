import 'dart:io';

import 'package:flutter/material.dart';

import '../image_picker/image.dart';

class AuthScreen extends StatefulWidget {
  final void Function(String email , String password,String username,bool isLogin,BuildContext context,File image) _submitAuthForm ;
  final bool isLoading ;
  const AuthScreen(this._submitAuthForm, this.isLoading, {super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
   bool _isLogin = true ;
  String _email = "";
   String _password = "";
   String _username = "" ;
   File? _userImageFile ;
   void _pickedImage(File pickedImage)
   {
     _userImageFile = pickedImage ;
   }
  void _submit()
  {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(!_isLogin &&_userImageFile == null)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('please pick an image'),
          backgroundColor: Theme.of(context).errorColor,));
        return ;
      }
    if(isValid) {
        _formKey.currentState!.save();
        widget._submitAuthForm(_email.trim(),_password.trim(), _username.trim(),_isLogin,context,_userImageFile!);
      }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                [
                  if(!_isLogin)  UserImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (val){
                      if(val!.isEmpty || !val.contains('@'))
                        {
                          return 'Please enter a vaild email address' ;
                        }
                      return null ;
                    },
                    onSaved: (val) => _email = val!,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email Address'),
                  ),
                  if(!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (val){
                        if(val!.isEmpty || val.length < 4 )
                        {
                          return 'Please enter a least 4 characters' ;
                        }
                        return null ;
                      },
                      onSaved: (val) => _username = val!,
                      decoration: const InputDecoration(labelText: 'UserName'),
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (val){
                      if(val!.isEmpty || val.length < 7)
                      {
                        return 'password must be at least 7 characters' ;
                      }
                      return null ;
                    },
                    onSaved: (val) => _password = val!,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12,),
                  if(widget.isLoading)
                    const CircularProgressIndicator(),
                  if(!widget.isLoading)
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text( _isLogin ? 'Login' : 'Sing UP'),
                  ),
                  if(!widget.isLoading)
                  TextButton(
                    child: Text(_isLogin ?
                        'Create new account':
                        'I already have an account',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    onPressed:  (){
                      setState(() {
                        _isLogin = !_isLogin ;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
