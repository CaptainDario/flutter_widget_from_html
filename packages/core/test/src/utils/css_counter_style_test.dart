import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/src/utils/css_counter_style.dart';

void main() {
  group('CssCounterStyle', () {
    group('decimal', () {
      final style = CssCounterStyle.lookup('decimal')!;
      test('format(1)', () => expect(style.format(1), '1.'));
      test('format(10)', () => expect(style.format(10), '10.'));
      test('format(0)', () => expect(style.format(0), '0.'));
      test('format(-1)', () => expect(style.format(-1), '-1.'));
      test('format(-10)', () => expect(style.format(-10), '-10.'));
    });

    group('decimal-leading-zero', () {
      final style = CssCounterStyle.lookup('decimal-leading-zero')!;
      test('format(1)', () => expect(style.format(1), '01.'));
      test('format(9)', () => expect(style.format(9), '09.'));
      test('format(10)', () => expect(style.format(10), '10.'));
      test('format(100)', () => expect(style.format(100), '100.'));
      test('format(-1)', () => expect(style.format(-1), '-1.'));
    });

    group('lower-alpha (alphabetic)', () {
      final style = CssCounterStyle.lookup('lower-alpha')!;
      test('format(1)', () => expect(style.format(1), 'a.'));
      test('format(26)', () => expect(style.format(26), 'z.'));
      test('format(27) - bijective base-N', () {
        // Observed behavior in Chrome: 27 -> aa
        expect(style.format(27), 'aa.');
      });
      test('format(52)', () => expect(style.format(52), 'az.'));
      test('format(53)', () => expect(style.format(53), 'ba.'));
      test('format(702)', () => expect(style.format(702), 'zz.'));
      test('format(703)', () => expect(style.format(703), 'aaa.'));
      test('format(0) - out of range', () => expect(style.format(0), null));
      test('format(-1) - out of range', () => expect(style.format(-1), null));
    });

    group('upper-alpha', () {
      final style = CssCounterStyle.lookup('upper-alpha')!;
      test('format(1)', () => expect(style.format(1), 'A.'));
      test('format(26)', () => expect(style.format(26), 'Z.'));
      test('format(27)', () => expect(style.format(27), 'AA.'));
    });

    group('lower-roman (additive)', () {
      final style = CssCounterStyle.lookup('lower-roman')!;
      test('format(1)', () => expect(style.format(1), 'i.'));
      test('format(4)', () => expect(style.format(4), 'iv.'));
      test('format(5)', () => expect(style.format(5), 'v.'));
      test('format(7)', () => expect(style.format(7), 'vii.'));
      test('format(9)', () => expect(style.format(9), 'ix.'));
      test('format(10)', () => expect(style.format(10), 'x.'));
      test('format(90)', () => expect(style.format(90), 'xc.'));
      test('format(1416)', () => expect(style.format(1416), 'mcdxvi.'));
      test('format(3847)', () => expect(style.format(3847), 'mmmdcccxlvii.'));
      test('format(3999)', () => expect(style.format(3999), 'mmmcmxcix.'));
      test('format(0) - out of range', () => expect(style.format(0), null));
      test('format(4000) - out of range',
          () => expect(style.format(4000), null));
      test('format(-55) - out of range', () => expect(style.format(-55), null));
    });

    group('upper-roman (ported from roman_numerals_converter_test.dart)', () {
      final style = CssCounterStyle.lookup('upper-roman')!;
      test('GIVEN 0 THEN returns null', () => expect(style.format(0), null));
      test('GIVEN negative THEN returns null',
          () => expect(style.format(-55), null));
      test('GIVEN 7 THEN returns VII.', () => expect(style.format(7), 'VII.'));
      test('GIVEN 90 THEN returns XC.', () => expect(style.format(90), 'XC.'));
      test('GIVEN 3999 THEN returns MMMCMXCIX.',
          () => expect(style.format(3999), 'MMMCMXCIX.'));
      test('GIVEN 4001 THEN returns null',
          () => expect(style.format(4001), null));
      test('GIVEN 1416 THEN returns MCDXVI.',
          () => expect(style.format(1416), 'MCDXVI.'));
      test('GIVEN 3847 THEN returns MMMDCCCXLVII.',
          () => expect(style.format(3847), 'MMMDCCCXLVII.'));
      test('GIVEN all numbers in range (1-3999) THEN returns not null', () {
        for (var n = 1; n < 4000; n += 1) {
          expect(style.format(n), isNotNull, reason: 'Failed at $n');
        }
      });
    });

    group('lower-greek', () {
      final style = CssCounterStyle.lookup('lower-greek')!;
      test('format(1)', () => expect(style.format(1), 'α.'));
      test('format(24)', () => expect(style.format(24), 'ω.'));
      test('format(25)', () => expect(style.format(25), 'αα.'));
    });

    group('hebrew', () {
      final style = CssCounterStyle.lookup('hebrew')!;
      test('format(1)', () => expect(style.format(1), 'א.'));
      test('format(10)', () => expect(style.format(10), 'י.'));
      test('format(15)', () => expect(style.format(15), 'יה.'));
      test('format(1099)', () => expect(style.format(1099), 'תתרצט.'));
      test('format(1100) - out of range',
          () => expect(style.format(1100), null));
    });

    group('armenian', () {
      final style = CssCounterStyle.lookup('armenian')!;
      test('format(1)', () => expect(style.format(1), 'ա.'));
      test('format(9999)', () => expect(style.format(9999), 'քջղթ.'));
    });

    group('georgian', () {
      final style = CssCounterStyle.lookup('georgian')!;
      test('format(1)', () => expect(style.format(1), 'ա.'));
      test('format(19999)', () => expect(style.format(19999), 'ჵჰყჳთ.'));
    });

    group('arabic-indic', () {
      final style = CssCounterStyle.lookup('arabic-indic')!;
      test('format(1)', () => expect(style.format(1), '١.'));
      test('format(10)', () => expect(style.format(10), '١٠.'));
    });

    group('thai', () {
      final style = CssCounterStyle.lookup('thai')!;
      test('format(1)', () => expect(style.format(1), '๑.'));
      test('format(10)', () => expect(style.format(10), '๑๐.'));
    });

    // may be of interest in the future, currently done using `HtmlListMarker`
    /*group('cyclic standard shapes (disc, circle, square)', () {
      final style = CssCounterStyle.lookup('disc')!;
      // Shapes use a space suffix instead of a dot
      test('format(1)', () => expect(style.format(1), '• '));
      test('format(2)', () => expect(style.format(2), '• '));
      test('format(100)', () => expect(style.format(100), '• '));
      // Cyclic handles 0 and negatives by looping backwards, 
      // but since there's only 1 symbol, it's always the same.
      test('format(0)', () => expect(style.format(0), '• ')); 
      test('format(-5)', () => expect(style.format(-5), '• '));
    });*/

    group('dynamic string literals (cyclic)', () {
      // Test double quotes
      final styleDouble = CssCounterStyle.lookup('"★"')!;
      test('format(1) double quotes', () => expect(styleDouble.format(1), '★'));
      test('format(5) double quotes', () => expect(styleDouble.format(5), '★'));

      // Test single quotes
      final styleSingle = CssCounterStyle.lookup("'👉'")!;
      test(
          'format(1) single quotes', () => expect(styleSingle.format(1), '👉'));
    });

    group('base-N numeric (binary, hex)', () {
      final binary = CssCounterStyle.lookup('binary')!;
      test('binary format(2)', () => expect(binary.format(2), '10.'));
      test('binary format(5)', () => expect(binary.format(5), '101.'));

      final hex = CssCounterStyle.lookup('lower-hexadecimal')!;
      test('hex format(10)', () => expect(hex.format(10), 'a.'));
      test('hex format(15)', () => expect(hex.format(15), 'f.'));
      test('hex format(16)', () => expect(hex.format(16), '10.'));
      test('hex format(255)', () => expect(hex.format(255), 'ff.'));
    });

    group('cjk styles (additive fallback)', () {
      final style = CssCounterStyle.lookup('cjk-ideographic')!;

      test('format(1)', () => expect(style.format(1), '一、'));
      test('format(10)', () => expect(style.format(10), '一十、'));
      test('format(11)', () => expect(style.format(11), '一十一、'));

      test('format(101) - additive fallback',
          () => expect(style.format(101), '一百一、'));

      test('format(9999)', () => expect(style.format(9999), '九千九百九十九、'));
      test('format(0)', () => expect(style.format(0), '零、'));
    });

    test('lookup(invalid)', () => expect(CssCounterStyle.lookup('foo'), null));
  });
}
