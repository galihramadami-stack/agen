import 'package:flutter_test/flutter_test.dart';
import 'package:agen_flutter/main.dart';

void main() {
  testWidgets('ValorantApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ValorantApp());
    expect(find.text('Daftar Agen Valorant'), findsOneWidget);
  });
}
