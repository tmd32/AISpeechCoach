import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  // ✅ [수정됨] 부모(MainTabScreen)로부터 탭을 바꾸는 함수를 전달받기 위한 변수 추가
  final Function(int) onSwitchTab;

  // ✅ [수정됨] 생성자에서 required this.onSwitchTab을 통해 반드시 함수를 받도록 설정
  const HomeScreen({super.key, required this.onSwitchTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // 버튼 클릭 시 Record 탭(인덱스 1)으로 이동 요청하는 내부 함수
  void _goToRecordTab() {
    // 위젯(widget)에 저장된 onSwitchTab 함수를 호출하여 1번 탭으로 이동
    widget.onSwitchTab(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('AI Speech Coach',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined)),
              ],
            ),
            const SizedBox(height: 12),

            // 카드 (요약)
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                    colors: [Color(0xFFBBAA88), Color(0xFF9E8866)]),
              ),
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('최근 피드백 요약',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('적절한 속도 / 군말 사용 개선 👏',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text('오늘의 스피치 팁',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('오늘은 호흡에 집중해봐요.'),

            const SizedBox(height: 20),
            const Text('바로 연습하기',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 버튼 행 (수정됨: _goToRecordTab 연결)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _goToRecordTab, // ✅ 탭 전환 함수 호출
                    icon: const Icon(Icons.fiber_manual_record,
                        color: Colors.white),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: const Text('스피치 업로드 하기',
                          style: TextStyle(color: Colors.white)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _goToRecordTab, // ✅ 탭 전환 함수 호출
                    icon: const Icon(Icons.description_outlined,
                        color: Colors.black87),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: const Text('스크립트 업로드',
                          style: TextStyle(color: Colors.black87)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _goToRecordTab, // ✅ 탭 전환 함수 호출
                    icon: const Icon(Icons.mic, color: Colors.white),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: const Text('지금 바로 스피치 시작하기',
                          style: TextStyle(color: Colors.white)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _goToRecordTab, // ✅ 탭 전환 함수 호출
                    icon: const Text('💯',
                        style: TextStyle(color: Colors.black87)),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: const Text('즉석 스피치 연습',
                          style: TextStyle(color: Colors.black87)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // 활동 통계 요약
            const Text('활동 통계 요약',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('🔥', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 8),
                        Text('연속 연습일',
                            style: TextStyle(color: Colors.black54)),
                        SizedBox(height: 8),
                        Text('5',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('⏰', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 8),
                        Text('누적 스피치 시간',
                            style: TextStyle(color: Colors.black54)),
                        SizedBox(height: 8),
                        Text('2h 30m',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('평균 점수', style: TextStyle(color: Colors.black54)),
                  SizedBox(height: 8),
                  Text('85',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Text('최근 스피치 기록',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // 최근 스피치 항목
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.mic)),
                title: const Text('Presentation Practice',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('2 min 30 sec · AI Score: 92'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _goToRecordTab, // ✅ 리스트 클릭 시에도 탭 이동
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}