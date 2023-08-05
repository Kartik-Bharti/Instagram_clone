import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isanimating;
  final Duration duration;
  final VoidCallback? onend;
  final bool smallike;

  const LikeAnimation({
    super.key,
    required this.child,
    required this.isanimating,
    this.duration = const Duration(milliseconds: 400),
    this.onend,
    this.smallike = false,
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    scale = Tween<double>(begin: 1, end: 1.5).animate(animationController);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isanimating || oldWidget.isanimating) {
      startanimation();
    }
  }

  void startanimation() async {
    if (widget.isanimating || widget.smallike != true) {
      await animationController.forward();
      await animationController.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onend != null) {
        widget.onend!();
      }
    }
  }

  @override
  void dispose() {
    if (mounted) super.dispose();
    if (mounted) animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale, child: widget.child);
  }
}
