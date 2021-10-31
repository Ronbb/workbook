import 'dart:mirrors';

import 'package:workbook/src/configuration.dart';
import 'package:workbook/src/workbook.dart';

Future<void> start() async {
  final configuration = await Configuration.load();

  final mirrorSystem = currentMirrorSystem();
  final entry = await mirrorSystem.isolate.loadUri(
    configuration.entry,
  );

  final workbook = Workbook.fromEntry(entry);
  workbook.run();

  // final build = entry.getField(Symbol('build'));
  // build.reflectee();

  return;
}
