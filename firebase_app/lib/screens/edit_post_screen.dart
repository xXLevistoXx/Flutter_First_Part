import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; 

class EditPostScreen extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;

  EditPostScreen({required this.postId, required this.postData});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _image;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.postData['title'];
    _contentController.text = widget.postData['content'];
    _imageBase64 = widget.postData['imageBase64'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image != null) {
      final bytes = await _image!.readAsBytes();
      return base64Encode(bytes);
    }
    return _imageBase64; 
  }

  Future<void> _updatePost() async {
    final imageBase64 = await _uploadImage();
    await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
      'title': _titleController.text,
      'content': _contentController.text,
      'imageBase64': imageBase64,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Редактировать пост')),
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
                : _imageBase64 != null
                    ? Image.memory(
                        base64Decode(_imageBase64!), 
                        height: 200,
                      )
                    : Text('Изображение не выбрано'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Выбрать изображение'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updatePost,
              child: Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}