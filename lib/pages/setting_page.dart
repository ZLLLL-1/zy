import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/app_model.dart';
import '../utils/storage_util.dart';
import '../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _getHighScore();
  }

  Future<void> _getHighScore() async {
    int? res = await StorageUtil.getInt('highest_score');
    setState(() {
      highScore = res ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("设置中心")),
      body: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) {
          bool isDark = model.themeMode == ThemeMode.dark;
          return ListView(
            children: [
              ListTile(
                title: const Text("深色模式"),
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) => model.toggleDarkMode(val),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text("最高分"),
                trailing: Text("$highScore"),
              ),
              const Divider(),
              ListTile(
                title: const Text("退出游戏"),
                onTap: () {
                  // 点击直接切回首页
                  MainNavPage.of(context)?.setIndex(0);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}