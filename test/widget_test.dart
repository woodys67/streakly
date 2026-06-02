import 'package:flutter_test/flutter_test.dart';

import 'package:streakly/app.dart';

void main() {
  testWidgets('Streakly app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StreaklyApp());
    await tester.pump();
    expect(find.byType(StreaklyApp), findsOneWidget);
  });
}
