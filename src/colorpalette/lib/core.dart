import 'dart:io';

var _defaultBg = '\x1B[48;2;255;255;255m';
var _defaultFg = '\x1B[38;2;0;0;0m';
const _reset = '\x1B[0m';

int _parseR(String color) => int.parse(color.substring(0, 2), radix: 16);
int _parseG(String color) => int.parse(color.substring(2, 4), radix: 16);
int _parseB(String color) => int.parse(color.substring(4, 6), radix: 16);

void background(String color) => _defaultBg = '\x1B[48;2;r;g;bm'
    .replaceFirst('r', _parseR(color).toString())
    .replaceFirst('g', _parseG(color).toString())
    .replaceFirst('b', _parseB(color).toString());
void forground(String color) => _defaultFg = '\x1B[38;2;r;g;bm'
    .replaceFirst('r', _parseR(color).toString())
    .replaceFirst('g', _parseG(color).toString())
    .replaceFirst('b', _parseB(color).toString());

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
