import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/utils/const/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final String _appName = "LearnFort Sports Park";
  late List<AnimationController> _letterControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _bounceAnimations;

  late AnimationController _logoController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;

  late AnimationController _bgController;
  late Animation<Color?> _bgAnimation1;
  late Animation<Color?> _bgAnimation2;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _logoController.forward();

    // Text animations
    _letterControllers = List.generate(
      _appName.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _fadeAnimations = _letterControllers
        .map(
          (controller) => Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn)),
        )
        .toList();

    _bounceAnimations = _letterControllers
        .map(
          (controller) =>
              Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: controller, curve: Curves.elasticOut),
              ),
        )
        .toList();

    // Stagger letters
    _startStaggeredTextAnimation();

    // Animated gradient background
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bgAnimation1 = ColorTween(
      begin: AppColors.iconColor,
      end: AppColors.iconLightColor,
    ).animate(_bgController);

    _bgAnimation2 = ColorTween(
      begin: const Color(0xFF191414),
      end: const Color(0xFF121212),
    ).animate(_bgController);

    // Navigate after 4 seconds
    Timer(const Duration(seconds: 8), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  void _startStaggeredTextAnimation() async {
    for (int i = 0; i < _letterControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _letterControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _bgController.dispose();
    for (var controller in _letterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_bgAnimation1.value!, _bgAnimation2.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo fade + scale
                  ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: Image.asset(
                        "assets/applogo.png",
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Premium text animation
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_appName.length, (index) {
                      return SlideTransition(
                        position: _bounceAnimations[index],
                        child: FadeTransition(
                          opacity: _fadeAnimations[index],
                          child: Text(
                            _appName[index],
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
