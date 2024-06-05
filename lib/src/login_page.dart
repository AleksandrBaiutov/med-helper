import 'package:flutter/material.dart';
import 'dart:math';
import 'main_page.dart';
import 'registration_page.dart';
import 'database_helper_users.dart';


class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _loadAnalyses() async {
    final Users = await DatabaseHelper.getUsers();
  }

  final _formKey = GlobalKey<FormState>();

  late String _email = '';
  late String _password = '';
  bool _agreedToTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -150,
            left: -80,
            child: Transform.rotate(
              angle: -25 * (pi / 180),
              child: Image.asset('assets/yellowDecoration.jpg', height: 380,),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -30,
            child: Transform.rotate(
              angle: -20 * (pi / 180),
              child: Image.asset('assets/greenDecoration.jpg', height: 300,),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.lightGreen, 
                        width: 2.0,
                      ),
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Персональный',
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Медицинский Помощник',
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    
                  SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                            ),
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
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                            ),
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
                            decoration: InputDecoration(labelText: 'Пароль'),
                            obscureText: true,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Checkbox(
                                value: _agreedToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreedToTerms = value!;});
                                },
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Я ознакомлен с тем, что это рекомендательная система',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate() &&
                                _agreedToTerms) {
                              _formKey.currentState!.save();
                                User? user = await DatabaseHelper.loginUser(_email, _password);

                                  if (user != null) {
                                    UserSession.currentUser = user;
                                    Navigator.pushReplacementNamed(context, MainPage.routeName);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Неверный email или пароль')),
                                    );
                                  }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                          ),
                          child: Text(
                            'Войти',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Ещё нет аккаунта?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, RegistrationPage.routeName);
                          },
                          child: Text(
                            "Зарегистрируйся!",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}