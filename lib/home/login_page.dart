import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;

  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.camera);
      if (res != null) {
        await uploadImageToFirebase(File(res.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to pick Image: $e'),
        ),
      );
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    try {
      Reference reference = FirebaseStorage.instance.ref().child(
            "images/${DateTime.now().millisecondsSinceEpoch}.png",
          );
      await reference.putFile(image).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Upload Successfully Comepleted'),
          ),
        );
      });
      imageUrl = await reference.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to upload Image: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 222, 96),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 100,
                      child: Icon(
                        Icons.person,
                        size: 200,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 130,
                    top: 7,
                    child: GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.person,
                  ),
                  labelText: "User Name",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.remove_red_eye,
                    ),
                    labelText: "Password",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
