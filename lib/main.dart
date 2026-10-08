import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuickTapGameApp());
}

class QuickTapGameApp extends StatelessWidget {
  const QuickTapGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caza el Círculo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int timeLeft = 30;
  bool isPlaying = false;
  double targetX = 0.5;
  double targetY = 0.5;
  Timer? timer;
  final Random random = Random();

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      isPlaying = true;
      moveTarget();
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 1) {
        setState(() {
          timeLeft--;
        });
      } else {
        t.cancel();
        setState(() {
          timeLeft = 0;
          isPlaying = false;
        });
      }
    });
  }

  void moveTarget() {
    setState(() {
      targetX = 0.1 + random.nextDouble() * 0.8;
      targetY = 0.1 + random.nextDouble() * 0.7;
    });
  }

  void onTargetTap() {
    if (!isPlaying) return;
    setState(() {
      score++;
      moveTarget();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caza el Círculo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Puntos: $score',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Tiempo: ${timeLeft}s',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent)),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      if (!isPlaying && timeLeft == 30)
                        Center(
                          child: ElevatedButton(
                            onPressed: startGame,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                            child: const Text('Iniciar Juego',
                                style: TextStyle(fontSize: 20)),
                          ),
                        )
                      else if (!isPlaying && timeLeft == 0)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¡Tiempo Agotado!\nPuntaje final: $score',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: startGame,
                                child: const Text('Jugar de Nuevo',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                      if (isPlaying)
                        Positioned(
                          left: targetX * (constraints.maxWidth - 60),
                          top: targetY * (constraints.maxHeight - 60),
                          child: GestureDetector(
                            onTap: onTargetTap,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.cyanAccent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.cyan,
                                      blurRadius: 12,
                                      spreadRadius: 2),
                                ],
                              ),
                              child: const Icon(Icons.touch_app,
                                  color: Colors.black, size: 30),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}