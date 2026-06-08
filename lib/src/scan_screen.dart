import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'reservation_provider.dart';
import 'reservation_screen.dart';

/// QR entry point. A real build wires this to a camera scanner (mobile_scanner);
/// here a tap simulates decoding the unit sticker so the flow is demoable on a
/// simulator with no camera.
class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text('Northgate Self-Storage',
                  style: TextStyle(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Scan the QR sticker on your unit or the office sign',
                  style: TextStyle(color: Colors.white54, fontSize: 14)),
              const Spacer(),
              Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: BrandColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: BrandColors.accent, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.qr_code_2, size: 140, color: Colors.white24),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: CustomPaint(painter: _CornersPainter()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text('No app download required - opens from the QR link',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white38, fontSize: 13)),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: BrandColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ref.read(reservationProvider.notifier).scan('B-114');
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReservationScreen()),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan unit QR', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = BrandColors.accent
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    const len = 28.0;
    // Four L-shaped corner brackets.
    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), p);
    canvas.drawLine(const Offset(0, 0), const Offset(0, len), p);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - len, 0), p);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), p);
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), p);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - len), p);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - len, size.height), p);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - len), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
