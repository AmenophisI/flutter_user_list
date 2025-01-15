import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  bool isLoading = true;
  List<String> favorites = [];
  bool isFavorite = false;
  bool isFilterFavorite = false;
  List favoriteUsers = [];
  String searchCondition = '';

  Future<void> _fetchUsers() async {
    final res = await http.get(Uri.parse("https://api.github.com/users"));
    final List<dynamic> data = jsonDecode(res.body);
    setState(() {
      users = data;
      filteredUsers = data;
    });
  }

  Future<void> setFavorites(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
      prefs.setStringList('favorites', favorites);
    });
  }

  Future<void> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    getFavorites();
  }

  void filterUsers() {
    setState(() {
      if (isFilterFavorite) {
        // お気に入りフィルタが有効
        filteredUsers = users.where((user) {
          final isFavorite = favorites.contains(user['id'].toString());
          if (searchCondition.isEmpty) {
            // 検索条件が空の場合
            return isFavorite;
          } else {
            // 検索条件がある場合
            final login = user['login']?.toLowerCase() ?? '';
            return isFavorite && login.contains(searchCondition.toLowerCase());
          }
        }).toList();
      } else {
        // お気に入りフィルタが無効
        if (searchCondition.isEmpty) {
          // 検索条件が空の場合
          filteredUsers = List.from(users);
        } else {
          // 検索条件がある場合
          filteredUsers = users.where((user) {
            final login = user['login']?.toLowerCase() ?? '';
            return login.contains(searchCondition.toLowerCase());
          }).toList();
        }
      }
    });
  }

  void filterFavorite() {
    setState(() {
      if (isFilterFavorite) {
        filteredUsers = users.where((user) {
          return favorites.contains(user['id'].toString());
        }).toList();
      } else {
        // 絞り込み解除
        filteredUsers = List.from(users);
      }
    });
  }

  void changeSearchCondition(String condition) {
    setState(() {
      searchCondition = condition;
      filterUsers();
    });
  }

  void changeFavoriteFilter(bool isEnabled) {
    setState(() {
      isFilterFavorite = isEnabled;
      filterUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザ一覧'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "検索",
              ),
              onChanged: changeSearchCondition,
            ),
            SwitchListTile(
              title: const Text("お気に入りのみに絞り込む"),
              value: isFilterFavorite,
              onChanged: changeFavoriteFilter,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  final name = user['login'];
                  final id = user['id'].toString();
                  final image = user['avatar_url'];
                  final isFavorite = favorites.contains(id);
                  return ListTile(
                    leading: Image.network(
                      image,
                      height: 50,
                      width: 50,
                    ),
                    title: Text(name),
                    trailing: IconButton(
                      onPressed: () {
                        setFavorites(id);
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Detail(user: filteredUsers[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
