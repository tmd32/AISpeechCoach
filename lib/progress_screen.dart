import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.8),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'My Progress',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lexend',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 나의 성장 그래프
            const SectionTitle(title: "나의 성장 그래프"),
            const SizedBox(height: 12),
            _buildGrowthGraphCard(),

            const SizedBox(height: 24),

            // 2. 항목별 세부 분석
            const SectionTitle(title: "항목별 세부 분석"),
            const SizedBox(height: 12),
            _buildRadarChartCard(),

            const SizedBox(height: 24),

            // 3. 나의 스피치 기록 (달력)
            const SectionTitle(title: "나의 스피치 기록"),
            const SizedBox(height: 12),
            _buildCalendarCard(),

            const SizedBox(height: 24),

            // 4. 전체 스피치 기록 (리스트)
            const SectionTitle(title: "전체 스피치 기록"),
            const SizedBox(height: 12),
            _buildFilterButtons(),
            const SizedBox(height: 12),
            _buildSpeechList(),

            const SizedBox(height: 40), // 하단 여백
          ],
        ),
      ),
    );
  }

  // --- 위젯 빌더 메서드 ---

  Widget _buildGrowthGraphCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 탭 버튼 (7 Days / 30 Days / All Time)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTabButton("7 Days", isSelected: true),
                _buildTabButton("30 Days"),
                _buildTabButton("All Time"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 점수 및 상승률
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Overall AI Score", style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                  Text("Last 7 days", style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                ],
              ),
              Row(
                children: const [
                  Icon(Icons.arrow_upward, color: Color(0xFF22C55E), size: 14),
                  SizedBox(width: 4),
                  Text("5.2%", style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          const Text("85", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF111827))),

          const SizedBox(height: 20),
          // 커스텀 라인 차트
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: LineChartPainter(),
            ),
          ),
          const SizedBox(height: 10),
          // 요일 라벨
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const ["M", "T", "W", "T", "F", "S", "S"]
                .map((day) => Text(day, style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarChartCard() {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child: CustomPaint(
              painter: RadarChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 달력 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: Colors.grey),
              const Text("August 2024", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          // 요일 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const ["S", "M", "T", "W", "T", "F", "S"]
                .map((d) => SizedBox(width: 30, child: Center(child: Text(d, style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)))))
                .toList(),
          ),
          const SizedBox(height: 8),
          // 날짜 그리드 (이미지 기반 하드코딩)
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // 이미지의 달력 상태를 흉내냄
    final days = List.generate(35, (index) {
      int day = index - 3; // 7월 말일 패딩 고려
      if (day < 1) return 28 + index; // 이전 달
      if (day > 31) return day - 31; // 다음 달
      return day;
    });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 35,
      itemBuilder: (context, index) {
        int day = days[index];
        bool isCurrentMonth = index >= 4;

        // 특정 날짜 스타일링 (이미지 참조)
        bool isSelected = (day == 18 && isCurrentMonth); // 18일 선택됨
        bool isPracticeDay = [5, 7, 8, 12, 13, 17].contains(day) && isCurrentMonth; // 연습한 날(보라색)
        bool isToday = (day == 18);

        Color bgColor = Colors.transparent;
        Color textColor = isCurrentMonth ? Colors.black87 : Colors.grey[300]!;

        if (isSelected) {
          bgColor = const Color(0xFF4F46E5);
          textColor = Colors.white;
        } else if (isPracticeDay) {
          bgColor = const Color(0xFFEEF2FF); // 연한 보라
          if(day == 7 || day == 12 || day == 17) bgColor = const Color(0xFF4F46E5).withOpacity(0.8); // 진한 보라
          if(day == 7 || day == 12 || day == 17) textColor = Colors.white;
        }

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: const Color(0xFF4F46E5), width: 2) : null,
          ),
          child: Center(
            child: Text(
              "$day",
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected || (isPracticeDay && textColor == Colors.white) ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 16, color: Colors.grey),
            label: const Text("Filter", style: TextStyle(color: Colors.black87)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sort, size: 16, color: Colors.grey),
            label: const Text("Sort by Date", style: TextStyle(color: Colors.black87)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeechList() {
    return Column(
      children: [
        _buildSpeechItem("Impromptu Speech #3", "Aug 18, 2024 • 2m 15s", 92),
        const SizedBox(height: 12),
        _buildSpeechItem("Job Interview Prep", "Aug 17, 2024 • 5m 30s", 88),
        const SizedBox(height: 12),
        _buildSpeechItem("Daily Reading Practice", "Aug 16, 2024 • 1m 45s", 85),
      ],
    );
  }

  Widget _buildSpeechItem(String title, String date, int score) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.graphic_eq, color: Color(0xFF4F46E5)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("$score", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF111827))),
              const Text("Score", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  // --- 공통 스타일 및 헬퍼 ---

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE5E7EB)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        )
      ],
    );
  }

  Widget _buildTabButton(String text, {bool isSelected = false}) {
    return Expanded(
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF111827),
      ),
    );
  }
}

// --- 차트 페인터 (디자인 시안을 위한 CustomPainter) ---

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4F46E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // 데이터 포인트 (임의의 값)
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.16, size.height * 0.6),
      Offset(size.width * 0.33, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.66, size.height * 0.6),
      Offset(size.width * 0.83, size.height * 0.4),
      Offset(size.width, size.height * 0.2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // 그라데이션 채우기
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x334F46E5), Color(0x004F46E5)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPaint = Paint()..shader = gradient;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.8;

    final paintLine = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 6각형 그리기 (배경)
    for (int i = 1; i <= 4; i++) {
      double r = radius * (i / 4);
      _drawPolygon(canvas, center, r, 6, paintLine);
    }

    // 축 그리기
    for (int i = 0; i < 6; i++) {
      double angle = (math.pi * 2 * i) / 6 - math.pi / 2;
      canvas.drawLine(
        center,
        Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle)),
        paintLine,
      );
    }

    // 데이터 그리기
    final dataPaint = Paint()
      ..color = const Color(0xFF4F46E5).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF4F46E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 임의의 데이터 값 (0.0 ~ 1.0)
    final values = [0.8, 0.6, 0.9, 0.5, 0.7, 0.8];
    final path = Path();

    for (int i = 0; i < 6; i++) {
      double angle = (math.pi * 2 * i) / 6 - math.pi / 2;
      double r = radius * values[i];
      double x = center.dx + r * math.cos(angle);
      double y = center.dy + r * math.sin(angle);

      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();

    canvas.drawPath(path, dataPaint);
    canvas.drawPath(path, borderPaint);

    // 라벨 그리기 (단순화)
    _drawLabels(canvas, center, radius, ["속도", "군말", "발음/명확성", "억양/톤", "쉼", "자신감"]);
  }

  void _drawPolygon(Canvas canvas, Offset center, double radius, int sides, Paint paint) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      double angle = (math.pi * 2 * i) / sides - math.pi / 2;
      double x = center.dx + radius * math.cos(angle);
      double y = center.dy + radius * math.sin(angle);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawLabels(Canvas canvas, Offset center, double radius, List<String> labels) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < 6; i++) {
      double angle = (math.pi * 2 * i) / 6 - math.pi / 2;
      double r = radius + 20; // 텍스트 여백
      double x = center.dx + r * math.cos(angle);
      double y = center.dy + r * math.sin(angle);

      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}