import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SetProfileIconPage extends StatefulWidget {
  static String tag = 'profile-page';
  const SetProfileIconPage({Key? key}) : super(key: key);

  @override
  State<SetProfileIconPage> createState() => _SetProfileIconPageState();
}

class _SetProfileIconPageState extends State<SetProfileIconPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Profile Icon'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : const AssetImage('assets/flutter.png') as ImageProvider,
              radius: 80,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              child: const Text('Take a Photo'),
            ),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: const Text('Choose from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}