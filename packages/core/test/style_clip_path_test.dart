import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_ops.dart';

import '_.dart';

void main() {
  Future<CssClipPathClipper> getClipper(
      WidgetTester tester, String style) async {
    final html =
        '<div style="width: 200px; height: 100px; clip-path: $style">Foo</div>';
    await explain(tester, html);

    final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
    final clipper = clipPath.clipper;
    expect(clipper, isA<CssClipPathClipper>());

    return clipper! as CssClipPathClipper;
  }

  testWidgets('polygon', (WidgetTester tester) async {
    final clipper = await getClipper(
      tester,
      'polygon(0% 0%, 100% 0%, 50% 100%)',
    );

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 20)), isTrue);
    expect(path.contains(const Offset(20, 90)), isFalse);
  });

  testWidgets('circle', (WidgetTester tester) async {
    final clipper = await getClipper(tester, 'circle(25% at 50% 50%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 50)), isTrue);
    expect(path.contains(const Offset(160, 50)), isFalse);
  });

  testWidgets('ellipse', (WidgetTester tester) async {
    final clipper = await getClipper(tester, 'ellipse(25% 40% at 50% 50%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 50)), isTrue);
    expect(path.contains(const Offset(10, 50)), isFalse);
  });

  testWidgets('inset', (WidgetTester tester) async {
    final clipper = await getClipper(tester, 'inset(10% 20% 30% 40%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 40)), isTrue);
    expect(path.contains(const Offset(40, 10)), isFalse);
  });

  testWidgets('inset round', (WidgetTester tester) async {
    final clipper =
        await getClipper(tester, 'inset(10% 20% 30% 40% round 20px)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 40)), isTrue);
    expect(path.contains(const Offset(81, 11)), isFalse);
  });

  testWidgets('rect', (WidgetTester tester) async {
    // rect() uses inset semantics per CSS spec: each value is the distance
    // inset from its respective edge (same as inset()).
    // rect(10% 20% 10% 20%) on 200x100 → visible rect x:[40,160], y:[10,90].
    final clipper = await getClipper(tester, 'rect(10% 20% 10% 20%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 50)), isTrue);
    expect(path.contains(const Offset(30, 20)), isFalse);
  });

  testWidgets('xywh', (WidgetTester tester) async {
    final clipper = await getClipper(tester, 'xywh(10% 20% 50% 40%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(60, 40)), isTrue);
    expect(path.contains(const Offset(10, 10)), isFalse);
  });

  testWidgets('none', (WidgetTester tester) async {
    const html = '<div style="clip-path: none">Foo</div>';
    await explain(tester, html);

    expect(find.byType(ClipPath), findsNothing);
  });

  // path("...") requires SvgFactory — without it the widget is not clipped.
  testWidgets('path() no-op without SvgFactory', (WidgetTester tester) async {
    const html =
        '<div style="clip-path: path(\'M 0 0 L 100 0 L 50 100 Z\')">Foo</div>';
    await explain(tester, html);

    expect(find.byType(ClipPath), findsNothing);
  });
}
