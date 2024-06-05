import 'package:flutter/material.dart';
import 'dart:math';

import 'main_page.dart';
import 'database_helper_users.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Профиль'),
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
            top: -140,
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
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200], 
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '${UserSession.currentUser?.fullName}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Кнопка "Мои данные"
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Мои данные'),
                      ),
                      SizedBox(height: 16),
                      Divider(
                        color: Colors.grey[400], 
                        thickness: 1, 
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Мои рекомендации'),
                      ),
                      SizedBox(height: 16),
                      Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                      SizedBox(height: 16),
                      // Кнопка "Настройки"
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Настройки'),
                      ),
                      SizedBox(height: 16),
                      Divider(
                        color: Colors.grey[400], 
                        thickness: 1,
                      ),
                      SizedBox(height: 16),
                      // Кнопка "Условия конфиденциальности"
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('Условия конфиденциальности'),
                      ),
                      SizedBox(height: 16),
                      Divider(
                        color: Colors.grey[400], 
                        thickness: 1,
                      ),
                      SizedBox(height: 16),
                      // Кнопка "Поддержка"
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.black, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), 
                          ),
                        ),
                        child: Text('Поддержка'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}