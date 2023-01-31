import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  File? images;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final MyGallery = File(image.path);
      setState(() {
        this.images = MyGallery;
      });
    } on PlatformException catch (e) {
      print("Unavailable");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment 5"),
      ),
      body: Column(
        children: [
          Container(
            child: const Text(
              "Gallery",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(50),
            decoration: BoxDecoration(),
            child: images != null
                ? CircleAvatar(
                    radius: 100,
                    child: Image.file(
                      images!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Image(
                    image: AssetImage('assets/Moonlight.png'),
                    fit: BoxFit.cover,
                    width: 300,
                    height: 300,
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (int index) async {
          if (index == _selectedIndex) {
            PermissionStatus cameraStatus = await Permission.camera.request();
            if (cameraStatus == PermissionStatus.granted) {
              pickImage(ImageSource.camera);
            } else if (cameraStatus == PermissionStatus.denied) {
              return;
            }
          } else {
            PermissionStatus galleryStatus = await Permission.storage.request();
            if (galleryStatus == PermissionStatus.granted) {
              pickImage(ImageSource.gallery);
            } else if (galleryStatus == PermissionStatus.denied) {
              return;
            }
          }
        },
      ),
    );
  }
}
