import 'dart:io';

import 'package:workbook/src/configuration.dart';

class WorkBookException implements Exception {
  const WorkBookException({
    this.message = '',
  });

  final String message;

  @override
  String toString() {
    return message;
  }
}

class WorkBookError extends Error {
  WorkBookError({
    this.message = '',
  });

  final String message;

  @override
  String toString() {
    return message;
  }
}

class WorkBookDirectoryNotExist extends WorkBookError {
  WorkBookDirectoryNotExist(this.directory);

  @override
  String get message => 'Directory does not exist: $directory';

  final Directory directory;
}

class WorkBookPubspecNotFound extends WorkBookError {
  WorkBookPubspecNotFound();

  @override
  String get message => 'File $pubspecName not found.';
}

class WorkBookPubspecUnknownFormat extends WorkBookError {
  WorkBookPubspecUnknownFormat();

  @override
  String get message => 'File $pubspecName is in unknown format.';
}

class WorkBookConfigurationLoadFailed extends WorkBookError {
  WorkBookConfigurationLoadFailed();

  @override
  String get message => 'Failed to load configuration from $pubspecName.';
}

class WorkBookTaskNotFound extends WorkBookError {
  WorkBookTaskNotFound(this.name);

  final String? name;

  @override
  String get message => name == null
      ? 'Failed to find default task'
      : 'Failed to find task: $name.';
}

class WorkBookTaskIsNotFunction extends WorkBookError {
  WorkBookTaskIsNotFunction(this.name);

  final String name;

  @override
  String get message => 'Task $name is not a function.';
}

class WorkBookMultiTaskDeclared extends WorkBookError {
  WorkBookMultiTaskDeclared(this.name);

  final String name;

  @override
  String get message => 'Task $name has more than 1 @Task annotation.';
}

class WorkBookTaskWithSameName extends WorkBookError {
  WorkBookTaskWithSameName(this.name);

  final String name;

  @override
  String get message => 'Task $name has more than 1 function.';
}

class WorkBookMultiDefaultTaskDeclared extends WorkBookError {
  WorkBookMultiDefaultTaskDeclared();

  @override
  String get message => 'More than 1 @DefaultTask annotation.';
}
