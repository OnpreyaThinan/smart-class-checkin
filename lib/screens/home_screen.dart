import 'package:flutter/material.dart';
import 'checkin_screen.dart';
import 'finish_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _primary = Color(0xFF8B6FE8);
  static const Color _textPrimary = Color(0xFF241C3D);
  static const Color _textMuted = Color(0xFF746896);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF4F0FF), Color(0xFFEFE9FF), Color(0xFFE6DBFF)],
              ),
            ),
          ),
          Positioned(
            top: -70,
            left: -40,
            child: _glowCircle(190, const Color(0x77FFFFFF)),
          ),
          Positioned(
            right: -55,
            bottom: 80,
            child: _glowCircle(220, const Color(0x4D8B6FE8)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF7F4FF), Color(0xFFE1D4FF)],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x408B6FE8),
                          blurRadius: 24,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.school_rounded, size: 74, color: _primary),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Smart Class',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check-in and learning reflection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _textMuted,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  _buildMenuButton(
                    context,
                    'Check-in',
                    Icons.qr_code_scanner_rounded,
                    const Color(0xFF8B6FE8),
                    Colors.white,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckInScreen())),
                  ),
                  const SizedBox(height: 14),
                  _buildMenuButton(
                    context,
                    'Finish Class',
                    Icons.assignment_turned_in_rounded,
                    Colors.white.withValues(alpha: 0.84),
                    _textPrimary,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FinishScreen())),
                    isSecondary: true,
                  ),
                  const SizedBox(height: 34),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String label,
    IconData icon,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed, {
    bool isSecondary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: isSecondary ? 0 : 8,
          shadowColor: isSecondary ? Colors.transparent : const Color(0x668B6FE8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: isSecondary ? const BorderSide(color: Color(0x50FFFFFF), width: 1.4) : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
