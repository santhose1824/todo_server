import 'package:flutter/material.dart';
import 'package:todo_server/AddTask.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Todos {
  final todos;
  Todos({required this.todos});

  factory Todos.fromJson(Map<String, dynamic> json) {
    return Todos(todos: json['todolist']);
  }
}

class HomePage extends StatefulWidget {
  final String email;

  HomePage({
    required this.email,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todos> todos = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    try {
      final response = await http
          .get(Uri.parse('http://Santhose:5000/getUserData/${widget.email}'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          todos = responseData.map((json) => Todos.fromJson(json)).toList();
        });
      } else {
        print('Failed to fetch todos: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch todos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO LIST"),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            final todo = todos[index];
            return ListTile(
                title: Container(
              child: Text(todo.todos,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTask(
                        emailid: widget.email,
                      )));
        },
      ),
    );
  }
}
