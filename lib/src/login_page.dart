import 'package:flutter/material.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late String _email = '';
  late String _password = '';
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView( // Чтобы содержимое было по центру экрана
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Выравнивание содержимого по вертикали
            children: <Widget>[
              Image.asset('assets/logo.png'), // Добавьте изображение логотипа
              SizedBox(height: 20),
              Text(
                'Персональный Медицинский Помощник', // Зеленый текст под логотипом
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
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
                    TextFormField(
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
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value!;
                            });
                          },
                        ),
                        Text('Я ознакомлен с тем, что это рекомендательная система'),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null && _formKey.currentState!.validate() && _agreedToTerms) {
                          _formKey.currentState!.save();

                          if (_email == 'test@' && _password == 'test123') {
                            Navigator.pushReplacementNamed(context, MainPage.routeName);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Войти'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
