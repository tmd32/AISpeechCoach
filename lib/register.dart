import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';

// Firebase (AuthService에서 이미 임포트하지만, User 타입을 위해)
import 'package:firebase_auth/firebase_auth.dart';

// 로컬 임포트
import 'pressable_button.dart';
import 'authservice.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // AuthService 및 폼 키
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // 텍스트 컨트롤러
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 상태 변수
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    // 컨트롤러 리소스 해제
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- 회원가입 처리 함수 ---
  void _handleRegister() async {
    // 1. 폼 유효성 검사
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // 2. 로딩 시작
    setState(() { _isLoading = true; });

    // 3. AuthService 호출
    final user = await _authService.createUserWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    // 4. 로딩 종료
    setState(() { _isLoading = false; });

    if (!mounted) return; // 위젯이 화면에서 사라진 경우

    // 5. 결과에 따른 피드백
    if (user != null) {
      // 성공
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 성공! ${user.email}님 환영합니다.')),
      );
      // 로그인 화면으로 돌아가기
      Navigator.pop(context);
    } else {
      // 실패
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패. 이미 사용 중인 이메일일 수 있습니다.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 375,
            height: 812, // 고정 높이 캔버스
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            // ▼▼▼ Form 위젯으로 Stack 감싸기 ▼▼▼
            child: Form(
              key: _formKey, // 폼 키 연결
              child: Stack(
                children: [
                  Positioned(
                    left: 61,
                    top: 765,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: const Color(0xFF032426),
                              fontSize: 15,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              height: 1.40,
                              letterSpacing: 0.15,
                            ),
                          ),
                          TextSpan(
                            text: 'Login Now',
                            style: TextStyle(
                              color: const Color(0xFF34C2C1),
                              fontSize: 15,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                              letterSpacing: 0.15,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // 로딩 중이 아닐 때만 뒤로가기
                                if (!_isLoading) {
                                  Navigator.pop(context);
                                }
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // --- Google, Facebook, Apple 버튼 ---
                  // (요청대로 기능은 빼고, 로딩 중 비활성화만 추가)
                  Positioned(
                    left: 135, // Google
                    top: 655,
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _isLoading ? null : () => debugPrint('Google Register Tapped'),
                        child: Container(
                          width: 105,
                          height: 56,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'icons/google_ic.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22, // Facebook
                    top: 655,
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _isLoading ? null : () => debugPrint('Facebook Register Tapped'),
                        child: Container(
                          width: 105,
                          height: 56,
                          alignment: Alignment.center,
                          child: FaIcon(
                            FontAwesomeIcons.facebookF,
                            color: Color(0xFF1877F2),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 248, // Apple
                    top: 655,
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _isLoading ? null : () => debugPrint('Apple Register Tapped'),
                        child: Container(
                          width: 105,
                          height: 56,
                          alignment: Alignment.center,
                          child: FaIcon(
                            FontAwesomeIcons.apple,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 137,
                    top: 616,
                    child: Text(
                      'Or Register with',
                      style: TextStyle(
                        color: const Color(0xFF6A707C),
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    top: 625,
                    child: Container(
                      width: 103,
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
                    left: 250,
                    top: 625,
                    child: Container(
                      width: 103,
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

                  // --- Register 버튼 ---
                  Positioned(
                    left: 22,
                    top: 525,
                    child: PressableButton(
                      width: 331,
                      height: 56,
                      borderRadius: BorderRadius.circular(8),
                      splashColor: Colors.white.withOpacity(0.1),
                      // ▼▼▼ 로딩 중이면 null, 아니면 _handleRegister 함수 호출 ▼▼▼
                      onTap: _isLoading ? null : _handleRegister,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF1E232C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        // ▼▼▼ 로딩 상태에 따라 위젯 변경 ▼▼▼
                        child: _isLoading
                            ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : Text(
                          'Register',
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

                  // --- 입력 필드 (TextFormField로 변경) ---
                  Positioned(
                    left: 22,
                    top: 439, // Confirm password
                    width: 331,
                    height: 56,
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        hintStyle: TextStyle(color: const Color(0xFF8390A1), fontSize: 15, fontFamily: 'Urbanist', fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: const Color(0xFFF6F7F8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: Color(0xFF8390A1),
                          ),
                          onPressed: () {
                            setState(() { _isConfirmPasswordVisible = !_isConfirmPasswordVisible; });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  Positioned(
                    left: 22,
                    top: 371, // Password
                    width: 331,
                    height: 56,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: const Color(0xFF8390A1), fontSize: 15, fontFamily: 'Urbanist', fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: const Color(0xFFF6F7F8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: Color(0xFF8390A1),
                          ),
                          onPressed: () {
                            setState(() { _isPasswordVisible = !_isPasswordVisible; });
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
                  Positioned(
                    left: 22,
                    top: 303, // Email
                    width: 331,
                    height: 56,
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: const Color(0xFF8390A1), fontSize: 15, fontFamily: 'Urbanist', fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: const Color(0xFFF7F8F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Positioned(
                    left: 22,
                    top: 235, // Username
                    width: 331,
                    height: 56,
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(color: const Color(0xFF8390A1), fontSize: 15, fontFamily: 'Urbanist', fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: const Color(0xFFF7F8F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1, color: const Color(0xFFE8ECF4))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.primary)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      // 참고: Username은 Firebase Auth 기본 함수에 포함되지 않습니다.
                      // 별도로 Firestore에 저장하거나 User의 displayName을 업데이트해야 합니다.
                    ),
                  ),

                  // --- 상단 텍스트 ---
                  Positioned(
                    left: 25,
                    top: 172,
                    child: SizedBox(
                      width: 331,
                      child: Text(
                        '회원가입하고 바로  시작해보세요',
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
                  Positioned(
                    left: 25,
                    top: 133,
                    child: SizedBox(
                      width: 331,
                      child: Text(
                        '반가워요!',
                        style: TextStyle(
                          color: const Color(0xFF1E232C),
                          fontSize: 30,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                          height: 1.30,
                          letterSpacing: -0.30,
                        ),
                      ),
                    ),
                  ),

                  // --- 뒤로가기 버튼 ---
                  Positioned(
                    left: 22,
                    top: 56,
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: const Color(0xFFE8ECF4)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          if (!_isLoading) { // 로딩 중이 아닐 때만 뒤로가기
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: 41,
                          height: 41,
                          alignment: Alignment.center,
                          child: FaIcon(
                            Icons.arrow_back_ios_new,
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
      ),
    );
  }
}