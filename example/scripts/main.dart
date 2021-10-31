import 'package:workbook/workbook.dart';

void main() {}

@task
void init() {
  print('init');
}

@DefaultTask()
@Dependency(init)
void build() {
  print('build');
}
