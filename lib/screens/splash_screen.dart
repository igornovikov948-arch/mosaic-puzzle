import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _openAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: AppSizes.splashDuration,
      vsync: this,
    );

    _openAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    Future.delayed(AppSizes.splashDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: AppSizes.animMedium,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              AppColors.backgroundDark,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: 0.8 + (_openAnimation.value * 0.2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gold.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withOpacity(
                                0.3 * _openAnimation.value,
                              ),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 60,
                          color: AppColors.gold.withOpacity(
                            0.8 * _openAnimation.value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Mosaic',
                        style: TextStyle(
                          fontSize: 36,
                          color: AppColors.gold.withOpacity(
                            0.9 * _openAnimation.value,
                          ),
                          fontFamily: 'Handwritten',
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
