import 'dart:io';

import 'package:args/args.dart';
import 'package:colorpalette/colorpalette.dart';

const help = 'help';
const name = 'name';
const text = 'text';
const bg = 'bg';

void main(List<String> arguments) {
  exitCode = 0;

  final parser = ArgParser()
    ..addFlag(help, abbr: 'h')
    ..addFlag(name, abbr: 'n')
    ..addOption(text, abbr: 't')
    ..addOption(bg, abbr: 'b');
  final argResults = parser.parse(arguments);

  if (argResults[help] as bool) {
    printHelp();
    return;
  }

  final b = argResults[bg] as String?;
  if (b != null) {
    try {
      if (b.startsWith('#')) {
        background(b.substring(1));
      } else {
        background(b);
      }
    } on Exception catch (e) {
      stdout
        ..writeln('Invalid background color: $b')
        ..writeln(e);
      return;
    }
  }

  showPalette(
    showName: argResults[name] as bool,
    text: argResults[text] as String?,
  );
}

void showPalette({required bool showName, String? text}) {
  put('  NAME      500L    500P    500D    600L    600P    600D  ');
  for (final p in palette) {
    // ignore: prefer_interpolation_to_compose_strings
    final fg = p.name +
        ' ${fgText(p.color500light, showName: showName, text: text)}' +
        ' ${fgText(p.color500, showName: showName, text: text)}' +
        ' ${fgText(p.color500dark, showName: showName, text: text)}' +
        ' ${fgText(p.color600light, showName: showName, text: text)}' +
        ' ${fgText(p.color600, showName: showName, text: text)}' +
        ' ${fgText(p.color600dark, showName: showName, text: text)}';
    // ignore: prefer_interpolation_to_compose_strings
    final bg = ' '.padLeft(p.name.length) +
        ' ${bgText(p.color500light)}' +
        ' ${bgText(p.color500)}' +
        ' ${bgText(p.color500dark)}' +
        ' ${bgText(p.color600light)}' +
        ' ${bgText(p.color600)}' +
        ' ${bgText(p.color600dark)}';
    put(fg);
    put(bg);
  }
}

void printHelp() {
  stdout.writeln('''
ryota2357's color palette (using material color).

Options:

  --help   -h
      Show help.

  --name   -n
      Display color code.

  --text   -t  [args: String]
      Use specified text as text of forground color sample.
      If use with --name options, this option is ignored.

  --fg     -f  [args: String]
      Set forground color of normal text.
      Defaut: "#000000"

  --bg     -b  [args: String]
      Set background color of normal text.
      Defaut: "#ffffff"
  ''');
}
