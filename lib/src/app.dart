import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'login_page.dart';
import 'main_page.dart';
import 'profile_page.dart';
import 'analyses_page.dart';
import 'add_analyses_page.dart';
import 'registration_page.dart';



/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: settingsController.themeMode,
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        AddAnalysisPage.routeName: (context) => AddAnalysisPage(),
        RegistrationPage.routeName: (context) => RegistrationPage(),
        SettingsView.routeName: (context) =>
            SettingsView(controller: settingsController),
        SampleItemDetailsView.routeName: (context) => const SampleItemDetailsView(),
        MainPage.routeName: (context) => _buildPageWithNavigationBar(context, MainPage()),
        SampleItemListView.routeName: (context) =>
            _buildPageWithNavigationBar(context, const SampleItemListView()),
        AnalysisPage.routeName: (context) => _buildPageWithNavigationBar(context, AnalysisPage()),
        ProfilePage.routeName: (context) => _buildPageWithNavigationBar(context, ProfilePage()),
      },
    );
  }

  Widget _buildPageWithNavigationBar(BuildContext context, Widget page) {
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, AnalysisPage.routeName);
              break;
            case 2:
              Navigator.pushNamed(context, ProfilePage.routeName);
              break;
            default:
              Navigator.pushNamed(context, MainPage.routeName);
              break;
          }
        },
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Анализы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
