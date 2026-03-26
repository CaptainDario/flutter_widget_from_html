/// CSS Counter Styles Level 3 algorithm engine and predefined style registry.
/// https://www.w3.org/TR/css-counter-styles-3/

enum _System { alphabetic, numeric, additive }

/// Implements the counter representation algorithm for a single counter style.
class CssCounterStyle {
  final _System _system;
  final List<String> _symbols;
  final List<(int, String)> _additiveSymbols;
  final String suffix;
  final (int, int)? _range; // null = auto
  final (int, String)? _pad; // (minLength, padChar)

  const CssCounterStyle._alphabetic({
    required List<String> symbols,
    this.suffix = '.',
    (int, int)? range,
  })  : _system = _System.alphabetic,
        _symbols = symbols,
        _additiveSymbols = const [],
        _range = range,
        _pad = null;

  const CssCounterStyle._numeric({
    required List<String> symbols,
    this.suffix = '.',
    (int, int)? range,
    (int, String)? pad,
  })  : _system = _System.numeric,
        _symbols = symbols,
        _additiveSymbols = const [],
        _range = range,
        _pad = pad;

  const CssCounterStyle._additive({
    required List<(int, String)> additiveSymbols,
    this.suffix = '.',
    (int, int)? range,
  })  : _system = _System.additive,
        _symbols = const [],
        _additiveSymbols = additiveSymbols,
        _range = range,
        _pad = null;

  /// Returns the [CssCounterStyle] for the given [type].
  static CssCounterStyle? lookup(String type) => _styles[type];

  /// Returns the formatted marker string for counter value [n],
  /// or null if [n] is outside this style's range or unrepresentable.
  String? format(int n) {
    if (!_inRange(n)) return null;
    final rep = _represent(n);
    if (rep == null) return null;

    var result = rep;
    final padSpec = _pad;
    if (padSpec != null) {
      while (result.length < padSpec.$1) {
        result = padSpec.$2 + result;
      }
    }
    return '$result$suffix';
  }

  bool _inRange(int n) {
    final r = _range;
    if (r != null) return n >= r.$1 && n <= r.$2;
    return switch (_system) {
      _System.numeric => true,
      _System.alphabetic => n >= 1,
      _System.additive => n >= 0,
    };
  }

  String? _represent(int n) => switch (_system) {
        _System.alphabetic => _representAlphabetic(n),
        _System.numeric => _representNumeric(n),
        _System.additive => _representAdditive(n),
      };

  // Bijective base-N (a, b, ..., z, aa, ab, ...).
  // Even though the spec does not define the behavior after 26,
  // this is the observed behavior in Chrome for alphabetic styles
  // when the value exceeds the number of symbols.
  String? _representAlphabetic(int n) {
    if (n < 1) return null;
    final len = _symbols.length;
    if (len < 2) return null;
    var num = n;
    final chars = <String>[];
    while (num > 0) {
      num -= 1;
      chars.add(_symbols[num % len]);
      num = num ~/ len;
    }
    return chars.reversed.join();
  }

  // Standard positional (0, 1, ..., 9, 10, 11, ...).
  String? _representNumeric(int n) {
    final len = _symbols.length;
    if (len < 2) return null;
    if (n == 0) return _symbols[0];
    final isNeg = n < 0;
    var num = n.abs();
    final chars = <String>[];
    while (num > 0) {
      chars.add(_symbols[num % len]);
      num = num ~/ len;
    }
    final result = chars.reversed.join();
    return isNeg ? '-$result' : result;
  }

  // Additive (e.g. roman numerals, armenian, georgian, hebrew).
  String? _representAdditive(int n) {
    if (n < 0) return null;
    if (n == 0) {
      for (final (w, s) in _additiveSymbols) {
        if (w == 0) return s;
      }
      return null;
    }
    var remaining = n;
    final buf = StringBuffer();
    for (final (weight, sym) in _additiveSymbols) {
      if (weight == 0) break;
      while (remaining >= weight) {
        buf.write(sym);
        remaining -= weight;
      }
      if (remaining == 0) break;
    }
    return remaining == 0 ? buf.toString() : null;
  }
}

// ---------------------------------------------------------------------------
// Predefined counter style instances
// https://www.w3.org/TR/css-counter-styles-3/#predefined-counters
// ---------------------------------------------------------------------------

const _decimal = CssCounterStyle._numeric(
  symbols: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
);

const _decimalLeadingZero = CssCounterStyle._numeric(
  symbols: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
  pad: (2, '0'),
);

const _arabicIndic = CssCounterStyle._numeric(
  symbols: ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'],
);

const _armenian = CssCounterStyle._additive(
  range: (1, 9999),
  additiveSymbols: [
    (9000, 'ք'), (8000, 'փ'), (7000, 'ւ'), (6000, 'ց'),
    (5000, 'ր'), (4000, 'տ'), (3000, 'վ'), (2000, 'ս'),
    (1000, 'ռ'), (900, 'ջ'), (800, 'պ'), (700, 'չ'),
    (600, 'ո'), (500, 'շ'), (400, 'ն'), (300, 'յ'),
    (200, 'մ'), (100, 'ճ'), (90, 'ղ'), (80, 'ձ'),
    (70, 'հ'), (60, 'կ'), (50, 'ծ'), (40, 'խ'),
    (30, 'լ'), (20, 'ի'), (10, 'ժ'), (9, 'թ'),
    (8, 'ը'), (7, 'է'), (6, 'զ'), (5, 'ե'),
    (4, 'դ'), (3, 'գ'), (2, 'բ'), (1, 'ա'),
  ],
);

const _bengali = CssCounterStyle._numeric(
  symbols: ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'],
);

const _cambodian = CssCounterStyle._numeric(
  symbols: ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'],
);

const _cjkDecimal = CssCounterStyle._numeric(
  symbols: ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'],
);

const _cjkEarthlyBranch = CssCounterStyle._alphabetic(
  symbols: ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'],
);

const _cjkHeavenlyStem = CssCounterStyle._alphabetic(
  symbols: ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'],
);

const _devanagari = CssCounterStyle._numeric(
  symbols: ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'],
);

const _georgian = CssCounterStyle._additive(
  range: (1, 19999),
  additiveSymbols: [
    (10000, 'ჵ'), (9000, 'ჰ'), (8000, 'ჯ'), (7000, 'ხ'),
    (6000, 'ჭ'), (5000, 'წ'), (4000, 'ძ'), (3000, 'ც'),
    (2000, 'ჩ'), (1000, 'შ'), (900, 'ყ'), (800, 'ღ'),
    (700, 'ქ'), (600, 'ფ'), (500, 'უ'), (400, 'ტ'),
    (300, 'ს'), (200, 'რ'), (100, 'ჟ'), (90, 'ჳ'),
    (80, 'პ'), (70, 'ო'), (60, 'ჲ'), (50, 'ნ'),
    (40, 'մ'), (30, 'լ'), (20, 'ი'), (10, 'ժ'),
    (9, 'თ'), (8, 'ჱ'), (7, 'զ'), (6, 'ვ'),
    (5, 'ե'), (4, 'դ'), (3, 'გ'), (2, 'բ'), (1, 'ա'),
  ],
);

const _gujarati = CssCounterStyle._numeric(
  symbols: ['૦', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯'],
);

const _gurmukhi = CssCounterStyle._numeric(
  symbols: ['੦', '੧', '੨', '੩', '੪', '੫', '੬', '੭', '੮', '੯'],
);

const _hangul = CssCounterStyle._alphabetic(
  symbols: ['가', '나', '다', '라', '마', '바', '사', '아', '자', '차', '카', '타', '파', '하'],
);

const _hangulConsonant = CssCounterStyle._alphabetic(
  symbols: ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'],
);

const _hebrew = CssCounterStyle._additive(
  range: (1, 1099),
  additiveSymbols: [
    (400, 'ת'), (300, 'ש'), (200, 'ר'), (100, 'ק'),
    (90, 'צ'), (80, 'פ'), (70, 'ע'), (60, 'ס'),
    (50, 'נ'), (40, 'מ'), (30, 'ל'), (20, 'כ'),
    (10, 'י'), (9, 'ט'), (8, 'ח'), (7, 'ז'),
    (6, 'ו'), (5, 'ה'), (4, 'դ'), (3, 'გ'),
    (2, 'ב'), (1, 'א'),
  ],
);

const _hiragana = CssCounterStyle._alphabetic(
  symbols: [
    'あ', 'い', 'う', 'え', 'お', 'か', 'き', 'く', 'け', 'こ', 'さ', 'し', 'す', 'せ', 'そ',
    'た', 'ち', 'つ', 'て', 'と', 'な', 'に', 'ぬ', 'ね', 'の', 'は', 'ひ', 'ふ', 'へ', 'ほ',
    'ま', 'み', 'む', 'め', 'も', 'や', 'ゆ', 'よ', 'ら', 'り', 'る', 'れ', 'ろ', 'わ', 'ゐ',
    'ゑ', 'を', 'ん',
  ],
);

const _hiraganaIroha = CssCounterStyle._alphabetic(
  symbols: [
    'い', 'ろ', 'は', 'に', 'ほ', 'へ', 'と', 'ち', 'り', 'ぬ', 'る', 'を', 'わ', 'か', 'よ',
    'た', 'れ', 'そ', 'つ', 'ね', 'な', 'ら', 'む', 'う', 'ゐ', 'の', 'お', 'く', 'や', 'ま',
    'け', 'ふ', 'こ', 'え', 'て', 'あ', 'さ', 'き', 'ゆ', 'め', 'み', 'し', 'ゑ', 'ひ', 'も',
    'せ', 'す',
  ],
);

const _kannada = CssCounterStyle._numeric(
  symbols: ['೦', '೧', '೨', '೩', '೪', '೫', '೬', '೭', '೮', '೯'],
);

const _katakana = CssCounterStyle._alphabetic(
  symbols: [
    'ア', 'イ', 'ウ', 'エ', 'オ', 'カ', 'キ', 'ク', 'ケ', 'コ', 'サ', 'シ', 'ス', 'セ', 'ソ',
    'タ', 'チ', 'ツ', 'テ', 'ト', 'ナ', 'ニ', 'ヌ', 'ネ', 'ノ', 'ハ', 'ヒ', 'フ', 'ヘ', 'ホ',
    'マ', 'ミ', 'ム', 'メ', 'モ', 'ヤ', 'ユ', 'ヨ', 'ラ', 'リ', 'ル', 'レ', 'ロ', 'ワ', 'ヰ',
    'ヱ', 'ヲ', 'ン',
  ],
);

const _katakanaIroha = CssCounterStyle._alphabetic(
  symbols: [
    'イ', 'ロ', 'ハ', 'ニ', 'ホ', 'ヘ', 'ト', 'チ', 'リ', 'ヌ', 'ル', 'ヲ', 'ワ', 'カ', 'ヨ',
    'タ', 'レ', 'ソ', 'ツ', 'ネ', 'ナ', 'ラ', 'ム', 'ウ', 'ヰ', 'ノ', 'オ', 'ク', 'ヤ', 'マ',
    'ケ', 'フ', 'コ', 'エ', 'テ', 'ア', 'サ', 'キ', 'ユ', 'メ', 'ミ', 'シ', 'ヱ', 'ヒ', 'モ',
    'セ', 'ス',
  ],
);

const _khmer = _cambodian;

const _lao = CssCounterStyle._numeric(
  symbols: ['໐', '໑', '໒', '໓', '໔', '໕', '໖', '໗', '໘', '໙'],
);

const _lowerAlpha = CssCounterStyle._alphabetic(
  symbols: [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
  ],
);

const _lowerGreek = CssCounterStyle._alphabetic(
  symbols: [
    'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ', 'ν',
    'ξ', 'ο', 'π', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω',
  ],
);

const _lowerRoman = CssCounterStyle._additive(
  range: (1, 3999),
  additiveSymbols: [
    (1000, 'm'), (900, 'cm'), (500, 'd'), (400, 'cd'),
    (100, 'c'), (90, 'xc'), (50, 'l'), (40, 'xl'),
    (10, 'x'), (9, 'ix'), (5, 'v'), (4, 'iv'), (1, 'i'),
  ],
);

const _malayalam = CssCounterStyle._numeric(
  symbols: ['൦', '൧', '൨', '൩', '൪', '൫', '൬', '൭', '൮', '൯'],
);

const _mongolian = CssCounterStyle._numeric(
  symbols: ['᠐', '᠑', '᠒', '᠓', '᠔', '᠕', '᠖', '᠗', '᠘', '᠙'],
);

const _myanmar = CssCounterStyle._numeric(
  symbols: ['၀', '၁', '၂', '၃', '၄', '၅', '၆', '၇', '၈', '၉'],
);

const _oriya = CssCounterStyle._numeric(
  symbols: ['୦', '୧', '୨', '୩', '୪', '୫', '୬', '୭', '୮', '୯'],
);

const _persian = CssCounterStyle._numeric(
  symbols: ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'],
);

const _tamil = CssCounterStyle._numeric(
  symbols: ['௦', '௧', '௨', '௩', '௪', '௫', '௬', '௭', '௮', '௯'],
);

const _telugu = CssCounterStyle._numeric(
  symbols: ['౦', '౧', '౨', '౩', '౪', '౫', '౬', '౭', '౮', '౯'],
);

const _thai = CssCounterStyle._numeric(
  symbols: ['๐', '๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙'],
);

const _tibetan = CssCounterStyle._numeric(
  symbols: ['༠', '၁', '༢', '༣', '༤', '၅', '၆', '၇', '༨', '၉'],
);

const _urdu = CssCounterStyle._numeric(
  symbols: ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'],
);

const _upperAlpha = CssCounterStyle._alphabetic(
  symbols: [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  ],
);

const _upperRoman = CssCounterStyle._additive(
  range: (1, 3999),
  additiveSymbols: [
    (1000, 'M'), (900, 'CM'), (500, 'D'), (400, 'CD'),
    (100, 'C'), (90, 'XC'), (50, 'L'), (40, 'XL'),
    (10, 'X'), (9, 'IX'), (5, 'V'), (4, 'IV'), (1, 'I'),
  ],
);

const _styles = {
  'arabic-indic': _arabicIndic,
  'armenian': _armenian,
  'bengali': _bengali,
  'cambodian': _cambodian,
  'cjk-decimal': _cjkDecimal,
  'cjk-earthly-branch': _cjkEarthlyBranch,
  'cjk-heavenly-stem': _cjkHeavenlyStem,
  'decimal': _decimal,
  'decimal-leading-zero': _decimalLeadingZero,
  'devanagari': _devanagari,
  'georgian': _georgian,
  'gujarati': _gujarati,
  'gurmukhi': _gurmukhi,
  'hangul': _hangul,
  'hangul-consonant': _hangulConsonant,
  'hebrew': _hebrew,
  'hiragana': _hiragana,
  'hiragana-iroha': _hiraganaIroha,
  'kannada': _kannada,
  'katakana': _katakana,
  'katakana-iroha': _katakanaIroha,
  'khmer': _khmer,
  'lao': _lao,
  'lower-alpha': _lowerAlpha,
  'lower-armenian': _armenian,
  'lower-greek': _lowerGreek,
  'lower-latin': _lowerAlpha,
  'lower-roman': _lowerRoman,
  'malayalam': _malayalam,
  'mongolian': _mongolian,
  'myanmar': _myanmar,
  'oriya': _oriya,
  'persian': _persian,
  'tamil': _tamil,
  'telugu': _telugu,
  'thai': _thai,
  'tibetan': _tibetan,
  'upper-alpha': _upperAlpha,
  'upper-armenian': _armenian,
  'upper-latin': _upperAlpha,
  'upper-roman': _upperRoman,
  'urdu': _urdu,
};
