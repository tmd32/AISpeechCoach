import 'package:flutter/material.dart';
import 'summary.dart'; // 이동할 화면 import

class SpeechCoachScreen extends StatefulWidget {
  const SpeechCoachScreen({super.key});

  @override
  State<SpeechCoachScreen> createState() => _SpeechCoachScreenState();
}

class _SpeechCoachScreenState extends State<SpeechCoachScreen> {
  int selectedTab = 0;
  bool isRecording = false;
  final List<String> tabs = ['자유 스피치', '스크립트 연습', '즉석 스피치 연습'];

  // 녹음 중지 및 분석 시뮬레이션 함수
  Future<void> _stopRecordingAndAnalyze() async {
    // 1. 녹음 상태 해제
    setState(() {
      isRecording = false;
    });

    // 2. 로딩 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false, // 로딩 중에는 터치로 닫기 방지
      barrierColor: Colors.black54, // 배경을 반투명 검정으로
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // 다이얼로그 자체 배경은 투명하게
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                color: Colors.white, // 로딩 원 색상
                strokeWidth: 3,
              ),
              SizedBox(height: 20),
              Text(
                "AI가 스피치를 분석 중입니다...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "잠시만 기다려 주세요 (약 3초)",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );

    // 3. 3초 대기 (분석 시간 시뮬레이션)
    await Future.delayed(const Duration(seconds: 3));

    // 4. 로딩 다이얼로그 닫기 (화면이 아직 살아있는지 확인 후 실행)
    if (!mounted) return;
    Navigator.of(context).pop();

    // 5. 결과 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PracticeSummaryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 웹/데스크톱 환경을 위한 레이아웃 래퍼 적용
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            // 뒤로가기 버튼 색상 지정 (검정)
            leading: const BackButton(color: Colors.black),
            title: const Text(
              'AI Speech Coach',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              // 상단 탭 메뉴
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(tabs.length, (i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = i;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 8),
                        decoration: selectedTab == i
                            ? const BoxDecoration(
                          border: Border(
                            bottom:
                            BorderSide(color: Colors.black, width: 2),
                          ),
                        )
                            : null,
                        child: Text(
                          tabs[i],
                          style: TextStyle(
                            color: selectedTab == i
                                ? Colors.black
                                : const Color(0xFF607089),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 36),
              // 안내 텍스트
              const Text(
                '오늘도 자신감 있는\n스피치를 연습해 보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 52),

              // --- 녹음 버튼과 상태 텍스트 ---
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isRecording) {
                          // 녹음 중이면 -> 중지하고 분석 로딩 시작
                          _stopRecordingAndAnalyze();
                        } else {
                          // 녹음 전이면 -> 녹음 시작
                          setState(() {
                            isRecording = true;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isRecording
                              ? Colors.red
                              : const Color(0xFF13A4EC),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isRecording
                                  ? Colors.redAccent.withOpacity(0.3)
                                  : const Color(0x3313A4EC),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                          border: Border.all(
                            color: isRecording
                                ? Colors.redAccent
                                : Colors.transparent,
                            width: isRecording ? 4 : 0,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            isRecording ? Icons.mic_none : Icons.mic,
                            color: Colors.white,
                            size: 56,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isRecording ? '녹음 중입니다' : '연습 시작하기',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              // 플로팅 버튼 (추가 기능용)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: FloatingActionButton(
                    backgroundColor: const Color(0xFF13A4EC),
                    onPressed: () {},
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          // 하단 네비게이션
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 1,
            selectedItemColor: const Color(0xFF13A4EC),
            unselectedItemColor: Colors.grey[500],
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mic),
                label: 'Record',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                label: 'Progress',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}