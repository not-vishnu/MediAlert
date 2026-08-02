import 'package:flutter_test/flutter_test.dart';
import 'package:medialert_ai/main.dart';

void main() {
  testWidgets('MediAlert AI launches successfully', (
    WidgetTester tester,
  ) async {
    // Build the app
    await tester.pumpWidget(const MediAlertAI());

    // Wait for animations and initialization
    await tester.pumpAndSettle();

    // If no exception is thrown, the test passes.
    expect(find.byType(MediAlertAI), findsOneWidget);
  });
}
