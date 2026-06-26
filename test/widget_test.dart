// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, key-verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:narcolib_app/app.dart';

void main() {
  testWidgets('NarcoLib home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const NarcoLibApp());

    expect(find.text('NARCOLIB'), findsWidgets);
    expect(find.text('OFFICER LOGIN'), findsOneWidget);
    expect(find.text('REGISTER'), findsOneWidget);
  });

  testWidgets('login navigates to profile screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NarcoLibApp());

    await tester.tap(find.text('OFFICER LOGIN'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Secure Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Secure Login'));
    await tester.pumpAndSettle();

    expect(find.text('OFFICER PROFILE'), findsOneWidget);
  });

  testWidgets('register navigates to profile screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NarcoLibApp());

    await tester.tap(find.text('REGISTER'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Complete Registration'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete Registration'));
    await tester.pumpAndSettle();

    expect(find.text('OFFICER PROFILE'), findsOneWidget);
  });

  testWidgets('profile navigates to scanner screen and scanner renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const NarcoLibApp());

    // 1. Log in to get to the profile screen
    await tester.tap(find.text('OFFICER LOGIN'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Secure Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Secure Login'));
    await tester.pumpAndSettle();

    // Verify we are on the PROFILE screen
    expect(find.text('OFFICER PROFILE'), findsOneWidget);

    // Scroll the profile screen ListView down to build/reveal the quick access grid
    final listFinder = find.byType(ListView);
    await tester.drag(listFinder, const Offset(0, -400));
    await tester.pumpAndSettle();

    // 2. Navigate to Scanner Screen
    final newScanFinder = find.text('New Scan');
    await tester.ensureVisible(newScanFinder);
    await tester.pumpAndSettle();
    await tester.tap(newScanFinder);
    await tester.pumpAndSettle();

    // 3. Verify elements on the Scanner Screen
    expect(find.text('BACK'), findsOneWidget);
    expect(find.text('Capture the substance'), findsOneWidget);
    expect(find.text('START SCAN'), findsOneWidget);
    expect(find.text('GEO MAP'), findsOneWidget);
    expect(find.text('HISTORY'), findsOneWidget);
    expect(find.text('GALLERY'), findsOneWidget);
  });

  testWidgets('scanner screen navigates to result screen and result renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const NarcoLibApp());

    // 1. Navigate to Scanner Screen
    await tester.tap(find.text('OFFICER LOGIN'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Secure Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Secure Login'));
    await tester.pumpAndSettle();

    final listFinder = find.byType(ListView);
    await tester.drag(listFinder, const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Scan'));
    await tester.pumpAndSettle();

    // 2. Tap START SCAN on Scanner Screen to navigate to Result Screen
    await tester.tap(find.text('START SCAN'));
    await tester.pumpAndSettle();

    // 3. Verify details on the Result Screen
    expect(find.text('ANALYSIS COMPLETE'), findsOneWidget);
    expect(find.text('Heroin Detected'), findsOneWidget);
    expect(find.text('HIGH RISK'), findsOneWidget);
    expect(find.text('AI CONFIDENCE'), findsOneWidget);
    expect(find.text('94.7%'), findsOneWidget);
    expect(find.text('Legal Classification'), findsOneWidget);

    // Scroll to reveal and verify remaining panels step-by-step
    final resultListFinder = find.byType(ListView);
    
    final recommendedActionsFinder = find.text('Recommended Actions');
    await tester.dragUntilVisible(recommendedActionsFinder, resultListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(recommendedActionsFinder, findsOneWidget);

    final alternativeMatchesFinder = find.text('Alternative Matches');
    await tester.dragUntilVisible(alternativeMatchesFinder, resultListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(alternativeMatchesFinder, findsOneWidget);

    final scanMetadataFinder = find.text('Scan Metadata');
    await tester.dragUntilVisible(scanMetadataFinder, resultListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(scanMetadataFinder, findsOneWidget);

    final pdfReportFinder = find.text('GENERATE PDF REPORT');
    await tester.dragUntilVisible(pdfReportFinder, resultListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(pdfReportFinder, findsOneWidget);

    expect(find.text('SAVE TO HISTORY'), findsOneWidget);
    expect(find.text('NEW SCAN'), findsOneWidget);
  });

  testWidgets('profile navigates to history screen and delete/undo/view-report actions work', (WidgetTester tester) async {
    await tester.pumpWidget(const NarcoLibApp());

    // 1. Navigate to Profile Screen
    await tester.tap(find.text('OFFICER LOGIN'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Secure Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Secure Login'));
    await tester.pumpAndSettle();

    // Scroll to quick access grid
    final listFinder = find.byType(ListView);
    await tester.drag(listFinder, const Offset(0, -400));
    await tester.pumpAndSettle();

    // 2. Tap History button to navigate to History screen
    final historyBtnFinder = find.text('History');
    await tester.ensureVisible(historyBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(historyBtnFinder);
    await tester.pumpAndSettle();

    // 3. Verify title and records rendered on the History Screen
    expect(find.text('SCAN HISTORY'), findsOneWidget);
    expect(find.text('Heroin (Diacetylmorphine)'), findsOneWidget);

    // 4. Test DELETE action on a record (e.g. Heroin (Diacetylmorphine))
    final heroinCardFinder = find.ancestor(
      of: find.text('Heroin (Diacetylmorphine)'),
      matching: find.byWidgetPredicate((w) => w.runtimeType.toString() == '_HistoryRecordCard'),
    );
    final heroinDeleteBtnFinder = find.descendant(
      of: heroinCardFinder,
      matching: find.text('DELETE'),
    );
    
    await tester.ensureVisible(heroinDeleteBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(heroinDeleteBtnFinder);
    await tester.pumpAndSettle();

    // Verify it is removed from list
    expect(find.text('Heroin (Diacetylmorphine)'), findsNothing);
    expect(find.text('Heroin (Diacetylmorphine) removed from history.'), findsOneWidget);

    // Tap UNDO on the snackbar
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    // Verify it is restored in the list
    expect(find.text('Heroin (Diacetylmorphine)'), findsOneWidget);

    // 5. Scroll to build and reveal the Aspirin record
    final historyListFinder = find.byType(ListView);
    final aspirinFinder = find.text('Aspirin (Acetylsalicylic Acid)');
    await tester.dragUntilVisible(aspirinFinder, historyListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(aspirinFinder, findsOneWidget);

    // 6. Test VIEW REPORT action (scroll back up to Heroin card)
    final heroinCardRestoredFinder = find.ancestor(
      of: find.text('Heroin (Diacetylmorphine)'),
      matching: find.byWidgetPredicate((w) => w.runtimeType.toString() == '_HistoryRecordCard'),
    );
    final heroinViewReportBtnFinder = find.descendant(
      of: heroinCardRestoredFinder,
      matching: find.text('VIEW REPORT'),
    );
    
    await tester.dragUntilVisible(heroinViewReportBtnFinder, historyListFinder, const Offset(0, 80));
    await tester.pumpAndSettle();
    await tester.tap(heroinViewReportBtnFinder);
    await tester.pumpAndSettle();

    // Verify we navigated to the Result Screen
    expect(find.text('ANALYSIS COMPLETE'), findsOneWidget);
    expect(find.text('Heroin Detected'), findsOneWidget);
  });
}

