import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'reservation_provider.dart';

class GateCodeScreen extends ConsumerWidget {
  const GateCodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(reservationProvider);
    final code = r?.gateCode ?? '----';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your gate code'),
        backgroundColor: BrandColors.surface,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_open, color: BrandColors.accent, size: 56),
              const SizedBox(height: 20),
              Text('Unit ${r?.unitId ?? ''} is reserved',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Sent to you by text and email',
                  style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 48),
                decoration: BoxDecoration(
                  color: BrandColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: BrandColors.accent, width: 1.5),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    color: BrandColors.accent,
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Enter this code at the gate keypad to enter the facility.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
