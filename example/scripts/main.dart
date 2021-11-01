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
