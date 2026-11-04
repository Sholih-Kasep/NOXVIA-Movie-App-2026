
import 'package:flutter_test/flutter_test.dart';
import 'package:noxvia/main.dart';

void main() {
  testWidgets('NOXVIA homepage test', (WidgetTester tester) async {
    await tester.pumpWidget(const NoxviaApp());

    expect(find.text('NOXVIA'), findsOneWidget);
    expect(find.text('Trending Now'), findsOneWidget);
    expect(find.text('Popular Movies'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });
}
