/// Define your [Task] with [description].
class Task {
  const Task([this.description]);

  final String? description;
}

/// An easy way to define your [Task].
const task = Task();

/// Define your [DefaultTask] with [description].
class DefaultTask extends Task {
  const DefaultTask([String description = '']) : super(description);
}

/// An easy way to define your [DefaultTask].
const defaultTask = DefaultTask();

/// Define a [Dependency] for a [Task].
class Dependency {
  const Dependency(this.task);

  final Function task;
}
