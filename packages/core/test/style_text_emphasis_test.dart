import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  group('text-emphasis: dot', () {
    testWidgets('adds combining dot above each character', (tester) async {
      const html = '<span style="text-emphasis: dot">Hello</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:H\u0307e\u0307l\u0307l\u0307o\u0307)]'));
    });

    testWidgets('skips whitespace characters', (tester) async {
      const html = '<span style="text-emphasis: dot">a b</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:a\u0307 b\u0307)]'));
    });

    testWidgets('empty string produces no output', (tester) async {
      const html = '<span style="text-emphasis: dot"></span>';
      final e = await explain(tester, html);
      expect(e, equals('[widget0]'));
    });
  });

  group('text-emphasis-style: dot', () {
    testWidgets('adds combining dot above each character', (tester) async {
      const html = '<span style="text-emphasis-style: dot">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:H\u0307i\u0307)]'));
    });
  });

  group('text-emphasis non-dot values are ignored', () {
    testWidgets('circle value does not transform text', (tester) async {
      const html = '<span style="text-emphasis: circle">Hello</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:Hello)]'));
    });
  });
}
