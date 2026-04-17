import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

// TELA DE SPLASH COM ANIMACAO DE DOMINO E EFEITO CRT SCANLINE
class DominoSplashScreen extends StatefulWidget {
  const DominoSplashScreen({Key? key}) : super(key: key);

  @override
  State<DominoSplashScreen> createState() => _DominoSplashScreenState();
}

class _DominoSplashScreenState extends State<DominoSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  
  final int _numberOfSlices = 30; 

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _animations = List.generate(_numberOfSlices, (index) {
      double start = (index / _numberOfSlices) * 0.8;
      double end = math.min(start + 0.2, 1.0);
      
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeInOut),
      );
    });

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        final user = FirebaseAuth.instance.currentUser;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => user != null ? const HomeScreen() : const LoginScreen(),
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LOGO CENTRALIZADA COM ANIMACAO DOMINO
          Center(
            child: SizedBox(
              width: 250, 
              height: 250,
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Stack(
                        children: List.generate(_numberOfSlices, (index) {
                          return AnimatedBuilder(
                            animation: _animations[index],
                            builder: (context, child) {
                              return Opacity(
                                opacity: _animations[index].value,
                                child: ClipRect(
                                  clipper: _HorizontalSliceClipper(index, _numberOfSlices),
                                  child: Image.asset(
                                    'assets/logo-dark.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      );
                    },
                  ),
                  
                  // EFEITO CRT SCANLINE 
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: const Alignment(0, -0.98), 
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3), 
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            tileMode: TileMode.repeated,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalSliceClipper extends CustomClipper<Rect> {
  final int index;
  final int totalSlices;

  _HorizontalSliceClipper(this.index, this.totalSlices);

  @override
  Rect getClip(Size size) {
    double sliceHeight = size.height / totalSlices;
    return Rect.fromLTWH(
      0,                  
      sliceHeight * index, 
      size.width,         
      sliceHeight,        
    );
  }

  @override
  bool shouldReclip(_HorizontalSliceClipper oldClipper) => oldClipper.index != index;
}