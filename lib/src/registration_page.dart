import 'dart:math';
import 'package:flutter/material.dart';
import 'database_helper_users.dart';


class RegistrationPage extends StatefulWidget {
  static const routeName = '/registration';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}


class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password, _fullName;
  
  Future<void> _registerUser() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final user = User(
        userId: UniqueKey().toString(), 
        email: _email!,
        password: _password!,
        fullName: _fullName!,
        subscriptionStatus: DateTime.now().add(Duration(days: 30)),
      );
      
      await DatabaseHelper.insertUser(user);
      }
      Navigator.pushReplacementNamed(context, '/login');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Регистрация'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -200,
            left: -80,
            child: Transform.rotate(
              angle: -15 * (pi / 180),
              child: Image.asset('assets/yellowDecoration.jpg', height: 380),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -30,
            child: Transform.rotate(
              angle: -20 * (pi / 180),
              child: Image.asset('assets/greenDecoration.jpg', height: 300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(labelText: 'ФИО'),
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Пожалуйста, введите ваше полное имя';
                        }
                        return null;
                      },
                      onSaved: (input) {
                        if (input != null) {
                          _fullName = input;
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (input) {
                        if (input != null && !input.contains('@')) {
                          return 'Пожалуйста, введите действительный email';
                        }
                        return null;
                      },
                      onSaved: (input) {
                        if (input != null) {
                          _email = input;
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                      validator: (input) {
                        if (input != null && input.length < 6) {
                          return 'Пароль должен быть не менее 6 символов';
                        }
                        return null;
                      },
                      onSaved: (input) {
                        if (input != null) {
                          _password = input;
                        }
                      },
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                      ),
                      child: Text(
                        'Зарегистрироваться',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}