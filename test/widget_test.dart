import 'package:flutter_test/flutter_test.dart';
import 'package:ayurspace_flutter/main.dart';

void main() {
  testWidgets('AyurSpace app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AyurSpaceApp());

    // Verify the app title or a key element exists
    expect(find.text('Good Morning'), findsOneWidget);
  });
}
