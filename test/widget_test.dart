// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, key-verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:narcolib_app/app.dart';
import 'package:narcolib_app/screens/report/pdf_report_screen.dart';

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

    // 4. Tap GENERATE PDF REPORT and verify navigation to PdfReportScreen
    await tester.tap(pdfReportFinder);
    await tester.pumpAndSettle();
    expect(find.text('Official PDF Documentation'), findsOneWidget);
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

  testWidgets('gallery screen renders correctly and displays evidence cards', (WidgetTester tester) async {
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

    // 2. Tap Gallery button to navigate to Gallery screen
    final galleryBtnFinder = find.text('Gallery');
    await tester.ensureVisible(galleryBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(galleryBtnFinder);
    await tester.pumpAndSettle();

    // 3. Verify title and records rendered on the Gallery Screen
    expect(find.text('EVIDENCE GALLERY'), findsOneWidget);
    expect(find.text('Heroin'), findsOneWidget);
    expect(find.text('SMP-20491'), findsOneWidget);
    expect(find.text('94.7%'), findsOneWidget);
    expect(find.text('2026-06-27'), findsWidgets);

    // 4. Tap Upload Evidence and check SnackBar
    final uploadBtnFinder = find.text('UPLOAD EVIDENCE');
    final galleryListFinder = find.byType(ListView);
    await tester.dragUntilVisible(
      uploadBtnFinder,
      galleryListFinder,
      const Offset(0, -100),
    );
    await tester.pumpAndSettle();
    await tester.tap(uploadBtnFinder);
    await tester.pumpAndSettle();

    expect(find.text('Upload Evidence flow simulated successfully.'), findsOneWidget);
  });

  testWidgets('location screen renders correctly and SOS dialog works', (WidgetTester tester) async {
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

    // 2. Tap Geo Map button to navigate to Location screen
    final geoMapBtnFinder = find.text('Geo Map');
    await tester.ensureVisible(geoMapBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(geoMapBtnFinder);
    await tester.pumpAndSettle();

    // 3. Verify elements on the Location Screen
    expect(find.text('GEOSPATIAL INTEL'), findsOneWidget);
    expect(find.text('GPS LOCK: ACTIVE'), findsOneWidget);
    expect(find.text('6.9271° N'), findsOneWidget);
    expect(find.text('79.8612° E'), findsOneWidget);

    // 4. Scroll down to build and reveal the SOS button and recent incidents
    final locationListFinder = find.byType(ListView);
    final sosBtnFinder = find.text('TRIGGER EMERGENCY SOS');
    await tester.dragUntilVisible(
      sosBtnFinder,
      locationListFinder,
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();

    // Verify scrolled items are now visible
    expect(find.text('Recent Incident Intel'), findsOneWidget);
    expect(find.text('Heroin Scan'), findsOneWidget);

    // 5. Tap SOS and verify dialog
    await tester.tap(sosBtnFinder);
    await tester.pumpAndSettle();

    expect(find.text('EMERGENCY SOS'), findsOneWidget);
    expect(find.text('CONFIRM SOS'), findsOneWidget);

    // 6. Confirm SOS alert and verify SnackBar
    await tester.tap(find.text('CONFIRM SOS'));
    await tester.pumpAndSettle();

    expect(find.text('SOS Broadcast Sent. Dispatch notified.'), findsOneWidget);
  });

  testWidgets('PdfReportScreen renders correctly and interactive dialogs show', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PdfReportScreen(),
      ),
    );

    // Verify title and headers render
    expect(find.text('FORENSIC REPORT'), findsOneWidget);
    expect(find.text('Official PDF Documentation'), findsOneWidget);
    expect(find.text('NARCOTICS CONTROL BOARD'), findsOneWidget);
    
    // Verify static details render
    expect(find.text('REP-2026-98124'), findsOneWidget);
    expect(find.text('Officer ABC Perera'), findsOneWidget);
    expect(find.text('Heroin (Diacetylmorphine)'), findsOneWidget);
    expect(find.text('94.7%'), findsOneWidget);
    expect(find.text('HIGH RISK'), findsOneWidget);

    // Scroll down to build and reveal buttons
    final downloadBtnFinder = find.text('DOWNLOAD PDF');
    await tester.dragUntilVisible(
      downloadBtnFinder,
      find.byType(ListView),
      const Offset(0, -100),
    );
    await tester.pumpAndSettle();

    // Verify buttons render
    expect(downloadBtnFinder, findsOneWidget);
    expect(find.text('SHARE REPORT'), findsOneWidget);
    expect(find.text('Back to Profile'), findsOneWidget);

    // Tap DOWNLOAD PDF and check SnackBar
    await tester.tap(downloadBtnFinder);
    await tester.pumpAndSettle();
    expect(find.text('Downloading report PDF... (Simulation)'), findsOneWidget);

    // Tap SHARE REPORT and check SnackBar
    await tester.tap(find.text('SHARE REPORT'));
    await tester.pumpAndSettle();
    expect(find.text('Sharing forensic report... (Simulation)'), findsOneWidget);
  });

  testWidgets('help screen renders correctly and displays guide topics', (WidgetTester tester) async {
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

    // 2. Tap Help button to navigate to Help screen
    final helpBtnFinder = find.text('Help');
    await tester.ensureVisible(helpBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(helpBtnFinder);
    await tester.pumpAndSettle();

    // 3. Verify elements on the Help Screen
    expect(find.text('USER MANUAL'), findsOneWidget);
    expect(find.text('How to scan a substance'), findsOneWidget);

    final helpListFinder = find.byType(ListView);

    final topic2Finder = find.text('How to read AI confidence');
    await tester.dragUntilVisible(topic2Finder, helpListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(topic2Finder, findsOneWidget);

    final topic3Finder = find.text('How to generate a report');
    await tester.dragUntilVisible(topic3Finder, helpListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(topic3Finder, findsOneWidget);

    final topic4Finder = find.text('How to use location support');
    await tester.dragUntilVisible(topic4Finder, helpListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(topic4Finder, findsOneWidget);

    final topic5Finder = find.text('Safety and legal disclaimer');
    await tester.dragUntilVisible(topic5Finder, helpListFinder, const Offset(0, -80));
    await tester.pumpAndSettle();
    expect(topic5Finder, findsOneWidget);

    // Expand "Safety and legal disclaimer" to check content
    await tester.tap(topic5Finder);
    await tester.pumpAndSettle();

    expect(find.text('This software is designated for authorized law enforcement personnel only.'), findsOneWidget);
  });
}

