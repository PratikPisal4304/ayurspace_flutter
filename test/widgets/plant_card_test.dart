import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:ayurspace_flutter/widgets/plant_card.dart';
import 'package:ayurspace_flutter/data/models/plant.dart';

void main() {
  const testPlant = Plant(
    id: 'test_1',
    name: 'Tulsi',
    hindi: 'तुलसी',
    scientificName: 'Ocimum sanctum',
    image: 'https://example.com/tulsi.jpg',
    doshas: ['Vata', 'Kapha'],
    benefits: ['Immunity', 'Respiratory'],
    rating: 4.8,
    category: 'Herbs',
    difficulty: 'Easy',
    season: ['Summer'],
    description: 'Holy basil is a sacred plant in India',
    uses: ['Cold', 'Fever'],
    dosage: '5 leaves daily',
    precautions: 'None known',
    growingTips: 'Full sun, well-drained soil',
    harvestTime: '90 days',
  );

  group('PlantCard Widget Tests', () {
    testWidgets('displays plant name correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                height: 250,
                child: PlantCard(plant: testPlant),
              ),
            ),
          ),
        );

        expect(find.text('Tulsi'), findsOneWidget);
      });
    });

    testWidgets('displays Hindi name', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                height: 250,
                child: PlantCard(plant: testPlant),
              ),
            ),
          ),
        );

        expect(find.text('तुलसी'), findsOneWidget);
      });
    });

    testWidgets('displays rating', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                height: 250,
                child: PlantCard(plant: testPlant),
              ),
            ),
          ),
        );

        expect(find.text('4.8'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });
    });

    testWidgets('displays dosha badges', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                height: 250,
                child: PlantCard(plant: testPlant),
              ),
            ),
          ),
        );

        expect(find.text('Vata'), findsOneWidget);
        expect(find.text('Kapha'), findsOneWidget);
      });
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool wasTapped = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                height: 250,
                child: PlantCard(
                  plant: testPlant,
                  onTap: () => wasTapped = true,
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(PlantCard));
        expect(wasTapped, isTrue);
      });
    });

    testWidgets('limits dosha badges to 2', (WidgetTester tester) async {
      const plantWithManyDoshas = Plant(
        id: 'test_2',
        name: 'Test Plant',
        hindi: 'परीक्षण',
        scientificName: 'Test plant',
        image: 'https://example.com/test.jpg',
        doshas: ['Vata', 'Pitta', 'Kapha'],
        benefits: ['Test'],
        rating: 4.0,
        category: 'Herbs',
        difficulty: 'Easy',
        season: ['Summer'],
        description: 'Test',
        uses: ['Test'],
        dosage: 'Test',
        precautions: 'Test',
        growingTips: 'Test',
        harvestTime: '30 days',
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200,
                height: 250,
                child: PlantCard(plant: plantWithManyDoshas),
              ),
            ),
          ),
        );

        // Should only show first 2 doshas
        expect(find.text('Vata'), findsOneWidget);
        expect(find.text('Pitta'), findsOneWidget);
        expect(find.text('Kapha'), findsNothing);
      });
    });
  });
}
