# Screenshot capture flow

Real captures from the iOS Simulator via an integration-test driver (no mockups).

## Steps

1. Boot the simulator:
   ```bash
   xcrun simctl boot "iPhone 17 Pro"
   open -a Simulator
   ```
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Drive the screenshot test:
   ```bash
   flutter drive \
     --driver test_driver/integration_test.dart \
     --target integration_test/screenshot_test.dart \
     -d "iPhone 17 Pro"
   ```

PNGs are written to `screenshots/` and embedded in `README.md`.

## How it works

- `test_driver/integration_test.dart` - `integrationDriver(onScreenshot:)` writes each PNG to `screenshots/<name>.png`.
- `integration_test/screenshot_test.dart` - pumps the app, drives the QR scan -> lease e-signature -> payment -> gate-code flow, and calls `binding.convertFlutterSurfaceToImage()` + `binding.takeScreenshot('NN-name')` at each key screen.
- The signature is captured with `tester.drag` over the signature pad; payment and release are tapped to advance the reservation state machine.
