import 'package:flutter/material.dart';
import 'dart:math';
import '../main.dart';
import '../utils/storage_util.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<int> cardData;
  int? firstSelect;
  int? secondSelect;
  int matchCount = 0;
  int score = 0;
  int highestScore = 0;
  final int totalPair = 8;
  bool isLock = false;

  @override
  void initState() {
    super.initState();
    resetGame();
    loadHighestScore();
  }

  Future<void> loadHighestScore() async {
    int? saveHigh = await StorageUtil.getInt('highest_score');
    setState(() {
      highestScore = saveHigh ?? 0;
    });
  }

  Future<void> saveHighestScore(int newScore) async {
    if (newScore > highestScore) {
      await StorageUtil.setInt('highest_score', newScore);
      setState(() {
        highestScore = newScore;
      });
    }
  }

  void resetGame() {
    List<int> originData = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8];
    cardData = shuffleList(originData);
    firstSelect = null;
    secondSelect = null;
    matchCount = 0;
    score = 0;
    isLock = false;
  }

  List<T> shuffleList<T>(List<T> list) {
    List<T> newList = List.from(list);
    for (int i = newList.length - 1; i > 0; i--) {
      int r = Random().nextInt(i + 1);
      var temp = newList[i];
      newList[i] = newList[r];
      newList[r] = temp;
    }
    return newList;
  }

  void onCardTap(int index) async {
    if (isLock) return;
    if (firstSelect == index) return;

    setState(() {
      if (firstSelect == null) {
        firstSelect = index;
      } else {
        secondSelect = index;
        isLock = true;
      }
    });

    if (firstSelect != null && secondSelect != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (cardData[firstSelect!] == cardData[secondSelect!]) {
        setState(() {
          cardData[firstSelect!] = 0;
          cardData[secondSelect!] = 0;
          matchCount++;
          score += 10;
        });
        checkWin();
      }
      setState(() {
        firstSelect = null;
        secondSelect = null;
        isLock = false;
      });
    }
  }

  void checkWin() {
    if (matchCount >= totalPair) {
      saveHighestScore(score);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text("🎉 恭喜通关！本次得分：$score"),
          content: Text(highestScore == score ? "创造新纪录！历史最高分：$highestScore" : "历史最高分：$highestScore"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => resetGame());
              },
              child: const Text("重新开始"),
            ),
          ],
        ),
      );
    }
  }

  // 卡片改为浅蓝色底色
  Widget buildCard(int index) {
    bool isOpen = firstSelect == index || secondSelect == index;
    bool isEmpty = cardData[index] == 0;
    return GestureDetector(
      onTap: () => onCardTap(index),
      child: Container(
        decoration: BoxDecoration(
          // 未选中：浅蓝；选中：深蓝；消除后浅灰
          color: isEmpty
              ? Colors.grey[300]
              : (isOpen ? Colors.blueAccent : Colors.lightBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isEmpty
              ? const SizedBox()
              : Text(
            "${cardData[index]}",
            style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("游戏菜单", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text("重新开始"),
              onTap: () {
                Navigator.pop(context);
                setState(() => resetGame());
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("返回首页"),
              onTap: () {
                Navigator.pop(context);
                MainNavPage.of(context)?.setIndex(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("设置"),
              onTap: () {
                Navigator.pop(context);
                MainNavPage.of(context)?.setIndex(2);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("高分连连看"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            // 顶部信息一行展示
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("最高分：$highestScore", style: TextStyle(fontSize: 16)),
                Text("已消除：$matchCount / $totalPair 对", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("分数：$score", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(cardData.length, (index) => buildCard(index)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}