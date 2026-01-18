import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ayurspace_flutter/widgets/section_card.dart';
import 'package:ayurspace_flutter/widgets/gradient_card.dart';
import 'package:ayurspace_flutter/widgets/stat_item.dart';
import 'package:ayurspace_flutter/widgets/section_header.dart';
import 'package:ayurspace_flutter/widgets/tag_badge.dart';

void main() {
  group('SectionCard Widget Tests', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              child: Text('Test Content'),
            ),
          ),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('applies custom padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionCard(
              padding: EdgeInsets.all(24),
              child: Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, const EdgeInsets.all(24));
    });
  });

  group('GradientCard Widget Tests', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientCard(
              gradientColors: [Colors.blue, Colors.green],
              child: Text('Gradient Test'),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Test'), findsOneWidget);
    });

    testWidgets('applies gradient colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientCard(
              gradientColors: [Colors.red, Colors.orange],
              child: Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
    });
  });

  group('StatItem Widget Tests', () {
    testWidgets('displays value and label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatItem(
              value: '42',
              label: 'Plants Scanned',
            ),
          ),
        ),
      );

      expect(find.text('42'), findsOneWidget);
      expect(find.text('Plants Scanned'), findsOneWidget);
    });

    testWidgets('applies custom value color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatItem(
              value: '100',
              label: 'Score',
              valueColor: Colors.purple,
            ),
          ),
        ),
      );

      final valueText = tester.widget<Text>(find.text('100'));
      expect((valueText.style?.color), Colors.purple);
    });
  });

  group('SectionHeader Widget Tests', () {
    testWidgets('displays title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Featured Plants',
            ),
          ),
        ),
      );

      expect(find.text('Featured Plants'), findsOneWidget);
    });

    testWidgets('shows action button when actionText is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Section',
              actionText: 'View All',
            ),
          ),
        ),
      );

      expect(find.text('View All'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('hides action button when actionText is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Section Only',
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('calls onActionTap when action is tapped',
        (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Section',
              actionText: 'Action',
              onActionTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Action'));
      expect(wasTapped, isTrue);
    });
  });

  group('TagBadge Widget Tests', () {
    testWidgets('displays text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TagBadge(
              text: 'Vata',
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('Vata'), findsOneWidget);
    });

    testWidgets('applies color to text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TagBadge(
              text: 'Pitta',
              color: Colors.red,
            ),
          ),
        ),
      );

      final badgeText = tester.widget<Text>(find.text('Pitta'));
      expect((badgeText.style?.color), Colors.red);
    });

    testWidgets('has light background based on color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TagBadge(
              text: 'Kapha',
              color: Colors.green,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNotNull);
    });
  });
}
