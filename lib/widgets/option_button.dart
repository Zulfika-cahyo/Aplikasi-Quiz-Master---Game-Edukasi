import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

enum OptionState { neutral, selected, correct, wrong }

class OptionButton extends StatelessWidget {
  final String text;
  final String label;
  final OptionState state;
  final VoidCallback? onTap;

  const OptionButton({
    super.key,
    required this.text,
    required this.label,
    required this.state,
    required this.onTap,
  });

  Color _getBackgroundColor() {
    switch (state) {
      case OptionState.correct:
        // ✅ Ganti withOpacity -> withValues(alpha: ...)
        return AppTheme.success.withValues(alpha: 0.2);
      case OptionState.wrong:
        return AppTheme.error.withValues(alpha: 0.2);
      case OptionState.selected:
        return AppTheme.primary.withValues(alpha: 0.2);
      case OptionState.neutral:
        // ❌ Default dihapus karena semua case sudah tertangani
        return AppTheme.surface;
    }
  }

  Color _getBorderColor() {
    switch (state) {
      case OptionState.correct:
        return AppTheme.success;
      case OptionState.wrong:
        return AppTheme.error;
      case OptionState.selected:
        return AppTheme.primary;
      case OptionState.neutral:
        // ❌ Default dihapus
        return Colors.transparent;
    }
  }

  Widget? _getIcon() {
    if (state == OptionState.correct) {
      return const Icon(Icons.check_circle, color: AppTheme.success);
    } else if (state == OptionState.wrong) {
      return const Icon(Icons.cancel, color: AppTheme.error);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getBorderColor(),
            width: 2,
          ),
          boxShadow: state == OptionState.neutral
              ? []
              : [
                  BoxShadow(
                    // ✅ Ganti withOpacity -> withValues
                    color: _getBorderColor().withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              // ✅ Ganti withOpacity -> withValues
              splashColor: AppTheme.primary.withValues(alpha: 0.2),
              highlightColor: AppTheme.primary.withValues(alpha: 0.1),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // LABEL (A, B, C, D)
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: state == OptionState.neutral
                            // ✅ Ganti withOpacity -> withValues
                            ? Colors.white.withValues(alpha: 0.1)
                            : _getBorderColor(),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: state == OptionState.neutral
                              ? Colors.white70
                              : Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // TEKS JAWABAN
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: state == OptionState.selected
                              ? Colors.white
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),

                    // IKON FEEDBACK
                    if (_getIcon() != null) ...[
                      const SizedBox(width: 8),
                      _getIcon()!,
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
