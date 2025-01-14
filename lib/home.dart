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

  String listedUser = '';

  Future<void> _fetchUsers() async {
    final res = await http.get(Uri.parse("https://api.github.com/users"));
    final List<dynamic> data = jsonDecode(res.body);
    setState(() {
      users = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void filterToDos(String condition) {
    setState(() {
      filteredUsers = users.where((todo) => todo.contains(condition)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('toDoアプリ'),
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
              onChanged: filterToDos,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  // listedUser = filteredUsers[index];
                  // if (listedUser.length > 20) {
                  //   listedUser = '${listedUser.substring(0, 20)}...';
                  // }
                  return ListTile(
                    leading: Image.network(
                      users[index]['avatar_url'],
                      height: 50,
                      width: 50,
                    ),
                    title: Text(users[index]['login']),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => Detail(toDo: filteredUsers[index])));
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
