// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:elsadeken/core/routes/app_routing.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:elsadeken/main.dart';

void main() {
  testWidgets('Test Elsadeken main', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(Elsadeken(appRouting: AppRouting()));

    // Wait for initial frame
    await tester.pump();

    // Fast-forward time by 3 seconds
    await tester.pump(const Duration(seconds: 3));
  });
}
