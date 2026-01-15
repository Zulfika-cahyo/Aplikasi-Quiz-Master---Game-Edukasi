import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/score_provider.dart';
import '../utils/app_theme.dart'; // Pastikan import ini ada

class ResultScreen extends StatefulWidget {
  final String category;
  const ResultScreen({super.key, required this.category});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Update score ke database/provider saat masuk screen
    final quiz = context.read<QuizProvider>();
    Future.microtask(() {
      context.read<ScoreProvider>().update(widget.category, quiz.score);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper untuk menentukan warna & pesan berdasarkan skor
  Map<String, dynamic> _getResultStyle(int score) {
    if (score >= 9) {
      return {
        'color': AppTheme.success,
        'title': 'Sempurna! 🏆',
        'desc': 'Kamu benar-benar menguasai topik ini!',
        'icon': Icons.emoji_events,
      };
    } else if (score >= 6) {
      return {
        'color': const Color(0xFFFFAB40), // Orange
        'title': 'Kerja Bagus! 👍',
        'desc': 'Hasil yang memuaskan, tingkatkan lagi!',
        'icon': Icons.thumb_up,
      };
    } else {
      return {
        'color': AppTheme.error,
        'title': 'Jangan Menyerah 💪',
        'desc': 'Ayo belajar lagi dan coba kuis ini nanti.',
        'icon': Icons.school,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final score = quiz.score;
    final style = _getResultStyle(score);
    final themeColor = style['color'] as Color;

    return Scaffold(
      backgroundColor: AppTheme.background, // Tema Gelap
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 1️⃣ KARTU HASIL UTAMA
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 40),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ikon Header
                        Icon(
                          style['icon'],
                          size: 48,
                          color: themeColor,
                        ),
                        const SizedBox(height: 16),

                        // Judul
                        Text(
                          style['title'],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Deskripsi
                        Text(
                          style['desc'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Lingkaran Skor (Progress Indicator)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background lingkaran redup
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 12,
                                color: themeColor.withValues(alpha: 0.1),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            // Lingkaran progress animasi
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: score / 10),
                                duration: const Duration(seconds: 2),
                                curve: Curves.easeOutQuart,
                                builder: (context, value, _) =>
                                    CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 12,
                                  color: themeColor,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ),
                            // Teks Angka di tengah
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$score',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1,
                                    shadows: [
                                      Shadow(
                                        color:
                                            themeColor.withValues(alpha: 0.5),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                ),
                                const Text(
                                  'dari 10',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 2️⃣ TOMBOL AKSI (Fade In)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Tombol Utama (Kembali ke Home)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor:
                                AppTheme.primary.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.popUntil(context, (r) => r.isFirst);
                          },
                          child: const Text(
                            'Selesai & Kembali',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tombol Sekunder (Share / Detail - Optional)
                      TextButton.icon(
                        onPressed: () {
                          // Opsional: Bisa arahkan ke Review Jawaban jika ada fitur itu
                          // Untuk sekarang, kita restart kuis saja
                          // Navigator.pop(context); // Ini akan restart jika stack sebelumnya Quiz
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Fitur Share segera hadir!"),
                              backgroundColor: AppTheme.surface,
                            ),
                          );
                        },
                        icon: const Icon(Icons.share_rounded,
                            color: Colors.white70),
                        label: const Text(
                          'Bagikan Nilai',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
