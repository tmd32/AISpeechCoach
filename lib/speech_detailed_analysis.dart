import 'package:flutter/material.dart';

class SpeechDetailedAnalysisScreen extends StatelessWidget {
  const SpeechDetailedAnalysisScreen({super.key});

  // 색상 상수 정의
  final Color backgroundColor = const Color(0xFF191022);
  final Color cardColor = const Color(0xFF211C27);

  final Color primaryBlue = const Color(0xFF3F75FF);
  final Color warningYellow = const Color(0xFFD4A018);
  final Color dangerRed = const Color(0xFFE64A4A);
  final Color successGreen = const Color(0xFF4CAF50);
  final Color textWhite = Colors.white;
  final Color textGrey = Colors.grey;

  @override
  Widget build(BuildContext context) {
    // 1. 화면 밖 배경을 하얀색(Colors.white)으로 설정
    return Container(
      color: Colors.white,
      alignment: Alignment.center, // 중앙 정렬
      child: ConstrainedBox(
        // 2. 앱 화면의 너비를 350px로 제한 (AppBar 포함)
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 800, // 필요하다면 높이 제한도 가능 (선택 사항)
        ),
        // 3. Scaffold가 이 ConstrainedBox 내부에서만 그려짐
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textWhite),
              onPressed: () {
                Navigator.pop(context);
              },
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
            // 배경 원
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 12,
                color: const Color(0xFF2C2C35),
              ),
            ),
            // 진행률 원
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: 0.63, // 63%
                strokeWidth: 12,
                color: primaryBlue,
                strokeCap: StrokeCap.round,
              ),
            ),
            // 중앙 텍스트
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("63",
                    style: TextStyle(
                        color: textWhite,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
                Text("/ 100", style: TextStyle(color: textGrey, fontSize: 12)),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Text("좀 더 노력이 필요합니다!",
            style: TextStyle(
                color: textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _buildIconBox(icon, badgeColor),
          const SizedBox(width: 16),
          Expanded( // 텍스트 오버플로우 방지
            child: Column(
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
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeColor, // 뱃지 배경색 진하게
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badgeText,
                style: const TextStyle( // 뱃지 텍스트는 검정색 등으로 가독성 확보
                    color: Colors.black87,
                    fontSize: 11,
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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBox(Icons.hearing, dangerRed),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
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
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: dangerRed, // 뱃지 진하게
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("개선 필요",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Icon(Icons.keyboard_arrow_up, color: textGrey),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.1)),
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
        color: const Color(0xFF2C2C35), // 오디오 클립 배경색 약간 밝게
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
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(timestamp,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11)),
            ],
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primaryBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, size: 20, color: Colors.white),
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
        // 상단 경계선 제거하여 더 깔끔하게
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