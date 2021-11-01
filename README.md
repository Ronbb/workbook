---
title: workbook
---

Make programs do something automatically with workbook. Write in pure dart.

## Features

Define tasks in dart and run them.

## Getting started

See [example](./example) for the full example.

### Add dependency

Add `workbook` to pubspec.yaml **dev_dependencies**.

```yaml
dev_dependencies:
  workbook: <version>
```

### Create script

Create you script anywhere. (like scripts/main.dart)

```text
├─lib
│   *.dart
└─scripts
    main.dart
```

### Make entry

Add `workbook` to **pubspec.yaml**. And write down where you script is in `workbook.entry`. (like scripts/main.dart)

```yaml
workbook:
  entry: scripts/main.dart
```

> `workbook.entry` has a default value `scripts/main.dart`

### Define your tasks

Define your tasks in your script.

```dart
import 'package:workbook/workbook.dart';

@task
void init() {
  print('init');
}

@DefaultTask()
@Dependency(init)
void build() {
  print('build');
}
```

## Usage

Run `flutter pub run workbook` (with flutter) or `pub run workbook` (only dart).

## Preview version

The package is not stable yet, and it won't be stable in a long time.
