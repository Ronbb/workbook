class Task {
  const Task([this.description]);

  final String? description;
}

const task = Task();

class DefaultTask extends Task {
  const DefaultTask([String description = '']) : super(description);
}

const defaultTask = DefaultTask();

class Dependency {
  const Dependency(this.task);

  final Function task;
}
