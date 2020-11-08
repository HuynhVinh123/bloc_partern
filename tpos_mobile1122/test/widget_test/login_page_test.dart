import 'package:flutter_test/flutter_test.dart';
import 'package:tpos_mobile/application/login/login_page.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/locator_2.dart';

void main() {
  setupNewLocator();
  setupLocator();
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Test code goes here.
    await tester.pumpWidget(LoginPage());
    final inputUsernameFinder = find.text('Máy chủ');
  });
}
