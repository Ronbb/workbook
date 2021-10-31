import 'dart:mirrors';

import 'package:workbook/src/annotations.dart' as annotations;
import 'package:workbook/src/error.dart';

class Workbook {
  Workbook._();

  Map<String, _Task> tasks = {};

  _Task? defaultTask;

  bool get hasDefaultTask => defaultTask != null;

  factory Workbook.fromEntry(LibraryMirror entry) {
    return _WorkbookFactory(entry).workbook;
  }

  void run([String? taskName]) {
    final task =
        taskName == null || taskName.isEmpty ? defaultTask : tasks[taskName];
    if (task == null) {
      throw WorkBookTaskNotFound(taskName);
    }

    task.run();
  }
}

class _WorkbookFactory {
  _WorkbookFactory(this.entry) {
    load();
  }

  final workbook = Workbook._();

  final LibraryMirror entry;

  void load() {
    loadBaseTasks();
    check();
  }

  void loadBaseTasks() {
    for (var declarationEntry in entry.declarations.entries) {
      final symbol = declarationEntry.key;
      final declaration = declarationEntry.value;
      final instance = entry.getField(symbol);

      bool isDefault = false;
      _Task? declaratedTask;

      for (var meta in declaration.metadata) {
        final annotation = meta.reflectee;
        if (annotation is annotations.Task) {
          if (declaration is! MethodMirror || instance is! ClosureMirror) {
            throw WorkBookTaskIsNotFunction(symbol.toString());
          }

          if (declaratedTask != null) {
            throw WorkBookMultiTaskDeclared(symbol.toString());
          }

          declaratedTask = _Task(
            workbook: workbook,
            symbol: symbol,
            declaration: declaration,
            instance: instance,
            annotation: annotation,
          );
        }

        if (annotation is annotations.DefaultTask) {
          isDefault = true;
        }
      }

      if (declaratedTask == null) {
        continue;
      }

      if (workbook.tasks.containsKey(symbol.toString())) {
        throw WorkBookTaskWithSameName(symbol.toString());
      }

      workbook.tasks[symbol.toString()] = declaratedTask;

      if (isDefault) {
        if (workbook.defaultTask != null) {
          throw WorkBookMultiDefaultTaskDeclared();
        }
        workbook.defaultTask = declaratedTask;
      }
    }
  }

  void check() {}
}

class _Task {
  _Task({
    required this.workbook,
    required this.symbol,
    required this.declaration,
    required this.instance,
    required this.annotation,
  });

  final Workbook workbook;

  final Symbol symbol;

  final ClosureMirror instance;

  final MethodMirror declaration;

  final annotations.Task annotation;

  final List<_Dependency> _dependencies = [];

  Function get function => instance.reflectee;

  String? get description => annotation.description;

  void run() {
    _loadDependencies();
    for (var dep in _dependencies) {
      dep.run();
    }

    function.call();
  }

  void _loadDependencies() {
    if (_dependencies.isNotEmpty) {
      return;
    }

    for (var meta in declaration.metadata) {
      final annotation = meta.reflectee;
      if (annotation is annotations.Dependency) {
        final task = workbook.tasks.values.firstWhere(
          (task) => task.function == annotation.task,
          orElse: () {
            throw WorkBookTaskNotFound(annotation.task.toString());
          },
        );
        _dependencies.add(_Dependency(task: task));
      }
    }
  }
}

class _Dependency {
  _Dependency({
    required this.task,
  });

  _Task task;

  void run() {
    task.run();
  }
}
