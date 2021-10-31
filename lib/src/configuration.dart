import 'dart:io';

import 'package:path/path.dart';
import 'package:workbook/src/error.dart';
import 'package:yaml/yaml.dart';

const pubspecName = 'pubspec.yaml';

const defaultEntryPath = 'scripts/main.dart';

class Configuration {
  const Configuration({
    required this.entry,
  });

  static Future<Configuration> load() async {
    final file = await findPubspec();
    final data = await loadPubspec(file);

    final rawEntry = data['entry'] ?? defaultEntryPath;
    Uri entry;

    if (rawEntry is String) {
      entry = Uri.parse(rawEntry);
      if (isRelative(rawEntry)) {
        entry = file.parent.uri.resolveUri(entry);
      }
    } else {
      throw WorkBookConfigurationLoadFailed();
    }

    return Configuration(
      entry: entry,
    );
  }

  final Uri entry;
}

Future<File> findPubspec([Uri? root]) async {
  final directory = Directory.fromUri(root ?? Uri.directory(current));
  if (!directory.existsSync()) {
    throw WorkBookDirectoryNotExist(directory);
  }

  final pubspec = File.fromUri(directory.uri.resolve(pubspecName));
  if (!pubspec.existsSync()) {
    if (directory.parent == directory) {
      throw WorkBookPubspecNotFound();
    }
    return findPubspec(directory.parent.uri);
  }

  return pubspec;
}

Future<Map> loadPubspec(File file) async {
  final pubspec = loadYaml(file.readAsStringSync());

  if (pubspec is! Map) {
    throw WorkBookPubspecUnknownFormat();
  }

  return pubspec;
}
