import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_server/HomePage.dart';
import 'package:todo_server/Register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _message = '';

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Make POST request to the login API endpoint
    final response = await http.post(Uri.parse('http://Santhose:5000/login'),
        body: {'email': username, 'password': password});

    if (response.statusCode == 200) {
      // Login successful, navigate to home page
      setState(() {
        _message = 'Login successful';
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    email: username,
                  )));
    } else if (response.statusCode == 401) {
      // Invalid username or password
      setState(() {
        _message = 'Invalid username or password';
      });
    } else {
      // Internal server error
      setState(() {
        _message = 'Failed to login';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            Text(_message),
            SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text('Register'))
          ],
        ),
      ),
    );
  }
}
