import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_storage_gate_access/src/app.dart';
import 'package:flutter_storage_gate_access/src/signature_pad.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  testWidgets('capture storage gate flow', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: StorageGateApp()));
    await tester.pumpAndSettle();
    await shoot(tester, '01-scan');

    // Scan the unit QR -> reservation flow.
    await tester.tap(find.text('Scan unit QR'));
    await tester.pumpAndSettle();

    // Sign the lease (drag across the signature pad) and pay.
    await tester.drag(find.byType(SignaturePad), const Offset(120, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Pay first month'));
    await tester.pumpAndSettle();
    await shoot(tester, '02-reservation');

    // Release the now-unlocked gate code.
    await tester.tap(find.text('Release gate code'));
    await tester.pumpAndSettle();
    await shoot(tester, '03-gatecode');
  });
}
