import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_ui/forge_ui.dart';

Widget _host(Widget child) => MaterialApp(
      home: FUITheme(
        tokens: FUITokens.base,
        child:
            Scaffold(body: Center(child: SingleChildScrollView(child: child))),
      ),
    );

void main() {
  group('FUITimeline', () {
    testWidgets('renders a title per node', (tester) async {
      await tester.pumpWidget(_host(const FUITimeline(nodes: [
        FUITimelineNode(title: 'Placed', status: FUITimelineStatus.done),
        FUITimelineNode(title: 'Shipped', status: FUITimelineStatus.active),
        FUITimelineNode(title: 'Delivered'),
      ])));
      expect(find.text('Placed'), findsOneWidget);
      expect(find.text('Shipped'), findsOneWidget);
      expect(find.text('Delivered'), findsOneWidget);
    });

    testWidgets('shows subtitle and timestamp when given', (tester) async {
      await tester.pumpWidget(_host(const FUITimeline(nodes: [
        FUITimelineNode(
            title: 'Placed', subtitle: 'Received', timestamp: '09:24'),
      ])));
      expect(find.text('Received'), findsOneWidget);
      expect(find.text('09:24'), findsOneWidget);
    });
  });

  group('FUIChatBubble', () {
    testWidgets('inbound shows sender name and message', (tester) async {
      await tester.pumpWidget(_host(const FUIChatBubble(
        message: 'Hello',
        senderName: 'Ada',
      )));
      expect(find.text('Ada'), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('outbound hides sender name and shows a status tick',
        (tester) async {
      await tester.pumpWidget(_host(const FUIChatBubble(
        message: 'Hi',
        sender: FUIChatSender.outbound,
        senderName: 'me',
        status: FUIChatStatus.read,
      )));
      expect(find.text('me'), findsNothing); // sender name suppressed outbound
      expect(find.byIcon(FUIIcons.success), findsOneWidget);
    });
  });

  group('FUICalendar', () {
    testWidgets('renders the initial month header', (tester) async {
      await tester.pumpWidget(_host(FUICalendar(
        initialMonth: DateTime(2026, 3),
      )));
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('next/prev navigate the month', (tester) async {
      await tester.pumpWidget(_host(FUICalendar(
        initialMonth: DateTime(2026, 3),
      )));
      await tester.tap(find.byIcon(FUIIcons.chevronRight));
      await tester.pump();
      expect(find.text('April 2026'), findsOneWidget);
      await tester.tap(find.byIcon(FUIIcons.chevronLeft));
      await tester.tap(find.byIcon(FUIIcons.chevronLeft));
      await tester.pump();
      expect(find.text('February 2026'), findsOneWidget);
    });

    testWidgets('tapping a day reports the date', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(_host(FUICalendar(
        initialMonth: DateTime(2026, 3),
        onDateSelected: (d) => picked = d,
      )));
      await tester.tap(find.text('15'));
      await tester.pump();
      expect(picked, DateTime(2026, 3, 15));
    });
  });

  group('FUIFileUpload', () {
    testWidgets('shows prompt and a row per file', (tester) async {
      await tester.pumpWidget(_host(const FUIFileUpload(
        prompt: 'Drop here',
        files: [
          FUIUploadItem(name: 'a.pdf', size: '1 MB'),
          FUIUploadItem(name: 'b.png', progress: 0.5),
        ],
      )));
      expect(find.text('Drop here'), findsOneWidget);
      expect(find.text('a.pdf'), findsOneWidget);
      expect(find.text('b.png'), findsOneWidget);
    });

    testWidgets('uploading row shows a progress bar', (tester) async {
      await tester.pumpWidget(_host(const FUIFileUpload(
        files: [FUIUploadItem(name: 'b.png', progress: 0.5)],
      )));
      expect(find.byType(FUIProgressIndicator), findsOneWidget);
    });

    testWidgets('remove button fires onRemove with the index', (tester) async {
      int? removed;
      await tester.pumpWidget(_host(FUIFileUpload(
        onRemove: (i) => removed = i,
        files: const [
          FUIUploadItem(name: 'a.pdf'),
          FUIUploadItem(name: 'b.png'),
        ],
      )));
      await tester.tap(find.byIcon(FUIIcons.close).last);
      expect(removed, 1);
    });

    testWidgets('onTap fires when the drop zone is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_host(FUIFileUpload(
        prompt: 'Drop here',
        onTap: () => tapped = true,
      )));
      await tester.tap(find.text('Drop here'));
      expect(tapped, isTrue);
    });
  });
}
