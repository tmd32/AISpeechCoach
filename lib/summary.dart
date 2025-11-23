import 'package:flutter/material.dart';

class PracticeSummaryScreen extends StatelessWidget {
  const PracticeSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma 이미지의 주요 색상을 정의합니다.
    const Color primaryBlue = Color(0xFF5E6DFF); // 버튼과 점수 원 색상
    const Color cardBackground = Colors.white; // 카드 배경색

    // 웹에서 모바일 비율로 보여주기 위한 래퍼(Wrapper) 시작
    return Container(
      color: Colors.grey[200], // 웹 브라우저의 배경색 (앱 테마에 맞춰 연한 회색 적용)
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500, // 최대 너비 제한
        ),
        // 실제 앱 화면 Scaffold 시작
        child: Scaffold(
          backgroundColor: Colors.grey[50], // 앱 내부 배경색 (약간의 미색)
          appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            title: const Text(
              'Practice Summary',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 날짜 표시
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Oct 26, 2023',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),

                // 1. 전체 점수 표시 (Score Display)
                _buildScoreDisplay(primaryBlue),
                const SizedBox(height: 20),

                // 2. 최고 강점 (Best Aspect Card)
                _buildInfoCard(
                  icon: Icons.thumb_up_alt_rounded,
                  iconColor: Colors.green,
                  title: 'Best Aspect',
                  titleKorean: '훌륭합니다!',
                  content:
                  '이번 연습에서는 말하기 속도가 매우 안정적이었습니다. 일관된 속도를 유지하는 것은 청중의 집중력을 높이는 데 큰 도움이 됩니다.',
                  cardBackground: cardBackground,
                ),
                const SizedBox(height: 20),

                // 3. 핵심 조언 (Key Tip Card)
                _buildInfoCard(
                  icon: Icons.lightbulb_outline,
                  iconColor: Colors.orange,
                  title: 'Key Tip',
                  titleKorean: '군말 줄이기',
                  content:
                  '\'음...\'과 같은 군말이 총 7회 감지되었습니다. 군말 대신 잠시 멈추고 생각을 가다듬어 보세요.',
                  cardBackground: cardBackground,
                ),

                // 4. 하단 버튼 (Bottom Buttons)
                const SizedBox(height: 20),
                _buildBottomButton(
                  context,
                  text: 'Speech Analysis',
                  icon: Icons.play_circle_fill,
                  color: primaryBlue,
                  isPrimary: true,
                  onPressed: () {
                    // 'Speech Analysis' 버튼 액션
                    // 필요 시 여기에 Navigator.push 등을 추가하세요.
                  },
                ),
                const SizedBox(height: 10),
                _buildBottomButton(
                  context,
                  text: 'Share Summary',
                  icon: Icons.upload_outlined,
                  color: primaryBlue,
                  isPrimary: false,
                  onPressed: () {
                    // 'Share Summary' 버튼 액션
                  },
                ),
                const SizedBox(height: 20), // 하단 여백
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 전체 점수 표시 위젯
  Widget _buildScoreDisplay(Color color) {
    return Center(
      child: Column(
        children: [
          const Text(
            '전체 스코어',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 8,
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              '63',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 정보 카드 위젯
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String titleKorean,
    required String content,
    required Color cardBackground,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 아이콘 부분
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
          ),

          // 텍스트 부분
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  titleKorean,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 하단 버튼 위젯
  Widget _buildBottomButton(
      BuildContext context, {
        required String text,
        required IconData icon,
        required Color color,
        required bool isPrimary,
        required VoidCallback onPressed,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: isPrimary
          ? ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // 파란색 배경
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      )
          : OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color, // 파란색 글씨
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 2), // 파란색 테두리
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}