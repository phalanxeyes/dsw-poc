import 'package:flutter_test/flutter_test.dart';

import 'package:clima/main.dart';

void main() {
  testWidgets(
      'Verifica que la aplicación se ejecute y muestre el título "Clima"',
      (WidgetTester tester) async {
    // Construye la app e inicia el test.
    await tester.pumpWidget(ClimaApp());

    // Verifica que el título de la aplicación sea 'Clima'.
    expect(find.text('Clima'), findsOneWidget);

    // Verifica que no haya texto que diga 'Weather App' (por ejemplo, un título incorrecto).
    expect(find.text('Weather App'), findsNothing);
  });
}
