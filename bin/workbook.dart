import 'dart:io';

import 'package:workbook/src/arguments.dart';
import 'package:workbook/src/start.dart';

Future<void> main(List<String> args) {
  workBookArguments.addAll(args);
  return start().catchError((e) {
    print(e);
    exit(-1);
  });
}
