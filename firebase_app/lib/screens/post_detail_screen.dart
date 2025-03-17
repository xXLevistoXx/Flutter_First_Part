import 'dart:convert';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> postData;

  PostDetailScreen({required this.postData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(postData['title'])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (postData['imageBase64'] != null)
              Image.memory(
                base64Decode(postData['imageBase64']),
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(child: Text('Изображение отсутствует')),
              ),
            SizedBox(height: 16),
            Text(postData['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(postData['content']),
            SizedBox(height: 16),
            Text('Автор: ${postData['author']}'),
            Text('Дата: ${postData['timestamp'].toDate()}'),
          ],
        ),
      ),
    );
  }
}