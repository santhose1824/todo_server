import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = '';
  String email = '';
  String password = '';

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse('http://Santhose:5000/register'),
      body: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // User registered successfully
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
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
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) => setState(() => username = value),
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              onChanged: (value) => setState(() => email = value),
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: (value) => setState(() => password = value),
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Login'))
          ],
        ),
      ),
    );
  }
}
