import 'package:flutter/material.dart';

import 'app.dart';

/// Lightweight lease e-signature pad - captures stroke points with a
/// GestureDetector and renders them via CustomPainter. No third-party plugin.
class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key, required this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final List<Offset?> _points = <Offset?>[];

  void _add(Offset? p) {
    setState(() => _points.add(p));
    widget.onChanged(_points.any((e) => e != null));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onPanStart: (d) => _add(d.localPosition),
            onPanUpdate: (d) => _add(d.localPosition),
            onPanEnd: (_) => _add(null),
            child: CustomPaint(
              painter: _SignaturePainter(_points),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              setState(_points.clear);
              widget.onChanged(false);
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Clear'),
          ),
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.points);
  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = BrandColors.background
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      if (a != null && b != null) canvas.drawLine(a, b, p);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
