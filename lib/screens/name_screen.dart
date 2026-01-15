import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_theme.dart'; // Pastikan import theme yang tadi dibuat
import 'home_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _ctrl = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    // Listener untuk mengecek apakah input kosong atau tidak secara realtime
    _ctrl.addListener(() {
      setState(() {
        _isValid = _ctrl.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_isValid) return;

    // Simpan nama ke provider
    await context.read<UserProvider>().setName(_ctrl.text.trim());

    if (!mounted) return;

    // Navigasi ke Home dengan animasi fade
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil dimensi layar
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.background, // Konsisten dengan Theme
      body: GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // Tutup keyboard saat tap background
        child: SingleChildScrollView(
          // Agar tidak error overflow saat keyboard muncul
          child: SizedBox(
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🔹 LOGO / ICON HEADER
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 10,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        size: 64,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 🔹 JUDUL & SUBJUDUL
                  const Text(
                    "Selamat Datang!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Siapa nama panggilanmu?",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// 🔹 TEXT FIELD INPUT
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _ctrl,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Ketik namamu...",
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.3)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        // Tombol Clear (muncul jika ada teks)
                        suffixIcon: _isValid
                            ? IconButton(
                                icon:
                                    const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () => _ctrl.clear(),
                              )
                            : null,
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// 🔹 TOMBOL LANJUT
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          _isValid ? _submit : null, // Disable jika kosong
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        disabledBackgroundColor:
                            AppTheme.surface.withOpacity(0.5),
                        elevation: _isValid ? 8 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadowColor: AppTheme.primary.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Mulai Petualangan 🚀',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Footer kecil (Opsional)
                  const SizedBox(height: 24),
                  Text(
                    "Quiz Master Develop By Zulfika Cahyodiputro",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.2),
                      fontSize: 12,
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
