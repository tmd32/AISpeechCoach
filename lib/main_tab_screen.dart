import 'package:aispeechcoach/progress_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen_1.dart';
import 'record.dart';

// 로그인 성공 후 이동할 "진짜 메인 화면" (탭바 포함)
class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  // 1. 하단 탭바를 눌렀을 때 실행
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 2. 홈 화면 내부 버튼에서 "녹음 탭으로 보내줘" 요청이 오면 실행
  void _switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 탭에 들어갈 화면들 구성
    final List<Widget> pages = [
      // 홈: 탭 전환 함수(_switchTab)를 전달해줌
      HomeScreen(onSwitchTab: _switchTab),
      // 녹음: 기능 화면
      const SpeechCoachScreen(),
      // (임시) 통계 화면
      const ProgressScreen(),
      // (임시) 설정 화면
      const Center(child: Text("Settings Screen")),
    ];

    // 웹/데스크톱 환경 대응 (화면 중앙 정렬 & 너비 제한)
    // 로그인 화면에서 넘어올 때 이미 Scaffold가 있을 수 있지만,
    // 여기서는 탭바 구조를 잡기 위해 새로 Scaffold를 씁니다.
    return Container(
      color: Colors.grey[200], // 웹 배경색
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Scaffold(
          // IndexedStack: 탭 전환 시 화면 상태(스크롤 위치 등)를 유지해줌
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color(0xFF13A4EC),
            unselectedItemColor: Colors.grey[500],
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.mic), label: 'Record'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart), label: 'Progress'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}