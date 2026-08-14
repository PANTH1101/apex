// Basic Flutter widget test for Event Management App

import 'package:flutter_test/flutter_test.dart';
import 'package:event_management_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EventManagementApp());

    // Verify that app title is present
    expect(find.text('Event Management App'), findsOneWidget);
    
    // Verify that test button is present
    expect(find.text('Test Backend Connection'), findsOneWidget);
  });
}
