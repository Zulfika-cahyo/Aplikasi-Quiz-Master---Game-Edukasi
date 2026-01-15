import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ✅ Pastikan path import ini sesuai dengan struktur foldermu
import 'utils/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/score_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  // Wajib ada jika menggunakan async di main atau inisialisasi binding sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 🔹 UserProvider diinisialisasi polosan saja.
        // Loading data dilakukan di SplashScreen agar ada indikator loading visual.
        ChangeNotifierProvider(create: (_) => UserProvider()),

        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ScoreProvider()),
      ],
      child: MaterialApp(
        title: 'Quiz Master', // Judul aplikasi (muncul di Recent Apps)
        debugShowCheckedModeBanner: false,

        // 🎨 Menerapkan Tema Gelap Modern kita
        theme: AppTheme.dark,

        // Halaman awal
        home: const SplashScreen(),
      ),
    );
  }
}
