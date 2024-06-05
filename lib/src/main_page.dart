import 'package:flutter/material.dart';
import 'dart:math';
import 'login_page.dart';
import 'database_helper_users.dart';


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  static const routeName = '/main';


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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Здравствуйте, ${UserSession.currentUser?.fullName}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Подписка активна: следующее списание 16.06.2024',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                    ),
                    child: Text(
                      'Пополнить баланс',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        ),
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