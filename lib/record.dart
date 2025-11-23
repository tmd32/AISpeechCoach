import 'package:flutter/material.dart';
import 'summary.dart';

class SpeechCoachScreen extends StatefulWidget {
  const SpeechCoachScreen({super.key});

  @override
  State<SpeechCoachScreen> createState() => _SpeechCoachScreenState();
}

class _SpeechCoachScreenState extends State<SpeechCoachScreen> {
  int selectedTab = 0;
  bool isRecording = false;
  final List<String> tabs = ['자유 스피치', '스크립트 연습', '즉석 스피치 연습'];

  Future<void> _stopRecordingAndAnalyze() async {
    setState(() {
      isRecording = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                color: Colors.white,
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

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    Navigator.of(context).pop();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PracticeSummaryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold 및 BottomNavigationBar 제거 (MainScreen에서 관리)
    // ConstrainedBox 등 웹 래퍼 제거 (MainScreen에서 관리)
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
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

          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isRecording) {
                      _stopRecordingAndAnalyze();
                    } else {
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
    );
  }
}