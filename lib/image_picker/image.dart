import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  final void Function(File pickedImage) imagePickfn ;
  UserImagePicker(this.imagePickfn);
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  final ImagePicker imagePicker = ImagePicker();

  void _pickImage(ImageSource imageSource) async{
    final pickedImageFile = await imagePicker.pickImage(source: imageSource,imageQuality: 50,maxWidth: 150);

    if(pickedImageFile != null )
      {
        setState(() {
          this._pickedImage = File(pickedImageFile.path);
        });
       widget.imagePickfn(_pickedImage!);
      }
    else
      {
        print('No Image Selected') ;
      }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
       children:
       [
         CircleAvatar(
           radius: 50,
           backgroundColor: Colors.grey,
           backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
         ),
         const SizedBox(height: 10,),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children:
           [
             TextButton.icon(
                 onPressed: () => _pickImage(ImageSource.camera),
                 icon: const Icon(
                   Icons.photo_camera_outlined,
                 ),
                 label: const Text('Add Image\nfrom Camera',textAlign: TextAlign.center,)),
             TextButton.icon(
                 onPressed: () => _pickImage(ImageSource.gallery),
                 icon: const Icon(
                   Icons.image,
                 ),
                 label: const Text('Add Image\nfrom Gallery',textAlign: TextAlign.center,))
           ],
         ),
       ],
    );
  }
}
