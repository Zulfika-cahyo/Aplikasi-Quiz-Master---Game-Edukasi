import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async'; // Untuk Timer delay

import '../providers/quiz_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/option_button.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _started = false;

  // 🎵 1. Inisialisasi Player
  final AudioPlayer _player = AudioPlayer();

  // State lokal untuk animasi jawaban
  bool _isAnswerLocked = false;
  String? _selectedOption;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      // Memulai kuis saat layar pertama kali dibuka
      context.read<QuizProvider>().start(widget.category);
      _started = true;
    }
  }

  // 🗑️ 2. PENTING: Dispose AudioPlayer untuk mencegah Memory Leak
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Fungsi memutar suara
  void _playSound(bool correct) async {
    try {
      await _player.stop(); // Hentikan suara sebelumnya jika ada
      await _player.play(
        AssetSource(correct ? 'sounds/correct.mp3' : 'sounds/wrong.mp3'),
        mode: PlayerMode.lowLatency,
        volume: 1.0,
      );
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  // Fungsi logika saat tombol ditekan
  void _handleAnswer(String option, String correctDetails) async {
    if (_isAnswerLocked) return;

    final quizProvider = context.read<QuizProvider>();

    // 🛑 STOP TIMER SEGERA!
    quizProvider.stopTimer();

    setState(() {
      _isAnswerLocked = true;
      _selectedOption = option;
    });

    bool isCorrect = option == correctDetails;
    _playSound(isCorrect);

    // ⏳ Tunggu animasi (1.5 detik)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return; // Cek apakah layar masih aktif

    // ✅ Submit jawaban
    quizProvider.answer(option);

    // Reset state lokal jika layar masih aktif
    if (mounted) {
      setState(() {
        _isAnswerLocked = false;
        _selectedOption = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    // Loading State
    if (quiz.loading || quiz.current == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    // Selesai Quiz
    if (quiz.finished) {
      Future.microtask(() {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(category: widget.category),
            ),
          );
        }
      });
      return const SizedBox
          .shrink(); // Tampilkan kosong saat proses pindah layar
    }

    final q = quiz.current!;

    // Hitung persentase waktu untuk Progress Bar
    // Pastikan menggunakan QuizProvider.questionDuration (Static) atau quiz.timeLeft
    double timerProgress = quiz.timeLeft / QuizProvider.questionDuration;

    return Scaffold(
      backgroundColor: AppTheme.background,

      // 🔹 Custom AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            // Menggunakan withOpacity agar kompatibel semua versi Flutter
            border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
          ),
          child: Text(
            'Soal ${quiz.index + 1} / ${quiz.questions.length}',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary),
          ),
        ),
      ),

      // 🔹 BODY dengan ScrollView agar tidak overflow di layar pendek
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            /// 🔹 TIMER & PROGRESS BAR
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppTheme.secondary),
                const SizedBox(width: 8),
                Text(
                  '${quiz.timeLeft}s',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: timerProgress,
                      minHeight: 8,
                      backgroundColor: AppTheme.surface,
                      valueColor: AlwaysStoppedAnimation(
                        quiz.timeLeft < 10 ? AppTheme.error : AppTheme.success,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            /// 🔹 KARTU SOAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 120),
                child: Center(
                  child: Text(
                    q.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// 🔹 OPSI JAWABAN
            ...q.shuffledOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final optionText = entry.value;
              final label = String.fromCharCode(65 + index); // 0->A, 1->B

              // Tentukan Status Tombol
              OptionState btnState = OptionState.neutral;

              if (_isAnswerLocked) {
                if (optionText == q.answer) {
                  btnState = OptionState.correct;
                } else if (optionText == _selectedOption) {
                  btnState = OptionState.wrong;
                } else {
                  btnState = OptionState.neutral;
                }
              }

              return OptionButton(
                label: label,
                text: optionText,
                state: btnState,
                onTap: _isAnswerLocked
                    ? null
                    : () => _handleAnswer(optionText, q.answer),
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
