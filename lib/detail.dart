import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.user});

  final dynamic user;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<String> favorites = [];
  bool isFavorite = false;

  Future<void> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
      isFavorite = favorites.contains(widget.user['id'].toString());
    });
  }

  Future<void> toggleFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final userId = widget.user['id'].toString();
      if (favorites.contains(userId)) {
        favorites.remove(userId);
      } else {
        favorites.add(userId);
      }
      isFavorite = favorites.contains(userId);
      prefs.setStringList('favorites', favorites);
    });
  }

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

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
              widget.user['avatar_url'],
              height: 100,
              width: 100,
            ),
            Text(
              widget.user['login'],
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Link(
              uri: Uri.parse(widget.user['html_url']),
              builder: (context, followLink) {
                return TextButton(
                  onPressed: followLink,
                  child: Text(widget.user['html_url']),
                );
              },
            ),
            SizedBox(height: 20),
            IconButton(
              onPressed: toggleFavorite,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              iconSize: 40,
              tooltip: isFavorite ? "お気に入りに登録済み" : "お気に入りに登録",
            ),
          ],
        ),
      ),
    );
  }
}
