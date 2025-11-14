// 파일 위치: lib/widgets/pressable_button.dart

import 'package:flutter/material.dart'; // 이거 필수!

// PressableButton: 누를 때 scale 애니메이션과 InkWell 잉크 효과 제공
class PressableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Duration duration;

  const PressableButton({
    super.key,
    required this.child,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.splashColor,
    this.duration = const Duration(milliseconds: 80),
  });

  @override
  State<PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (mounted) {
      setState(() {
        _pressed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: Ink(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
          ),
          child: InkWell(
            borderRadius: widget.borderRadius,
            splashColor: widget.splashColor,
            onTap: widget.onTap,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}