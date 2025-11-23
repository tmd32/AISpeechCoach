import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SpeechAnalysisScreen(),
  ));
}

class SpeechAnalysisScreen extends StatelessWidget {
  const SpeechAnalysisScreen({super.key});

  // 색상 상수 정의
  final Color backgroundColor = const Color(0xFF111111); // 전체 배경
  final Color cardColor = const Color(0xFF1E1E24); // 카드 배경
  final Color primaryBlue = const Color(0xFF3F75FF); // 강조 파랑
  final Color warningYellow = const Color(0xFFD4A018); // 경고 노랑
  final Color dangerRed = const Color(0xFFE64A4A); // 위험 빨강
  final Color successGreen = const Color(0xFF4CAF50); // 성공 초록
  final Color textWhite = Colors.white;
  final Color textGrey = Colors.grey;

  @override
  Widget build(BuildContext context) {
    // 웹에서 실행 시 배경을 어둡게 채우기 위한 바깥쪽 Container
    return Container(
      color: Colors.black, // 웹 브라우저의 나머지 배경색
      alignment: Alignment.center, // 중앙 정렬
      child: ConstrainedBox(
        // 모바일 비율 유지를 위한 최대 너비 제한 (예: 500px)
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        // 여기서부터 실제 앱 화면 시작
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textWhite),
              onPressed: () {},
            ),
            title: Text(
              'Detailed Analysis',
              style: TextStyle(color: textWhite, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildScoreSection(),
                        const SizedBox(height: 30),
                        _buildMetricCard(
                          icon: Icons.speed,
                          title: "말하기 속도",
                          value: "165 WPM",
                          badgeText: "약간 빠름",
                          badgeColor: warningYellow,
                        ),
                        const SizedBox(height: 15),
                        _buildMetricCard(
                          icon: Icons.chat_bubble_outline,
                          title: "군말",
                          value: "총 7회",
                          badgeText: "개선 필요",
                          badgeColor: dangerRed,
                        ),
                        const SizedBox(height: 15),
                        _buildMetricCard(
                          icon: Icons.show_chart,
                          title: "억양",
                          value: "적절한 변화",
                          badgeText: "좋음",
                          badgeColor: successGreen,
                        ),
                        const SizedBox(height: 15),
                        _buildClarityCard(), // 확장된 명확성 카드
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                _buildBottomButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. 상단 종합 점수 섹션
  Widget _buildScoreSection() {
    return Column(
      children: [
        Text("Overall Score", style: TextStyle(color: textGrey, fontSize: 14)),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 10,
                color: const Color(0xFF2C2C35), // 배경 원
              ),
            ),
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: 0.63, // 63%
                strokeWidth: 10,
                color: primaryBlue,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("63",
                    style: TextStyle(
                        color: textWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                Text("/ 100", style: TextStyle(color: textGrey, fontSize: 12)),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Text("좀 더 노력이 필요합니다!",
            style: TextStyle(
                color: textWhite, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // 2. 일반 분석 카드 위젯
  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          _buildIconBox(icon, badgeColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(color: textGrey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badgeText,
                style: TextStyle(
                    color: badgeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Icon(Icons.keyboard_arrow_down, color: textGrey),
        ],
      ),
    );
  }

  // 3. '명확성' 확장 카드
  Widget _buildClarityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBox(Icons.hearing, dangerRed),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("명확성",
                      style: TextStyle(
                          color: textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("78% Score",
                      style: TextStyle(color: textGrey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: dangerRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("개선 필요",
                    style: TextStyle(
                        color: dangerRed,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Icon(Icons.keyboard_arrow_up, color: textGrey),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white10),
          const SizedBox(height: 16),
          Text(
            "웅얼거리거나 불명확하게 들리는 단어들이 몇 개 감지되었습니다. 각 음절을 또박또박 발음하는 데 집중해 보세요",
            style:
            TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          _buildAudioClipItem("의료분야", "at 0:23"),
          const SizedBox(height: 10),
          _buildAudioClipItem("안전하게 만들어 줄..", "at 0:51"),
        ],
      ),
    );
  }

  Widget _buildAudioClipItem(String title, String timestamp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151518),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('"$title"',
                  style: TextStyle(
                      color: Colors.grey[300], fontWeight: FontWeight.bold)),
              Text(timestamp,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11)),
            ],
          ),
          CircleAvatar(
            radius: 14,
            backgroundColor: primaryBlue,
            child: const Icon(Icons.play_arrow, size: 16, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  // 4. 하단 버튼
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_file, color: Colors.white),
              const SizedBox(width: 8),
              Text("Export Results",
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}