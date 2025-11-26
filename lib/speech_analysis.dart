import 'package:aispeechcoach/speech_detailed_analysis.dart';
import 'package:flutter/gestures.dart'; // 제스처 감지를 위해 추가
import 'package:flutter/material.dart';

class SpeechAnalysisScreen extends StatelessWidget {
  const SpeechAnalysisScreen({super.key});

  // 디자인에 사용된 색상 상수 정의
  static const Color kBgColor = Color(0xFF191022);
  static const Color kCardColor = Color(0xFF211C27);
  static const Color kAccentPurple = Color(0xFF7F13EC);
  static const Color kTextGray = Color(0xFFD1D5DB);
  static const Color kTextDarkGray = Color(0xFFB3B3B3);

  static const Color kFeedbackRed = Color(0xFFEF4444);
  static const Color kFeedbackGreen = Color(0xFF22C55E);
  static const Color kFeedbackBlue = Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    // Scaffold 전체를 Center와 ConstrainedBox로 감싸서 AppBar를 포함한 전체 화면 너비를 제한
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Scaffold(
          backgroundColor: kBgColor, // 테마에서 제거되었으므로 직접 지정
          appBar: AppBar(
            backgroundColor: kBgColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // 네비게이션 pop 처리 (필요시 주석 해제)
                // Navigator.of(context).pop();
              },
            ),
            title: const Text(
              'Speech Analysis',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // 1. 메인 스크립트 텍스트 영역
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: RichText(
                    // const 제거 (이벤트 핸들러 추가를 위해)
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18.0,
                        height: 1.6,
                        color: kTextDarkGray,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto', // 폰트 지정
                      ),
                      children: [
                        const TextSpan(text: '안녕하세요, 제 이름은 김민준입니다. 오늘 저는... '),
                        // 군말 (빨강)
                        const TextSpan(
                          text: '음... ',
                          style: TextStyle(color: kFeedbackRed, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: '인공지능이 어떻게 우리의 삶을 바꾸고 있는지에 대해 이야기하려고 합니다. '),
                        // 군말 (빨강)
                        const TextSpan(
                          text: '그러니까, ',
                          style: TextStyle(color: kFeedbackRed, fontWeight: FontWeight.bold),
                        ),
                        // 너무 빠름 (초록 밑줄) -> 클릭 이벤트 추가됨
                        TextSpan(
                          text: 'AI 기술은 정말 빠르게 발전하고 있고, ',
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: kFeedbackGreen,
                            decorationThickness: 2,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _showFeedbackDialog(context);
                            },
                        ),
                        const TextSpan(text: '우리는 이미 많은 분야에서 그 영향을 보고 있습니다. 예를 들어, 의료 분야에서는 질병 진단을 돕고, 금융 분야에서는 사기 탐지를 합니다. '),
                        // 군말 (빨강)
                        const TextSpan(
                          text: '어... ',
                          style: TextStyle(color: kFeedbackRed, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: '그리고 자율주행 자동차도 '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: _TagBadge(text: 'AI'),
                          ),
                        ),
                        const TextSpan(text: '기술의 좋은 예시입니다. '),
                        // 너무 느림 (파랑 밑줄)
                        const TextSpan(
                          text: '이 기술들은 우리의 일상을 더 편리하고 안전하게 만들어 줄 잠재력이 있습니다.',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: kFeedbackBlue,
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. 하단 컨트롤 영역 (피드백 카드 + 플레이어)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 피드백 레전드 카드
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: kCardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF473B54)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // 왼쪽: 피드백 종류
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '피드백',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildLegendItem(kFeedbackRed, '군말'),
                                const SizedBox(height: 8),
                                _buildLegendItem(kFeedbackBlue, '너무 느림'), // 디자인상 파랑이 느림
                                const SizedBox(height: 8),
                                _buildLegendItem(kFeedbackGreen, '너무 빠름'), // 디자인상 초록이 빠름
                              ],
                            ),
                          ),
                          // 오른쪽: Dismiss 버튼
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Dismiss',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 오디오 플레이어 컨트롤
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kCardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // 타이틀 및 시간
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Recording 01',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '00:15 / 01:30',
                                style: TextStyle(
                                  color: kTextGray,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 프로그레스 바 (Slider 커스텀)
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: kAccentPurple,
                              inactiveTrackColor: const Color(0xFF3F3F46),
                              thumbColor: Colors.transparent, // 썸을 숨기거나 작게
                              overlayShape: SliderComponentShape.noOverlay,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0), // 썸 숨김 스타일
                              trackHeight: 6.0,
                              trackShape: const RoundedRectSliderTrackShape(),
                            ),
                            child: Slider(
                              value: 0.16, // 약 15/90초 비율
                              onChanged: (v) {},
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 재생 버튼들
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCircleBtn(Icons.replay_10, size: 24), // 10초 뒤로
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                    color: kAccentPurple,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      )
                                    ]
                                ),
                                child: const Icon(Icons.pause, color: Colors.white, size: 28),
                              ),
                              _buildCircleBtn(Icons.forward_10, size: 24), // 10초 앞으로
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 팝업 다이얼로그 함수
  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // 배경 어둡게
      builder: (BuildContext context) {
        // 내부 상태(페이지 인덱스)를 관리하기 위해 StatefulBuilder 사용
        return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: const Color(0xFF2C2C2C), // 팝업 배경색 (진한 회색)
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                child: _FeedbackContent(),
              );
            }
        );
      },
    );
  }

  // 레전드 아이템 위젯
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: kTextDarkGray,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // 원형 버튼 위젯 (회색 배경)
  Widget _buildCircleBtn(IconData icon, {double size = 24}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF302839),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: size),
    );
  }
}

// 팝업 내부 콘텐츠를 관리하는 StatefulWidget
class _FeedbackContent extends StatefulWidget {
  @override
  State<_FeedbackContent> createState() => _FeedbackContentState();
}

class _FeedbackContentState extends State<_FeedbackContent> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 상단: 페이지네이션 점 + 닫기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 페이지네이션 점들
              Row(
                children: [
                  _buildDot(active: _pageIndex == 0),
                  const SizedBox(width: 4),
                  _buildDot(active: _pageIndex == 1),
                  const SizedBox(width: 4),
                  _buildDot(active: false),
                  const SizedBox(width: 4),
                  _buildDot(active: false),
                  const SizedBox(width: 4),
                  _buildDot(active: false),
                ],
              ),
              // 닫기 버튼
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. 타이틀 & 본문 (페이지에 따라 변경)
          if (_pageIndex == 0) ...[
            // [페이지 1: 경고]
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '[속도: 너무 빠름 ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '⚡',
                    style: TextStyle(fontSize: 14),
                  ),
                  TextSpan(
                    text: ']',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '이 구간의 말하기 속도가 평균보다 35% 빠릅니다. 중요한 내용이 잘 들리지 않을 수 있어요.',
              style: TextStyle(
                color: Color(0xFFD1D5DB),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ] else ...[
            // [페이지 2: 해결책]
            const Text(
              "[해결책 1: 의도적으로 '쉬어 가기']",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "말이 빨라지는 가장 큰 이유는 '쉼'이 부족하기 때문입니다. 문장이 끝나는 지점(.)이나 쉼표(,)에서 마음속으로 1초간 멈춘다고 생각하고 말해보세요. 청중에게 생각할 시간을 주게 되어 전달력이 높아집니다.",
              style: TextStyle(
                color: Color(0xFFD1D5DB),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 20),

          // 4. 하단 버튼: Skip / Next
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Skip Button
              OutlinedButton(
                onPressed: () {
                  // 1. 현재 팝업 닫기
                  Navigator.of(context).pop();

                  // 2. 새로운 화면으로 이동 (Navigation Push)
                  // '다른 .dart 파일'이라고 가정하고 새로운 화면 클래스(SkipDestinationScreen)로 이동합니다.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SpeechDetailedAnalysisScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4B5563)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              // Next Button
              ElevatedButton(
                onPressed: () {
                  if (_pageIndex == 0) {
                    setState(() {
                      _pageIndex = 1;
                    });
                  } else {
                    Navigator.of(context).pop(); // 마지막 페이지면 닫기
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool active}) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: active ? Colors.white : const Color(0xFF4B5563),
          width: 1,
        ),
      ),
    );
  }
}

// 텍스트 중간에 들어가는 'AI' 뱃지 위젯
class _TagBadge extends StatelessWidget {
  final String text;
  const _TagBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF3F3F46),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD1D5DB),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// 이동할 새로운 화면 (다른 .dart 파일이라고 가정)
class SkipDestinationScreen extends StatelessWidget {
  const SkipDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 일관된 디자인을 위해 Center + ConstrainedBox 구조 유지
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Scaffold(
          backgroundColor: const Color(0xFF191022),
          appBar: AppBar(
            backgroundColor: const Color(0xFF191022),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              // 뒤로 가기
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              '다음 단계',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: const Center(
            child: Text(
              'Skip 버튼을 눌러 이동한 화면입니다.\n다른 파일에 위치한 화면이라고 가정합니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFD1D5DB),
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}