import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'posts_screen.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

Future<void> _addPost() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String? imageBase64;
    if (_image != null) {
      final bytes = await _image!.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }
    await FirebaseFirestore.instance.collection('posts').add({
      'title': _titleController.text,
      'content': _contentController.text,
      'author': user.email,
      'timestamp': Timestamp.now(),
      'imageBase64': imageBase64,
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PostsScreen()),
      (route) => false,
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Новый пост')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Текст'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            _image != null
                ? Image.file(_image!, height: 200)
                : Text('Изображение не выбрано'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Выбрать изображение'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addPost,
              child: Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }
}