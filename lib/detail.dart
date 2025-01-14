import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.toDo});

  final String toDo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細画面'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(toDo),
      ),
    );
  }
}
