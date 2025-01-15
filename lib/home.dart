import 'dart:convert';

import 'package:flutter/material.dart';
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

  Future<void> _fetchUsers() async {
    final res = await http.get(Uri.parse("https://api.github.com/users"));
    final List<dynamic> data = jsonDecode(res.body);
    setState(() {
      users = data;
      filteredUsers = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void filterUser(String condition) {
    setState(() {
      filteredUsers = users.where((user) {
        final login = user['login']?.toLowerCase() ?? '';
        return login.contains(condition.toLowerCase());
      }).toList();
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
              onChanged: filterUser,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                      filteredUsers[index]['avatar_url'],
                      height: 50,
                      width: 50,
                    ),
                    title: Text(filteredUsers[index]['login']),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => Detail(user: filteredUsers[index])));
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
