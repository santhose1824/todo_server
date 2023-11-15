import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_server/HomePage.dart';

class AddTask extends StatefulWidget {
  final String emailid;
  AddTask({required this.emailid});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> addTask() async {
    final response = await http.post(
      Uri.parse('http://Santhose:5000/todos'),
      body: {
        'email': widget.emailid,
        'todo': titleController.text,
      },
    );
    if (response.statusCode == 200) {
      // User registered successfully
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    email: widget.emailid,
                  )));
    } else {
      // Error registering user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to register user. Please try again.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO LIST'),
      ),
      body: Container(
          color: Colors.blueGrey,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: "Enter the Todo",
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text('Add Task')))
            ],
          )),
    );
  }
}
