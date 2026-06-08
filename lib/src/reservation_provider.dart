import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The reservation moves through these steps. The gate code is only ever
/// generated and revealed once lease + payment (+ optional admin approval) pass.
enum ReservationStep { scanned, details, lease, payment, approval, released }

@immutable
class Reservation {
  const Reservation({
    required this.unitId,
    required this.facility,
    required this.monthlyPrice,
    this.customerName = '',
    this.leaseSigned = false,
    this.paid = false,
    this.adminApprovalRequired = false,
    this.adminApproved = false,
    this.gateCode,
  });

  final String unitId;
  final String facility;
  final double monthlyPrice;
  final String customerName;
  final bool leaseSigned;
  final bool paid;
  final bool adminApprovalRequired;
  final bool adminApproved;
  final String? gateCode;

  /// Gate code stays hidden until every gating condition is satisfied.
  bool get canReleaseGateCode =>
      leaseSigned && paid && (!adminApprovalRequired || adminApproved);

  ReservationStep get step {
    if (gateCode != null) return ReservationStep.released;
    if (!leaseSigned) return ReservationStep.lease;
    if (!paid) return ReservationStep.payment;
    if (adminApprovalRequired && !adminApproved) return ReservationStep.approval;
    return ReservationStep.payment;
  }

  Reservation copyWith({
    String? customerName,
    bool? leaseSigned,
    bool? paid,
    bool? adminApproved,
    String? gateCode,
  }) {
    return Reservation(
      unitId: unitId,
      facility: facility,
      monthlyPrice: monthlyPrice,
      customerName: customerName ?? this.customerName,
      leaseSigned: leaseSigned ?? this.leaseSigned,
      paid: paid ?? this.paid,
      adminApprovalRequired: adminApprovalRequired,
      adminApproved: adminApproved ?? this.adminApproved,
      gateCode: gateCode ?? this.gateCode,
    );
  }
}

final reservationProvider =
    NotifierProvider<ReservationNotifier, Reservation?>(ReservationNotifier.new);

class ReservationNotifier extends Notifier<Reservation?> {
  @override
  Reservation? build() => null;

  /// Simulates decoding a QR sticker on a unit / office sign.
  void scan(String unitId) {
    state = Reservation(
      unitId: unitId,
      facility: 'Northgate Self-Storage',
      monthlyPrice: 89.0,
      adminApprovalRequired: false,
    );
  }

  void setCustomerName(String name) {
    final r = state;
    if (r != null) state = r.copyWith(customerName: name);
  }

  void signLease() {
    final r = state;
    if (r != null) state = r.copyWith(leaseSigned: true);
  }

  void markPaid() {
    final r = state;
    if (r != null) state = r.copyWith(paid: true);
  }

  void approveByAdmin() {
    final r = state;
    if (r != null) state = r.copyWith(adminApproved: true);
  }

  /// Releases the gate code only when all conditions pass. Returns the code, or
  /// null if still gated.
  String? releaseGateCode() {
    final r = state;
    if (r == null || !r.canReleaseGateCode) return null;
    final code = (1000 + Random().nextInt(9000)).toString();
    state = r.copyWith(gateCode: code);
    return code;
  }

  void reset() => state = null;
}
