import 'package:cine_memo/presentation/screens/home_screen.dart';
import 'package:cine_memo/presentation/screens/memos_screen.dart';
import 'package:cine_memo/presentation/screens/my_page_screen.dart';
import 'package:flutter/material.dart';

import 'liked_movies_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const LikedMoviesScreen(),
    const MemosScreen(),
    const MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '찜 목록'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: '내 메모'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // 선택된 아이템의 색상
        selectedItemColor: Theme.of(context).colorScheme.primary,
        // 선택되지 않은 아이템의 색상
        unselectedItemColor: Colors.grey,
        // 선택되지 않은 아이템의 라벨도 항상 표시
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // 탭이 4개 이상일 때 필요
      ),
    );
  }
}
