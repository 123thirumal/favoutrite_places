import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageSelector extends StatefulWidget{
  const ImageSelector({super.key,required this.pickImage});

  final void Function(File) pickImage;

  @override
  State<ImageSelector> createState(){
    return _ImageSelectorState();
  }
}

class _ImageSelectorState extends State<ImageSelector>{


  File? selectedImage;


  void _showDialogBox(){
    showDialog(
        context: context,
        builder: (ctx){
          return Center(
            child: Container(
              width: 450,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ThemeData().colorScheme.secondary
              ),
              margin: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                      onPressed: _imageFromCamera,
                      icon: const Icon(Icons.camera_alt_outlined,size: 35,),
                      label: const Text('Open camera',style: TextStyle(fontSize: 20),),
                  ),
                  const SizedBox(height: 20,),
                  TextButton.icon(
                      onPressed: _imageFromGallery,
                      icon: const Icon(Icons.photo,size: 35,),
                      label: const Text("Select from gallery",style: TextStyle(fontSize: 20),),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _imageFromCamera() async {
    final imagePicker= ImagePicker();
    Navigator.pop(context);
    final pickedImage=await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if(pickedImage==null){
      return;
    }

    setState(() {
      selectedImage=File(pickedImage.path);
    });

    widget.pickImage(selectedImage!);
  }

  void _imageFromGallery() async {
    final imagePicker = ImagePicker();
    Navigator.pop(context);
    final pickedImage=await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    if(pickedImage==null){
      return;
    }

    setState(() {
      selectedImage=File(pickedImage.path);
    });

    widget.pickImage(selectedImage!);
  }

  @override
  Widget build(context){

    Widget content=Center(
      child: TextButton.icon(
          onPressed: _showDialogBox,
          icon: const Icon(Icons.camera_front_outlined,size: 30,),
          label: const Text('Click to add image',style: TextStyle(fontSize: 15),),
      ),
    );

    if(selectedImage!=null){
      content = Image.file(selectedImage!,fit: BoxFit.cover,);
    }


    return Container(
      height: 250,
      width: 250,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
      ),
      child: GestureDetector(
        onTap: _showDialogBox,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ThemeData().colorScheme.secondary
          ),
          width: 220,
          height: 220,
          clipBehavior: Clip.hardEdge,
          child: content,
        ),
      ),
    );
  }
}