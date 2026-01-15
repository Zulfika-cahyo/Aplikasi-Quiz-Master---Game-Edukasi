import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/score_provider.dart';
import '../utils/app_theme.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final score = context.watch<ScoreProvider>();

    // Data Kategori
    final quizCategories = [
      {
        'name': 'Umum',
        'id': 'general',
        'icon': Icons.public,
        'color': const Color(0xFF448AFF)
      },
      {
        'name': 'Kebangsaan',
        'id': 'nationality',
        'icon': Icons.flag,
        'color': const Color(0xFFFF5252)
      },
      {
        'name': 'Matematika',
        'id': 'math',
        'icon': Icons.calculate,
        'color': const Color(0xFFFFAB40)
      },
      {
        'name': 'B. Inggris',
        'id': 'english',
        'icon': Icons.language,
        'color': const Color(0xFF69F0AE)
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          // Membatasi lebar agar rapi di Web/Desktop
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1️⃣ HEADER
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hai, ${user.name} 👋',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Siap memecahkan rekor hari ini?',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primary),
                          ),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.surface,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 2️⃣ STATISTIK (Fixed Overflow)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Text(
                      "Statistik Kamu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    // ⚠️ Ditinggikan jadi 135 agar tidak overflow
                    height: 135,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: quizCategories.length,
                      itemBuilder: (context, index) {
                        final item = quizCategories[index];
                        final currentScore =
                            score.getScore(item['id'] as String).highScore;
                        final color = item['color'] as Color;

                        return Container(
                          width: 130, // Lebar kartu statistik
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Mengatur jarak antar elemen secara otomatis
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(item['icon'] as IconData,
                                      size: 20, color: color),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item['name'] as String,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Angka Skor Besar
                              Text(
                                '$currentScore',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              const Text(
                                'Poin Tertinggi',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// 3️⃣ GRID MENU (Compact & Balanced)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mulai Kuis",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: quizCategories.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            // Rasio lebar:tinggi diperbaiki agar tidak terlalu gepeng/tinggi
                            childAspectRatio: 1.1,
                          ),
                          itemBuilder: (context, i) {
                            final c = quizCategories[i];
                            final categoryId = c['id'] as String;
                            final highScore =
                                score.getScore(categoryId).highScore;
                            final color = c['color'] as Color;

                            return Material(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(24),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          QuizScreen(category: categoryId),
                                    ),
                                  );
                                },
                                splashColor: color.withValues(alpha: 0.1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: color.withValues(alpha: 0.2),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        color.withValues(alpha: 0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Icon dalam lingkaran
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(c['icon'] as IconData,
                                            color: color, size: 24),
                                      ),

                                      // Info Text
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c['name'] as String,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            highScore == 0
                                                ? 'Belum dimainkan'
                                                : 'Skor: $highScore/10',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
