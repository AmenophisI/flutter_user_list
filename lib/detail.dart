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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://avatars.githubusercontent.com/u/1?v=4",
              height: 100,
              width: 100,
            ),
            const Text(
              'ユーザ名',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const Chip(
              label: Text('https://api.github.com/users/mojombo'),
            )
          ],
        ),
      ),
    );
  }
}
