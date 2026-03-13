import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  static const Color _primary = Color(0xFF8B6FE8);
  static const Color _textPrimary = Color(0xFF241C3D);
  static const Color _textMuted = Color(0xFF6F648F);

  final _formKey = GlobalKey<FormState>();
  String? qrResult;
  Position? currentPosition;
  
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _prevTopicController = TextEditingController();
  final TextEditingController _expectedTopicController = TextEditingController();
  int _mood = 3; // Default Neutral

  bool _isScanning = true;

  @override
  void dispose() {
    _studentIdController.dispose();
    _studentNameController.dispose();
    _prevTopicController.dispose();
    _expectedTopicController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = position;
    });
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    if (qrResult == null || currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please scan QR and wait for GPS')),
      );
      return;
    }

    final data = {
      'type': 'check-in',
      'timestamp': DateTime.now().toIso8601String(),
      'qr_result': qrResult,
      'lat': currentPosition!.latitude,
      'lng': currentPosition!.longitude,
      'student_id': _studentIdController.text.trim(),
      'student_name': _studentNameController.text.trim(),
      'prev_topic': _prevTopicController.text.trim(),
      'expected_topic': _expectedTopicController.text.trim(),
      'mood': _mood,
    };

    await StorageService.saveRecord(data);
    final cloudSaved = await FirebaseService.saveRecord(data);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cloudSaved
                ? 'Check-in saved locally and synced to Firebase!'
                : 'Check-in saved locally. Firebase sync unavailable.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF4F0FF), Color(0xFFEDE4FF)],
              ),
            ),
          ),
          Positioned(
            top: -40,
            right: -60,
            child: _decorCircle(180, const Color(0x33FFFFFF)),
          ),
          Positioned(
            bottom: -50,
            left: -40,
            child: _decorCircle(170, const Color(0x2A8B6FE8)),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _glassCard(
                    child: Row(
                      children: [
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: const Color(0x1A8B6FE8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.bolt_rounded, color: _primary),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Before Class Check-in',
                                style: TextStyle(
                                  color: _textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Scan QR, capture location, and reflect',
                                style: TextStyle(
                                  color: _textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withValues(alpha: 0.9),
                      border: Border.all(color: const Color(0x59FFFFFF), width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x338B6FE8),
                          blurRadius: 26,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    height: 250,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: _isScanning
                          ? MobileScanner(
                              key: const ValueKey('scanner'),
                              onDetect: (capture) {
                                final List<Barcode> barcodes = capture.barcodes;
                                if (barcodes.isNotEmpty) {
                                  setState(() {
                                    qrResult = barcodes.first.rawValue;
                                    _isScanning = false;
                                  });
                                  _getLocation();
                                }
                              },
                            )
                          : Container(
                              key: const ValueKey('success'),
                              width: double.infinity,
                              color: const Color(0x1A8B6FE8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: _primary, size: 60),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'QR Scanned: $qrResult',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: _textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _glassCard(
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: _primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            currentPosition == null
                                ? 'Fetching GPS location...'
                                : 'Location: ${currentPosition!.latitude.toStringAsFixed(4)}, ${currentPosition!.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(color: _textMuted, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Student Info',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(_studentIdController, 'Student ID', Icons.badge_rounded),
                  const SizedBox(height: 14),
                  _buildTextField(_studentNameController, 'Student Name', Icons.person_rounded),
                  const SizedBox(height: 18),
                  const Text(
                    'Class Reflection Input',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(_prevTopicController, 'Previous Class Topic', Icons.history_rounded),
                  const SizedBox(height: 14),
                  _buildTextField(_expectedTopicController, 'Expected Topic Today', Icons.lightbulb_rounded),
                  const SizedBox(height: 14),
                  _glassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.sentiment_satisfied_alt_rounded, color: _primary),
                        const SizedBox(width: 12),
                        const Text(
                          'Mood',
                          style: TextStyle(color: _textMuted, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0x1A8B6FE8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$_mood / 5',
                            style: const TextStyle(
                              color: _primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _mood,
                              isExpanded: true,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              items: const [
                                DropdownMenuItem(value: 1, child: Text('1 - 😡 Very negative')),
                                DropdownMenuItem(value: 2, child: Text('2 - 🙁 Negative')),
                                DropdownMenuItem(value: 3, child: Text('3 - 😐 Neutral')),
                                DropdownMenuItem(value: 4, child: Text('4 - 🙂 Positive')),
                                DropdownMenuItem(value: 5, child: Text('5 - 😄 Very positive')),
                              ],
                              onChanged: (val) => setState(() => _mood = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _gradientButton(
                    icon: Icons.arrow_forward_rounded,
                    label: 'Submit Check-in',
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _glassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x59FFFFFF), width: 1.2),
      ),
      child: child,
    );
  }

  Widget _gradientButton({
    required String label,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9A80F7), Color(0xFF7D61DF)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x558B6FE8),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          icon: Icon(icon),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget _decorCircle(double size, Color color) {
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
