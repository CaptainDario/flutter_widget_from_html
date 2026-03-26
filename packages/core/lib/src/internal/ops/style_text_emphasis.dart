part of '../core_ops.dart';

const kCssTextEmphasis = 'text-emphasis';
const kCssTextEmphasisStyle = 'text-emphasis-style';
const kCssTextEmphasisStyleDot = 'dot';

extension StyleTextEmphasisOps on WidgetFactory {
  BuildOp get styleTextEmphasisDot => const BuildOp.v2(
        debugLabel: kCssTextEmphasis,
        onParsed: _applyDotEmphasis,
      );

  static BuildTree _applyDotEmphasis(BuildTree tree) {
    final replacement = tree.parent.sub();
    for (final bit in tree.children) {
      if (bit is TextBit) {
        replacement.append(
          TextBit(replacement, _addCombiningDotAbove(bit.data)),
        );
      } else {
        replacement.append(bit);
      }
    }
    return replacement;
  }

  static String _addCombiningDotAbove(String input) {
    if (input.isEmpty) {
      return input;
    }
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(char);
      if (char.trim().isNotEmpty) {
        buffer.write('\u0307');
      }
    }
    return buffer.toString();
  }
}
