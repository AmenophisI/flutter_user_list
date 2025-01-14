import 'package:flutter/material.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> todos = [
    'task1task1task1task1task1task1task1task1task1',
    'タスク2',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
    'タスク3',
  ];
  List<String> filteredToDos = [];

  String listedTodo = '';

  @override
  void initState() {
    super.initState();
    filteredToDos = todos;
  }

  void filterToDos(String condition) {
    setState(() {
      filteredToDos = todos.where((todo) => todo.contains(condition)).toList();
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
                itemCount: filteredToDos.length,
                itemBuilder: (context, index) {
                  listedTodo = filteredToDos[index];
                  if (listedTodo.length > 20) {
                    listedTodo = '${listedTodo.substring(0, 20)}...';
                  }
                  return ListTile(
                    title: Text(listedTodo),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => Detail(toDo: filteredToDos[index])));
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
