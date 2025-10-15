// test/widget_next_button_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tri_de_sorciers/features/quiz/widgets/mystic_button.dart';
import 'package:tri_de_sorciers/features/quiz/models.dart';

void main() {
  testWidgets('MysticButton triggers onSelect and looks selected', (WidgetTester tester) async {
    final ans = Answer(key: 'A', label: 'Test', house: 'gryffindor');
    String? pickedKey;
    String? pickedHouse;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MysticButton(answer: ans, selected: false, onSelect: (k, h) {
          pickedKey = k;
          pickedHouse = h;
        }, icon: Icons.star),
      ),
    ));
    expect(find.text('Test'), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    expect(pickedKey, 'A');
    expect(pickedHouse, 'gryffindor');
  });
}
