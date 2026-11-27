import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aiot_app/app.dart';
import 'package:aiot_app/core/storage/app_storage.dart';

void main() {
  testWidgets('AiotApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await AppStorage.init();

    await tester.pumpWidget(const AiotApp());
    await tester.pump();

    expect(find.byType(AiotApp), findsOneWidget);
  });
}
