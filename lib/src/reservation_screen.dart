import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'gate_code_screen.dart';
import 'reservation_provider.dart';
import 'signature_pad.dart';

class ReservationScreen extends ConsumerWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(reservationProvider);
    final notifier = ref.read(reservationProvider.notifier);
    if (r == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit ${r.unitId}'),
        backgroundColor: BrandColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _UnitCard(unitId: r.unitId, facility: r.facility, price: r.monthlyPrice),
          const SizedBox(height: 20),
          const _SectionTitle('1 · Your details'),
          const SizedBox(height: 8),
          TextField(
            onChanged: notifier.setCustomerName,
            style: const TextStyle(color: Colors.white),
            decoration: _input('Full name', Icons.person_outline),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('2 · Sign lease agreement'),
          const SizedBox(height: 8),
          SignaturePad(
            onChanged: (signed) {
              if (signed && !r.leaseSigned) notifier.signLease();
            },
          ),
          const SizedBox(height: 12),
          const _SectionTitle('3 · Payment'),
          const SizedBox(height: 8),
          _PayRow(
            paid: r.paid,
            price: r.monthlyPrice,
            onPay: notifier.markPaid,
          ),
          const SizedBox(height: 24),
          _GateStatus(reservation: r),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor:
                  r.canReleaseGateCode ? BrandColors.accent : Colors.white12,
              foregroundColor: r.canReleaseGateCode ? Colors.black : Colors.white38,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: r.canReleaseGateCode
                ? () {
                    notifier.releaseGateCode();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GateCodeScreen()),
                    );
                  }
                : null,
            icon: const Icon(Icons.lock_open),
            label: const Text('Release gate code', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  InputDecoration _input(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white38),
        filled: true,
        fillColor: BrandColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600));
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({required this.unitId, required this.facility, required this.price});
  final String unitId;
  final String facility;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A2A), Color(0xFF18211C)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: BrandColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.warehouse, color: BrandColors.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Unit $unitId · 10x10',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                Text(facility, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
          Text('\$${price.toStringAsFixed(0)}/mo',
              style: const TextStyle(
                  color: BrandColors.accent, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  const _PayRow({required this.paid, required this.price, required this.onPay});
  final bool paid;
  final double price;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    if (paid) {
      return Row(
        children: const [
          Icon(Icons.check_circle, color: BrandColors.accent),
          SizedBox(width: 8),
          Text('Payment received', style: TextStyle(color: Colors.white)),
        ],
      );
    }
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: BrandColors.accent),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      ),
      onPressed: onPay,
      icon: const Icon(Icons.credit_card),
      label: Text('Pay first month - \$${price.toStringAsFixed(0)}'),
    );
  }
}

class _GateStatus extends StatelessWidget {
  const _GateStatus({required this.reservation});
  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrandColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _check('Lease signed', r.leaseSigned),
          const SizedBox(height: 10),
          _check('Payment received', r.paid),
          if (r.adminApprovalRequired) ...[
            const SizedBox(height: 10),
            _check('Admin approval', r.adminApproved),
          ],
          const Divider(color: Colors.white12, height: 24),
          Row(
            children: [
              Icon(r.canReleaseGateCode ? Icons.lock_open : Icons.lock,
                  color: r.canReleaseGateCode ? BrandColors.accent : BrandColors.warn, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  r.canReleaseGateCode
                      ? 'Gate code unlocked - ready to release'
                      : 'Gate code is hidden until lease + payment complete',
                  style: TextStyle(
                      color: r.canReleaseGateCode ? BrandColors.accent : Colors.white60,
                      fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _check(String label, bool done) {
    return Row(
      children: [
        Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? BrandColors.accent : Colors.white24, size: 20),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(color: done ? Colors.white : Colors.white54, fontSize: 14)),
      ],
    );
  }
}
