import 'dart:io';
import 'dart:math';

var _defaultBg = '\x1B[48;2;255;255;255m';
var _defaultFg = '\x1B[38;2;0;0;0m';
const _reset = '\x1B[0m';

void background(String color) {
  final col = color.startsWith('#') ? color.substring(1) : color;
  if (RegExp(r'^[0-9a-fA-F]{6}').hasMatch(col) == false) {
    throw FormatException('Invalid background color: $color');
  }
  _defaultBg = '\x1B[48;2;r;g;bm'
      .replaceFirst('r', _parseR(col).toString())
      .replaceFirst('g', _parseG(col).toString())
      .replaceFirst('b', _parseB(col).toString());
  final whiteRatio = _calculateContrastRatio(col, 'ffffff');
  final blackRatio = _calculateContrastRatio(col, '000000');
  _defaultFg =
      whiteRatio > blackRatio ? '\x1B[38;2;255;255;255m' : '\x1B[38;2;0;0;0m';
}

String bgText(String color) {
  final r = _parseR(color);
  final g = _parseG(color);
  final b = _parseB(color);
  return '\x1B[2;48;2;$r;$g;${b}m       $_defaultBg';
}

String fgText(String color, {bool showName = true, String? text}) {
  final r = _parseR(color);
  final g = _parseG(color);
  final b = _parseB(color);
  final t = showName ? '#$color' : text?.padLeft(7) ?? 'abc1230';
  return '\x1B[1;38;2;$r;$g;${b}m$t$_defaultFg';
}

void put(String msg) {
  stdout.write('$_reset$_defaultBg$_defaultFg $msg $_reset \n');
}

class ColorUnit {
  const ColorUnit({
    required this.name,
    required this.color500light,
    required this.color500,
    required this.color500dark,
    required this.color600light,
    required this.color600,
    required this.color600dark,
  });
  final String name;
  final String color500light;
  final String color500;
  final String color500dark;
  final String color600light;
  final String color600;
  final String color600dark;
}

int _parseR(String color) => int.parse(color.substring(0, 2), radix: 16);
int _parseG(String color) => int.parse(color.substring(2, 4), radix: 16);
int _parseB(String color) => int.parse(color.substring(4, 6), radix: 16);

double _calculateContrastRatio(String color1, String color2) {
  double calculateRelativeLuminance(num r, num g, num b) {
    double luminance(double c) {
      final u = c / 255;
      if (u <= 0.03928) {
        return u / 12.92;
      } else {
        return pow((u + 0.055) / 1.055, 2.4) as double;
      }
    }

    final lr = luminance(r.toDouble());
    final lg = luminance(g.toDouble());
    final lb = luminance(b.toDouble());
    return 0.2126 * lr + 0.7152 * lg + 0.0722 * lb;
  }

  final luminance1 = calculateRelativeLuminance(
    _parseR(color1),
    _parseG(color1),
    _parseB(color1),
  );
  final luminance2 = calculateRelativeLuminance(
    _parseR(color2),
    _parseG(color2),
    _parseB(color2),
  );

  final bright = max(luminance1, luminance2);
  final dark = min(luminance1, luminance2);
  return (bright + 0.05) / (dark + 0.05);
}
