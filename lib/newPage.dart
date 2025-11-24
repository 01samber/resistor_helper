import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const NewPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Text(subtitle, style: TextStyle(fontSize: 24, color: Colors.black)),
            SizedBox(height: 20),
            Image.network(image, width: 200, height: 200),
          ],
        ),
      ),
    );
  }
}
