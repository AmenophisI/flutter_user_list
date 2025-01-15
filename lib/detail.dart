import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.user});

  final dynamic user;

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
              user['avatar_url'],
              height: 100,
              width: 100,
            ),
            Text(
              user['login'],
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Link(
                uri: Uri.parse(user['html_url']),
                builder: (context, followLink) {
                  return TextButton(
                      onPressed: followLink, child: Text(user['html_url']));
                })
          ],
        ),
      ),
    );
  }
}
