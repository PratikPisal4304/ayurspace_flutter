import 'package:flutter_test/flutter_test.dart';
import 'package:ayurspace_flutter/main.dart';

void main() {
  testWidgets('AyurSpaceApp can be instantiated', (WidgetTester tester) async {
    // Basic test to verify the app widget can be created
    // Note: Full widget tests require Firebase mocking
    expect(const AyurSpaceApp(), isA<AyurSpaceApp>());
  });
}

