import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart'; // TapGestureRecognizer를 위해 추가
import 'register.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';

// 로컬 임포트
import 'pressable_button.dart';
import 'authservice.dart'; // AuthService 임포트

// StatelessWidget을 StatefulWidget으로 변경
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // AuthService 인스턴스 생성
  final _authService = AuthService();

  // 폼 관리를 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();

  // 텍스트 입력을 위한 컨트롤러
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 상태 관리 변수
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // 컨트롤러 리소스 해제
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 이메일/비밀번호 로그인 처리
  void _handleEmailLogin() async {
    // 폼 유효성 검사
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() { _isLoading = true; });

    final user = await _authService.loginUserWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    setState(() { _isLoading = false; });

    if (!mounted) return; // 위젯이 unmount된 경우 Ticker 에러 방지

    if (user != null) {
      // 로그인 성공
      print('Login Successful! Welcome ${user.email}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful! Welcome ${user.email}')),
      );
      // TODO: 홈 화면으로 이동
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      // 로그인 실패
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed. Please check your credentials.')),
      );
    }
  }

  // 구글 로그인 처리
  void _handleGoogleLogin() async {
    setState(() { _isLoading = true; });

    final userCredential = await _authService.loginWithGoogle();

    setState(() { _isLoading = false; });

    if (!mounted) return; // 위젯이 unmount된 경우 Ticker 에러 방지

    if (userCredential != null && userCredential.user != null) {
      print('Google Login Successful! Welcome ${userCredential.user!.displayName}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Login Successful! Welcome ${userCredential.user!.displayName}')),
      );
      // TODO: 홈 화면으로 이동
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Login Failed.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // 1. Scaffold를 반환 (Material 위젯 문제를 해결)
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 지정
      // 2. 스크롤이 가능하도록 SingleChildScrollView 추가 (Overflow 문제 해결)
      body: SingleChildScrollView(
        // 3. 고정 너비 컨테이너를 가운데 정렬하기 위해 Center 추가 (왼쪽 쏠림 해결)
        child: Center(
          child: Container(
            width: 390,
            height: 844, // 피그마 디자인 기준 고정 높이
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            // Stack을 Form으로 감싸기
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                Positioned(
                left: 61,
                top: 765,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don’t have an account? ',
                        style: TextStyle(
                          color: const Color(0xFF24282C),
                          fontSize: 15,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                          height: 1.40,
                          letterSpacing: 0.15,
                        ),
                      ),
                      TextSpan(
                        text: 'Register Now',
                        style: TextStyle(
                          color: const Color(0xFF34C2C1),
                          fontSize: 15,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                          height: 1.40,
                          letterSpacing: 0.15,
                        ),
                        // 클릭 이벤트 추가
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            debugPrint('Navigate to Register');
                            // TODO: 회원가입 화면으로 이동
                             Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // --- Google 로그인 버튼 ---
            Positioned(
              left: 142,
              top: 557,
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _isLoading ? null : _handleGoogleLogin,
                  child: Container(
                    width: 105,
                    height: 56,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'icons/google_ic.svg', // pubspec.yaml에 assets/icons/ 등록 확인
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ),

            // --- Facebook 로그인 버튼 ---
            Positioned(
              left: 29,
              top: 557,
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _isLoading ? null : () => debugPrint('Facebook login tapped'),
                  child: Container(
                    width: 105,
                    height: 56,
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.facebookF,
                      size: 24,
                      color: Color(0xFF1877F2),
                    ),
                  ),
                ),
              ),
            ),

            // --- Apple 로그인 버튼 ---
            Positioned(
              left: 255,
              top: 557,
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _isLoading ? null : () => debugPrint('Apple login tapped'),
                  child: Container(
                    width: 105,
                    height: 56,
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.apple,
                      size: 26,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 153,
              top: 518,
              child: Text(
                'Or Login with',
                style: TextStyle(
                  color: const Color(0xFF6A707C),
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              left: 29,
              top: 527,
              child: Container(
                width: 112,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xFFE8ECF4),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 249,
              top: 527,
              child: Container(
                width: 111,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xFFE8ECF4),
                    ),
                  ),
                ),
              ),
            ),

            // --- 이메일 로그인 버튼 ---
            Positioned(
              left: 22.88,
              top: 424.71,
              child: PressableButton(
                width: 344.24,
                height: 58.21,
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.white.withOpacity(0.1),
                onTap: _isLoading ? null : _handleEmailLogin, // 핸들러 연결
                child: Container(
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1E232C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // --- 비밀번호 찾기 ---
            Positioned(
              left: 242,
              top: 377,
              child: GestureDetector(
                onTap: _isLoading ? null : () => debugPrint('Forgot Password tapped'),
                child: Text(
                  'Forgot Password?',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF6A707C),
                    fontSize: 14,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // --- 비밀번호 입력 필드 ---
            Positioned(
              left: 26,
              top: 306,
              width: 331, // 너비와 높이를 직접 지정
              height: 56,
              child: TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // 비밀번호 숨기기
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(
                    color: const Color(0xFF8390A1),
                    fontSize: 15,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF6F7F8),
                  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary),
                  ),
                  // 비밀번호 보이기/숨기기 아이콘
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF8390A1),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),

            // --- 이메일 입력 필드 ---
            Positioned(
              left: 26,
              top: 235,
              width: 331, // 너비와 높이를 직접 지정
              height: 56,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: const Color(0xFF8390A1),
                    fontSize: 15,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF7F8F9),
                  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                  ),
                  // ▼▼▼▼▼ 오타 수정 ▼▼▼▼▼ (EnabledBorder -> enabledBorder)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                  ),
                  // ▲▲▲▲▲ 수정 완료 ▲▲▲▲▲
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },

              ),
            ),

            // --- 상단 텍스트 ---
            Positioned(
              left: 29,
              top: 128,
              child: SizedBox(
                width: 315,
                child: Text(
                  '다시 만나서 반가워요!',
                  style: TextStyle(
                    color: const Color(0xFF1E232C),
                    fontSize: 32,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 29,
              top: 170,
              child: SizedBox(
                width: 300,
                child: Text(
                  '오늘도 멋진 스피치를 위해 함께해요.',
                  style: TextStyle(
                    color: const Color(0xFF1E232C),
                    fontSize: 20,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w500,
                    height: 1.30,
                    letterSpacing: -0.20,
                  ),
                ),
              ),
            ),

            // --- 뒤로가기 버튼 ---
            Positioned(
              left: 22,
              top: 56,
              // 뒤로가기 버튼 배경을 Material/InkWell로 감싸서 클릭 가능하게
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 41,
                    height: 41,
                    alignment: Alignment.center,
                    child: FaIcon(
                      Icons.arrow_back_ios_new, // 아이콘 변경 (더 적절함)
                      size: 20,
                      color: Color(0xFF1E232C),
                    ),
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    ),
    )
    );
  }
}