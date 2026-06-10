import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/app_model.dart';
import 'pages/home_page.dart';
import 'pages/game_page.dart';
import 'pages/setting_page.dart';

void main() {
  runApp(
    ScopedModel<AppModel>(
      model: AppModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return MaterialApp(
          title: '高分连连看',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          themeMode: model.themeMode,
          home: const MainNavPage(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/game': (context) => const GamePage(),
          },
        );
      },
    );
  }
}

class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  static _MainNavPageState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainNavPageState>();
  }

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int currentIndex = 0;

  final List<Widget> pageList = const [
    HomePage(),
    GamePage(),
    SettingPage(),
  ];

  void setIndex(int idx) {
    setState(() {
      currentIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        iconSize: 24,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: "游戏",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "设置",
          ),
        ],
      ),
    );
  }
}